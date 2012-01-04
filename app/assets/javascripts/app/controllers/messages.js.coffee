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
    
  close: ->
    @el.trigger('close')
    
  keypress: (e) ->
    if e.keyCode is 13 and (e.shiftKey or e.metaKey)
      @submit(e)
    
  submit: (e) ->
    e.preventDefault()
    message = Message.fromForm(@form)
      
    return unless message.to and message.body

    conversation = null
    
    # Save message before creating conversation, 
    # as we don't want conversation_id to be sent
    # to the server
    message.save success: ->
      Spine.Ajax.disable =>
        conversation.changeID(@conversation_id)
      conversation.ajax().reload()
    
    # Create a empty conversation and navigate to it
    Spine.Ajax.disable =>
      conversation = App.Conversation.create(user: App.user)
      message.conversation(conversation)
      message.save()
      
    @close()
    @navigate '/conversations', conversation.cid
  
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