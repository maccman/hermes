# Bind to Macgap's wake/online events

jQuery ($) ->
  $(window).bind 'wake online', ->
    location.reload()