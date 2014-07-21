this.JobList = class JobList extends ViewBase
  bindEvents: (evtRouter) =>
    evtRouter.on 'twitter:jobsdatareceived', @showJobs
    evtRouter.on 'twitter:jobsdataerror', @showError
    evtRouter.on 'twitter:newjobcreated', (_, jobObj) => @addJob(jobObj)
    evtRouter.on 'twitter:jobupdated', (_, jobObj) => @updateJob(jobObj)
    evtRouter.on 'twitter:jobupdateerror', @showError
    evtRouter.on 'twitter:jobrejected', (_, jobObj) => @removeJob(jobObj)

  clearJobs: =>
    @$el.empty()

  showJobs: (evt, jobsObj) =>
    @clearJobs()
    jobsObj.jobs.map(@addJob)
    jobsObj.jobs.map(@getJobDetail)

  addJob: (jobObj) =>
    job = new Job(@renderJob(jobObj))
    @$el.prepend(job.$el)

  removeJob: (jobObj) =>
    $('#' + jobObj.uuid).remove()

  renderJob: (jobObj) =>
    $(HandlebarsTemplates['job'](jobObj))

  getJobDetail: (jobObj) =>
    $(document).trigger('twitter:jobdetailrequested', jobObj.uuid)

  updateJob: (jobObj) =>
    newJob = new Job(@renderJob(jobObj))
    oldJob = $('#' + jobObj.uuid)
    isTargeted = oldJob.hasClass('targeted')
    isHidden = oldJob.hasClass('hide')
    oldJob.replaceWith(newJob.$el)
    newJob.$el.addClass('hide') if isHidden
    newJob.$el.addClass('targeted') if isTargeted

  showError: (evt, jqXHR) =>
    if jqXHR.status == 500
      @$el.prepend "<div class=\"alert alert-danger alert-dismissable\"><button type=\"button\" class=\"close\" data-dismiss=\"alert\"><span aria-hidden=\"true\">&times;</span><span class=\"sr-only\">Close</span></button><strong>Uh oh!</strong> #{jqXHR.responseText}</div>"
