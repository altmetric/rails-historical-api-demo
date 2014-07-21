describe 'JobList', ->
  unit = undefined
  fakeJobObj = {uuid: 'UUID'}
  beforeEach ->
    unit = new JobList($('<header><h2>Activity Volume</h2><h5 class="subheader"></h5></header>'))

  describe '#addJob', ->
    it 'should add a job given valid JSON object', ->
      unit.addJob(fakeJobObj)
      expect(unit.$el.find('.job')[0].id).toBe fakeJobObj.uuid

  describe '#showHeader', ->
    xit 'should only call show() if there is a non-zero count', ->
      spy = sinon.spy(unit, 'show')
      unit.showHeader(null, {data: [0, 0]})
      expect(spy.called).toBeFalsy()
      unit.showHeader(null, {data: [233, 342]})
      expect(spy.called).toBeTruthy()
