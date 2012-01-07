Conversation = App.Conversation

class App.Nav extends Spine.Controller
  elements:
    '[data-type=messages]': 'messages'
  
  constructor: ->
    super
    @render()
    
    Conversation.bind 'change refresh', @renderCount
    
  render: ->
    @replace @view('nav')(App.user)
    
  renderCount: =>
    count = Conversation.unreadCount()
    @messages.attr('data-count', count or '')    