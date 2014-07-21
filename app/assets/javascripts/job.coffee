this.Job = class Job extends ViewBase
  bindEvents: (evtRouter) =>
    evtRouter.on 'twitter:searchupdated', (evt, search) =>
      values = (v for own _, v of @$el.data() when v)
      matches = values.filter((v) -> ('' + v).toLowerCase().indexOf(search.toLowerCase()) != -1).length > 0
      if matches then @$el.removeClass('hide') else @$el.addClass('hide')

    @$el.on 'click', '.js-action-accept', (evt) =>
      evtRouter.trigger('twitter:jobupdaterequested', {uuid: @$el.attr('id'), action: $(evt.target).data('action')})

    @$el.on 'click', '.js-action-reject', (evt) =>
      evtRouter.trigger('twitter:jobrejected', {uuid: @$el.attr('id')})
      evtRouter.trigger('twitter:jobupdaterequested', {uuid: @$el.attr('id'), action: $(evt.target).data('action')})

    @$el.on 'click', '.js-action-download', (evt) =>
      evtRouter.trigger('twitter:jobdownloadrequested', {uuid: @$el.attr('id'), action: $(evt.target).data('action')})

    @$el.on 'click', '.js-job-link', (evt) =>
      evt.preventDefault()
      @$el.toggleClass('targeted')

    setTimeout((=> evtRouter.trigger('twitter:jobdetailrequested', @$el.attr('id'))), 60000)

    # TODO: on 'click', '.js-action-clone' evtRouter.trigger('twitter:jobcloned', ...)
