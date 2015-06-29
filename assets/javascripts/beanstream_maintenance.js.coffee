# Tiny library for checking for a beanstream outage.
# Returns a promise that resolves with the availability of the gateway. 
#
# Should probably be abstracted to "credit card gateway" instead of any specific payment processor.
#
# Used like:
# window.BeanstreamMaintenance.getStatus().done(function(response){
#   if (response != 'ok') {
#     window.BeanstreamMaintenance.showWarning();
#   } else {
#     // allow payment processing
#   } 
# }).fail(function(){
#   // allow payment processing
# });

window.BeanstreamMaintenance = {}
bm = window.BeanstreamMaintenance

# When there is upcoming beanstream maintenance set this to true.
bm.upcoming_maintenance = false

# Fetches current status of cc gateway. will return "ok" if available, something
# else if not. Argument is a timeout, defaults to 2000ms.
bm.getStatus = if bm.upcoming_maintenance
  (timeout)->
    timeout ||= 2000
    cacheBuster = new Date().getTime()
    $.ajax("/beanstream_status?t="+cacheBuster, timeout: timeout)
else
  () -> $.Deferred().resolve("ok").promise()

# Show a warning message about the processor being unavailable, and log in sentry.
# The layout you're using has to include the _js_errors for Raven to be available.
bm.showWarning = ()->
  Raven.captureMessage("Credit card signup during maintenance")
  modal = new ModalMessage({
    title: "Currently unavailable",
    html: "We're very sorry, but our credit card processor is currently unavailable. Please use PayPal, try again later, or <a href='mailto:info@format.com'>email us</a> for help.",
    modal_class: 'small warning'
  })
