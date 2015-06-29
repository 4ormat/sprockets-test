blacklistTests = [
  navigator.userAgent.indexOf("MSIE") > -1 # Internet Explorer
  # !window.Notification? # A feature that is supported on all evergreen browsers, but not Safari 5.1
]
document.location = "/unsupported_browser" if $.inArray(true, blacklistTests) > -1
