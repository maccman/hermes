#= require app/controllers/messages

$ = Spine.$
  
class App.Starred extends Spine.Controller
  className: 'messages starred'
    
  events:
    'click .newMessage': 'newMessage'
  
  constructor: ->
    super
    @render()
      
  render: ->
    @append @aside = new App.Starred.Aside
    @append $('<div />').addClass('vdivide')
    @append @article = new App.Starred.Article
    
    @routes
      '/starred/:id': (params) ->
        @active()
        @aside.active(params)
        @article.active(params)
      '/starred': ->
        @active()
        @aside.selectFirst()
        
  newMessage: ->
    (new App.Compose).open()
    
class App.Starred.Aside extends App.Messages.Aside
  getRecords: ->
    App.Conversation.starred()
    
  click: (e) ->
    itemID = $(e.currentTarget).data('cid')
    @navigate '/starred', itemID

class App.Starred.Article extends App.Messages.Article