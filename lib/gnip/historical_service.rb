require_relative 'http'
require 'yajl'

module Gnip
  class InvalidRequestException < StandardError; end

  class HistoricalService
    include Gnip::HTTP

    def self.get_job(uuid)
      parse_json(HTTP.get(job_url(uuid)))
    end

    def self.get_all_jobs
      parse_json(HTTP.get(jobs_url))
    end

    def self.create_job(opts)
      job_opts = opts.merge!({publisher: 'twitter', streamType: 'track'})
      parse_json(HTTP.post(jobs_url, Yajl::Encoder.encode(job_opts)))
    end

    def self.accept(uuid)
      parse_json(HTTP.put(job_url(uuid), Yajl::Encoder.encode({status: 'accept'})))
    end

    def self.reject(uuid)
      parse_json(HTTP.put(job_url(uuid), Yajl::Encoder.encode({status: 'reject'})))
    end

    def self.get_results(uuid)
      parse_json(HTTP.get(results_url(uuid)))
    end

    private

    def self.base_url
      "https://gnip-api.gnip.com/historical/powertrack/accounts/#{GNIP_ACCOUNT}/publishers/twitter"
    end

    def self.jobs_url
      "#{base_url}/jobs.json"
    end

    def self.job_url(uuid)
      "#{base_url}/jobs/#{uuid}.json"
    end

    def self.results_url(uuid)
      "#{base_url}/jobs/#{uuid}/results.json"
    end

    def self.parse_json(json)
      Yajl::Parser.new(symbolize_keys: true).parse(json)
    end
  end
end
