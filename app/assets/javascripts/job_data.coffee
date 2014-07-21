this.JobData = class JobData
  constructor: ->
    getJobsCallback = (data) -> $(document).trigger('twitter:jobsdatareceived', data)
    getJobsErrback = (jqXHR) -> $(document).trigger('twitter:jobsdataerror', jqXHR)
    @getJobs(getJobsCallback, getJobsErrback)
    @bindEvents($(document))

  bindEvents: (evtRouter) =>
    createJobCallback = (data) -> evtRouter.trigger('twitter:newjobcreated', data)
    createJobErrback = (jqXHR) -> evtRouter.trigger('twitter:createjoberror', jqXHR)
    evtRouter.on 'twitter:newjobsubmitted', (evt, formData) =>
      @createJob(formData, createJobCallback, createJobErrback)

    updateJobCallback = (data) -> evtRouter.trigger('twitter:jobupdated', data)
    updateJobErrback = (jqXHR) -> evtRouter.trigger('twitter:jobupdateerror', jqXHR)
    evtRouter.on 'twitter:jobupdaterequested', (evt, opts) =>
      @updateJob(opts.action, opts.uuid, updateJobCallback, updateJobErrback)
    evtRouter.on 'twitter:jobdetailrequested', (evt, jobUUID) =>
      @getJob(jobUUID, updateJobCallback, updateJobErrback)

  getJob: (jobId, callback, errback) =>
    $.ajax({type: 'get', url: "/jobs/#{jobId}", dataType: 'json', timeout: 60000})
      .success((data) -> callback(data))
      .fail((jqXHR) -> errback(jqXHR) if errback)

  getJobs: (callback, errback) =>
    $.ajax({type: 'get', url: '/jobs', dataType: 'json', timeout: 60000})
      .success((data) -> callback(data))
      .fail((jqXHR) -> errback(jqXHR) if errback)

  createJob: (formData, callback, errback) =>
    $.ajax({type: 'post', url: '/jobs', data: formData, dataType: 'json', timeout: 60000, processData: false, contentType: false})
      .success((data) -> callback(data))
      .fail((jqXHR) -> errback(jqXHR) if errback)

  updateJob: (action, jobId, callback, errback) =>
    $.ajax({type: 'put', url: "/jobs/#{jobId}", data: {status: action}, dataType: 'json', timeout: 60000})
      .success((data) -> callback(data))
      .fail((jqXHR) -> errback(jqXHR) if errback)
