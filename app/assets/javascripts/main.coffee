$ ->
  moment.lang 'en',
    defaultFormat: 'YYYY-MM-DDTHH:mm:ssZ'
    relativeTime:
      future: 'in %s'
      past: '%s'
      s: '%ds'
      m: '1m'
      mm: '%dm'
      h: '1h'
      hh: '%dh'
      d: '1 day'
      dd: '%d days'
      M: '1 month'
      MM: '%d months'
      y: '1 year'
      yy: '%d years'

  window.GNIP =
    search: new Search($('#search'))
    jobList: new JobList($('#job-list'))
    newJobForm: new NewJobForm($('#new-job'))
    jobData: new JobData()

  $('body').on 'keyup', (evt) =>
    # Close new job form and all jobs if ESC is pressed
    window.location.hash = '' if evt.keyCode == 27
    true

  $('.js-datetime-field').datetimepicker({
    useSeconds: false, useCurrent: false, showToday: false
  })

