Handlebars.registerHelper 'friendlydate', (dateStr) ->
  window.moment(dateStr, 'YYYYMMDDHHmm').format('YYYY-MM-DD')

Handlebars.registerHelper 'friendlydatetime', (dateStr) ->
  window.moment(dateStr, 'YYYYMMDDHHmm').format('YYYY-MM-DD HH:mm UTC')

Handlebars.registerHelper 'commaifyNumber', (num) ->
  new String(num).replace(/\B(?=(\d{3})+(?!\d))/g, ',')
