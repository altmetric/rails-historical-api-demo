this.NewJobForm = class NewJobForm extends ViewBase
  constructor: ($el) ->
    super $el

  bindEvents: (evtRouter) =>
    @$el.on 'submit', (evt) =>
      evt.preventDefault()
      # NOTE: FormData object not supported in IE9-
      evtRouter.trigger('twitter:newjobsubmitted', new FormData(evt.target))
      false

    @$el.on 'reset', @resetForm

    evtRouter.on 'twitter:newjobcreated', @resetForm
    evtRouter.on 'twitter:createjoberror', @showError
    evtRouter.on 'twitter:jobcloned', @populate

  resetForm: =>
    window.location.hash = ''

  populate: (evt, jobData) =>
    window.location.hash = '#new-job'
    @$el.find("[name=title]").val(jobData.title)
    @$el.find("[name=format]").select(jobData.format)
    @$el.find("[name=fromDate]").val(jobData.fromdate)
    @$el.find("[name=toDate]").val(jobData.todate)

  showError: (evt, jqXHR) =>
    if jqXHR.status == 400
      @$el.prepend "<div class=\"alert alert-danger alert-dismissable\"><button type=\"button\" class=\"close\" data-dismiss=\"alert\"><span aria-hidden=\"true\">&times;</span><span class=\"sr-only\">Close</span></button><strong>Uh oh!</strong> #{jqXHR.responseText}</div>"
