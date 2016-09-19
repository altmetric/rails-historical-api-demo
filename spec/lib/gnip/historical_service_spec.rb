require 'spec_helper'
require_relative '../../../lib/gnip/historical_service'

describe Gnip::HistoricalService do
  let(:job_uuid) { '7wdexe7dcj' }

  describe '.get_job' do
    it 'retrieves data for job with uuid' do
      stub_request(:get, "https://user%40company.com:password@gnip-api.gnip.com/historical/powertrack/accounts/account/publishers/twitter/jobs/7wdexe7dcj.json").
        to_return(:status => 200, :body => Rails.root.join("fixtures/webmock/get-job-success.json"))

      job = Gnip::HistoricalService.get_job(job_uuid)
      job.should_not be_nil

      expect(job[:format]).to eq('activity_streams')
    end

    it 'propagates HTTP errors' do
      stub_request(:get, "https://user%40company.com:password@gnip-api.gnip.com/historical/powertrack/accounts/account/publishers/twitter/jobs/bogus.json").
        to_return(:status => 404, :body => Rails.root.join("fixtures/webmock/get-job-not-found.json"))

      expect { Gnip::HistoricalService.get_job('bogus') }.to raise_error(/Resource Not Found/)
    end
  end

  describe '.get_all_jobs' do
    it 'retrieves all jobs that are not expired yet' do
      stub_request(:get, "https://user%40company.com:password@gnip-api.gnip.com/historical/powertrack/accounts/account/publishers/twitter/jobs.json").
        to_return(:status => 200, :body => Rails.root.join("fixtures/webmock/get-all-jobs-success.json"))

      jobs = Gnip::HistoricalService.get_all_jobs

      expect(jobs.size).to be(2)
    end
  end

  describe '.create_job' do
    it 'makes request to Historical API to create job' do
      stub_request(:post, "https://user%40company.com:password@gnip-api.gnip.com/historical/powertrack/accounts/account/publishers/twitter/jobs.json").
        to_return(:status => 200, :body => Rails.root.join("fixtures/webmock/create-job-success.json"))

      opts = {dataFormat: 'activity-streams', fromDate: '201601010000', toDate: '201601020000',
              title: 'Mentioning GNIP', rules: [{value: "url_contains:gnip.com"}]}
      job = Gnip::HistoricalService.create_job(opts)

      expect(job[:title]).to eq(opts[:title])
      expect(job[:format]).to eq('activity_streams')
      expect(job[:publisher]).to eq('twitter')
      expect(job[:fromDate]).to eq(opts[:fromDate])
      expect(job[:toDate]).to eq(opts[:toDate])
      expect(job[:account].should_not be_nil)
      expect(job[:status]).to eq('opened')
      expect(job[:statusMessage]).to_not be_nil
      expect(job[:jobURL]).to_not be_nil
    end

    it 'raises InvalidRequestException when missing important values (like title)' do
      stub_request(:post, "https://user%40company.com:password@gnip-api.gnip.com/historical/powertrack/accounts/account/publishers/twitter/jobs.json").
        with(:body => "{\"bogus\":\"totally\",\"publisher\":\"twitter\",\"streamType\":\"track\"}",
             :headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip, deflate', 'Content-Length'=>'62', 'User-Agent'=>'Ruby'}).
        to_return(:status => 400, :body => "", :headers => {})

      expect { Gnip::HistoricalService.create_job({bogus: 'totally'}) }.to raise_error(Gnip::InvalidRequestException)
    end
  end

  describe '.accept' do
    it 'makes request to Historical API to accept job' do
      stub_request(:put, "https://user%40company.com:password@gnip-api.gnip.com/historical/powertrack/accounts/account/publishers/twitter/jobs/7wdexe7dcj.json").
        with(:body => "{\"status\":\"accept\"}").
        to_return(:status => 200, :body => Rails.root.join("fixtures/webmock/accept-job-success.json"), :headers => {})

      expect(Gnip::HistoricalService.accept(job_uuid)[:acceptedAt]).to eq('2012-06-14T22:43:27Z')
    end
  end

  describe '.reject' do
    it 'makes request to Historical API to reject job' do
      stub_request(:put, "https://user%40company.com:password@gnip-api.gnip.com/historical/powertrack/accounts/account/publishers/twitter/jobs/7wdexe7dcj.json").
        with(:body => "{\"status\":\"reject\"}").
        to_return(:status => 200, :body => Rails.root.join("fixtures/webmock/reject-job-success.json"))

      expect(Gnip::HistoricalService.reject(job_uuid)[:acceptedAt]).to eq('2016-09-19T12:57:42Z')
    end
  end

  describe '.get_results' do
    it 'makes request to Historical API to get job results' do
      stub_request(:get, "https://user%40company.com:password@gnip-api.gnip.com/historical/powertrack/accounts/account/publishers/twitter/jobs/7wdexe7dcj/results.json").
        to_return(:status => 200, :body => Rails.root.join("fixtures/webmock/get-results-success.json"))

      expect(Gnip::HistoricalService.get_results(job_uuid)[:expiresAt]).to eq('2012-11-24T18:53:23Z')
    end
  end
end
