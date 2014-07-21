require 'spec_helper'
require 'yajl'

describe JobsController do
  context 'with fake historical service' do
    let(:fake_job) { Yajl::Parser.new(symbolize_keys: true).parse('{"title":"Historical PowerTrack Sample","account":"eriwen","publisher":"twitter","streamType":"track","format":"activity-streams","fromDate":"201407010000","toDate":"201407010001","requestedBy":"ewendelin@gnipcentral.com","requestedAt":"2014-07-07T16:46:49Z","status":"delivered","statusMessage":"Job delivered and available for download.","jobURL":"https://historical.gnip.com:443/accounts/eriwen/publishers/twitter/historical/track/jobs/vpsyf1ryvx.json","quote":{"estimatedActivityCount":100,"estimatedDurationHours":"1.0","estimatedFileSizeMb":"0.0","expiresAt":"2014-07-14T16:48:22Z"},"acceptedBy":"ewendelin@gnipcentral.com","acceptedAt":"2014-07-07T20:43:42Z","results":{"activityCount":14,"fileCount":1,"fileSizeMb":"0.0","completedAt":"2014-07-07T20:49:35Z","dataURL":"https://historical.gnip.com:443/accounts/eriwen/publishers/twitter/historical/track/jobs/vpsyf1ryvx/results.json","expiresAt":"2014-07-22T20:49:13Z"},"percentComplete":100,"rules":"foo"}') }
    let(:fake_job_results) { {urlList: []} }
    let(:fake_jobs) { {jobs: [fake_job]} }
    before do
      # noinspection RubyArgCount
      Gnip::HistoricalService.stub(get_job: fake_job, get_all_jobs: fake_jobs, create_job: fake_job, accept: fake_job, reject: fake_job, get_results: fake_job_results)
    end

    describe '#index' do
      it 'renders all jobs JSON' do
        get :index
        assert_response :success
        Yajl::Parser.new(symbolize_keys: true).parse(@response.body).should == fake_jobs
      end
    end

    describe '#show' do
      it 'renders existing job JSON' do
        get :show, id: 'vpsyf1ryvx'
        assert_response :success
        Yajl::Parser.new(symbolize_keys: true).parse(@response.body).should == fake_job
      end
    end

    describe '#create' do
      it 'returns bad request without rules or rulesFile' do
        post :create, title: 'TITLE', rules: ''
        assert_response :bad_request
      end

      it 'returns bad request with both rules and rulesFile' do
        post :create, title: 'TITLE', rules: 'RULES', rulesFile: 'RULES'
        assert_response :bad_request
      end

      it 'returns bad request given unparseable rulesFile' do
        post :create, title: 'TITLE', rulesFile: 'BOGUS'
        assert_response :bad_request
      end

      it 'returns new job given valid job info' do
        post :create, title: 'TITLE', rules: 'RULES'
        assert_response :success
        Yajl::Parser.new(symbolize_keys: true).parse(@response.body).should == fake_job
      end
    end

    describe '#update' do
      it 'returns updated job JSON' do
        put :update, id: 'vpsyf1ryvx', status: 'accept'
        assert_response :success
        Yajl::Parser.new(symbolize_keys: true).parse(@response.body).should == fake_job
      end
    end

    describe '#download' do
      it 'returns a plain-text file with all job output' do
        get :download, uuid: 'vpsyf1ryvx'
        assert_response :success
      end
    end
  end
end
