#= require app/controllers/messages

$ = Spine.$
  
class App.Activity extends Spine.Controller
  className: 'messages activity'
    
  events:
    'click .newMessage': 'newMessage'
  
  constructor: ->
    super
    @render()
  
  render: ->
    @append @aside = new App.Activity.Aside
    @append $('<div />').addClass('vdivide')
    @append @article = new App.Activity.Article
    
    @routes
      '/activity/:id': (params) ->
        @active()
        @aside.active(params)
        @article.active(params)
      '/activity': ->
        @active()
        @aside.selectFirst()
        
  newMessage: ->
    (new App.Compose).open()
    
class App.Activity.Aside extends App.Messages.Aside
  getRecords: ->
    App.Conversation.activity()
    
  click: (e) ->
    itemID = $(e.currentTarget).data('cid')
    @navigate '/activity', itemID

class App.Activity.Article extends App.Messages.Article