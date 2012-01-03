$       = Spine.$
Message = App.Message

class Compose extends Spine.Controller
  className: 'composeMessage'
    
  events:
    'submit form': 'submit'
    'keypress textarea': 'keypress'

  elements:
    'form': 'form'
  
  open: ->
    @html @view('messages/compose')()
    $.overlay(@el)
    
  keypress: (e) ->
    if e.keyCode is 13 and (e.shiftKey or e.metaKey)
      @submit(e)
    
  submit: (e) ->
    e.preventDefault()
    message = Message.fromForm(@form)
    if message.to and message.body
      message.save()
      @el.trigger('close')
  
class App.Messages extends Spine.Controller
  className: 'messages'
    
  events:
    'click .newMessage': 'newMessage'
  
  constructor: ->
    super
    @render()
    
  render: ->
    @append @aside = new App.Messages.Aside
    @append $('<div />').addClass('vdivide')
    @append @article = new App.Messages.Article
    
    @routes
      '/conversations/:id': (params) ->
        @active()
        @aside.active(params)
        @article.active(params)
        
  newMessage: ->
    (new Compose).open()