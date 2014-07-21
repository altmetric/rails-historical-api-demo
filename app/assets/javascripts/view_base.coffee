this.ViewBase = class ViewBase
  constructor: ($el) ->
    @$el = $el
    @bindEvents($(document))

  show: =>
    @$el.addClass('flip-in')

  hide: =>
    @$el.removeClass('flip-in')

  bindEvents: (evtRouter) =>
