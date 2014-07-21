require 'gnip/historical_service'
require 'yajl'

class JobsController < ApplicationController
  rescue_from 'Exception' do |e|
    render text: e.message, status: :error
  end

  rescue_from 'Gnip::InvalidRequestException' do |e|
    render text: e.message, status: :bad_request
  end

  def index
    # Ignore Rejected jobs - no user action possible
    interesting_jobs = Gnip::HistoricalService.get_all_jobs[:jobs].select { |j| j[:status] != 'rejected' }
    render_json({jobs: interesting_jobs.map { |j| augment_job_data!(j) }.sort_by { |j| j[:phases].size }.reverse})
  end

  def show
    render_json augment_job_data!(Gnip::HistoricalService.get_job(params[:id]))
  end

  def create
    prevent_raw_and_file_rules_input!(params[:rules], params[:rulesFile])
    ensure_raw_or_file_rules_input!(params[:rules], params[:rulesFile])

    job_opts = {dataFormat: params[:format], fromDate: params[:fromDate], toDate: params[:toDate], title: params[:title], rules: hashify_rules(params[:rules], params[:rulesFile])}
    render_json augment_job_data!(Gnip::HistoricalService.create_job(job_opts))
  end

  def update
    render_json augment_job_data!(Gnip::HistoricalService.send(params[:status].to_sym, params[:id]))
  end

  def download
    results = Gnip::HistoricalService.get_results(params[:uuid])

    send_file_headers! type: 'text/plain', filename: "job-#{params[:uuid]}.json"

    # Can easily parallelize this with JRuby
    self.response_body = Enumerator.new do |w|
      results[:urlList].each do |url|
        uri = URI(url)
        res = Net::HTTP.get_response(uri)
        zr = Zlib::GzipReader.new(StringIO.new(res.body))
        zr.each_line do |ln|
          w << ln
        end
      end
    end
  end

  private

  def render_json(hash)
    render json: Yajl::Encoder.encode(hash, {html_safe?: true})
  end

  def hashify_rules(rules_raw, rules_file)
    if rules_raw != ""
      rules_raw.split(/\r?\n/).map { |rule| {value: rule} }
    else
      Yajl::Parser.new(symbolize_keys: true).parse(rules_file.read)
    end
  rescue Yajl::ParseError => e
    raise Gnip::InvalidRequestException.new("Could not parse Rules File JSON: #{e.message}.")
  end

  def prevent_raw_and_file_rules_input!(rules_raw, rules_file)
    if rules_raw != "" && rules_file
      raise Gnip::InvalidRequestException.new('Cannot specify both a rules file and raw rules input')
    end
  end

  def ensure_raw_or_file_rules_input!(rules_raw, rules_file)
    if rules_raw == "" && rules_file.nil?
      raise Gnip::InvalidRequestException.new('Please provide a rules file or raw rules input')
    end
  end

  def augment_job_data!(job)
    # Include list of past and in progress job phases - e.g. (an accepted job would be ['estimating', 'ready', 'running'])
    job[:uuid] = job[:jobURL].match('\/(\w+)\.json$')[1]

    job = add_job_status_detail!(job)

    # Add estimated runtime to running jobs
    if job[:status] == 'running'
      job = add_estimated_runtime!(job)
    else
      job.delete(:percentComplete)
    end

    # Omit irrelevant sections of API response
    job.delete(:quote) if %w(#running #complete #rejected).include?(job[:visible_status])
    job
  end

  def add_job_status_detail!(job)
    snapshot_statuses = [
        ['opened', 'estimating', 'auto_estimating', 'auto_estimate_failed', 'auto_estimate_running'], #estimating:
        ['auto_estimate_complete', 'quoted', 'paused'], #ready:
        ['accepted', 'running', 'completed', 'failed', 'validating', 'invalidated'], #running:
        ['delivered', 'finished'], #complete:
        ['rejected'] #rejected:
    ]
    visible_job_phases = ['#estimating', '#ready', '#running', '#complete', '#rejected']

    snapshot_statuses.each_with_index do |status_group, i|
      if status_group.include?(job[:status])
        job[:phases] = visible_job_phases[0, i+1]
        job[:visible_status] = visible_job_phases[i]
      end
    end

    job
  end

  def add_estimated_runtime!(job)
    if job[:percentComplete].to_f > 0
      hours_running = (DateTime.now.utc - DateTime.iso8601(job[:acceptedAt])).to_f / 60
      job[:timeRemainingHrs] = ((100.0 / job[:percentComplete].to_f - 1) * hours_running).round(1)
    end

    job
  end
end
