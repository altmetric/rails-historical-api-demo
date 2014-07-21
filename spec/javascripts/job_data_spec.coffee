describe 'JobData', ->
  unit = undefined
  requests = undefined
  xhr = undefined

  beforeEach ->
    unit = new JobData()
    requests = []
    xhr = sinon.useFakeXMLHttpRequest()
    xhr.onCreate = (xhr) -> requests.push(xhr)

  afterEach ->
    xhr.restore()

  describe '#getJob', ->
    it 'GETs requested job JSON', ->
      unit.getJob('JOB_ID', sinon.spy())
      expect(requests[0].method).toBe 'GET'
      expect(requests[0].url).toBe '/jobs/JOB_ID'
      requests[0].respond(200, { "Content-Type": "application/json" }, '{data:[]}')

  describe '#getJobs', ->
    it 'GETs all jobs JSON', ->
      unit.getJobs(sinon.spy())
      expect(requests[0].method).toBe 'GET'
      expect(requests[0].url).toBe '/jobs'
      requests[0].respond(200, { "Content-Type": "application/json" }, '{data:[]}')
