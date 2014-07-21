this.Search = class Search extends ViewBase
  bindEvents: (evtRouter) =>
    @$el.on 'keyup', (evt) =>
      evtRouter.trigger('twitter:searchupdated', $(evt.target).val())

    evtRouter.on 'keyup', 'body', (evt) =>
      # Focus the search box when '/' is typed *outside* of the search box
      @$el.focus() if evt.target.tagName.toLowerCase() != 'input' and evt.keyCode == 191
      true
