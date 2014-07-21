require 'spec_helper'
require 'vcr'
require 'vcr_helper'
require_relative '../../../lib/gnip/historical_service'

describe Gnip::HistoricalService do
  let(:job_uuid) { 'vpsyf1ryvx' }

  describe '.get_job' do
    it 'retrieves data for job with uuid' do
      VCR.use_cassette('get-job-success') do
        job = Gnip::HistoricalService.get_job(job_uuid)
        job.should_not be_nil
        job[:format].should == 'activity-streams'
      end
    end

    it 'propagates HTTP errors' do
      VCR.use_cassette('get-job-not-found') do
        invocation = -> { Gnip::HistoricalService.get_job('bogus') }
        invocation.should raise_error
      end
    end
  end

  describe '.get_all_jobs' do
    it 'retrieves all jobs that are not expired yet' do
      VCR.use_cassette('get-all-jobs-success') do
        jobs = Gnip::HistoricalService.get_all_jobs
        jobs.size.should == 2
      end
    end
  end

  describe '.create_job' do
    it 'makes request to Historical API to create job' do
      VCR.use_cassette('create-job-success') do
        opts = {dataFormat: 'activity-streams', fromDate: '201407010000', toDate: '201407010001',
                title: 'TITLE', rules: [{value: 'RULE1'}, {value: 'RULE2', tag: 'TAG'}]}
        job = Gnip::HistoricalService.create_job(opts)
        job[:title].should == opts[:title]
        job[:format].should == opts[:dataFormat]
        job[:publisher].should == 'twitter'
        job[:fromDate].should == opts[:fromDate]
        job[:toDate].should == opts[:toDate]
        job[:account].should_not be_nil
        job[:status].should == 'opened'
        job[:statusMessage].should_not be_nil
        job[:jobURL].should_not be_nil
      end
    end

    it 'raises InvalidRequestException given invalid input' do
      VCR.use_cassette('create-job-invalid') do
        invocation = -> { Gnip::HistoricalService.create_job({bogus: 'totally'}) }
        invocation.should raise_error(Gnip::InvalidRequestException)
      end
    end
  end

  describe '.accept' do
    it 'makes request to Historical API to accept job' do
      VCR.use_cassette('accept-job-success') do
        job = Gnip::HistoricalService.accept(job_uuid)
        job.should_not be_nil
      end
    end
  end

  describe '.reject' do
    it 'makes request to Historical API to reject job' do
      VCR.use_cassette('reject-job-success') do
        job = Gnip::HistoricalService.reject(job_uuid)
        job.should_not be_nil
      end
    end
  end

  describe '.get_results' do
    it 'makes request to Historical API to get job results' do
      VCR.use_cassette('get-results-success') do
        job = Gnip::HistoricalService.get_results(job_uuid)
        job.should_not be_nil
      end
    end
  end
end
