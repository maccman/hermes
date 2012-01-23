#= require app/controllers/messages

$ = Spine.$
  
class App.Starred extends Spine.Controller
  className: 'messages starred'
    
  events:
    'click .newMessage': 'newMessage'
  
  constructor: ->
    super
    @render()
    @active @fetch
  
  fetch: ->
    return if @beenActivated
    App.Conversation.fetchStarred()
    @beenActivated = true
    
  render: ->
    @append @aside = new App.Activity.Aside
    @append $('<div />').addClass('vdivide')
    @append @article = new App.Activity.Article
    
    @routes
      '/starred/:id': (params) ->
        @active()
        @aside.active(params)
        @article.active(params)
      '/starred': ->
        @active()
        
  newMessage: ->
    (new App.Compose).open()
    
class App.Starred.Aside extends App.Messages.Aside
  getRecords: ->
    App.Conversation.starred()

class App.Starred.Article extends App.Messages.Article