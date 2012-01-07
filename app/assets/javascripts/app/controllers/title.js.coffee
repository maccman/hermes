$ = jQuery

$ ->
  title    = $('title')
  original = title.text();
  
  App.Conversation.bind 'change refresh', ->
    count = @unreadCount()
    if count
      title.text(original + " (#{count})")
    else
      title.text(original)