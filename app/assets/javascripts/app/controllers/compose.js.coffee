$       = Spine.$.sub()
Message = App.Message

$.fn.appAutocomplete = (data) ->
  split = (val) ->
    val.split /,\s*/
  
  extractLast = (term) ->
    split(term).pop()
  
  $(@).autocomplete
    minLength: 0
    autoFocus: true
    source: (request, response) ->
      response $.ui.autocomplete.filter(
        data, 
        extractLast(request.term)
      )[0..8]

    focus: ->
      false
    
    select: (event, ui) ->
      terms = split(@value)
      terms.pop()
      terms.push ui.item.value
      terms.push ''
      @value = terms.join(', ')
      false

class App.Compose extends Spine.Controller
  className: 'composeMessage'
    
  events:
    'submit form': 'submit'
    'keypress textarea': 'keypress'

  elements:
    'form': 'form'
    'input[name=to]': 'to'
  
  open: ->
    @html @view('messages/compose')(value: @value)
    $(@to).appAutocomplete(App.user.autocomplete)
    
    $.overlay(@el)
    
  close: ->
    @el.trigger('close')
    
  keypress: (e) ->
    if e.keyCode is 13 and (e.shiftKey or e.metaKey)
      @submit(e)
    
  submit: (e) ->
    e.preventDefault()
    message = Message.fromForm(@form)
    message.from_user(App.user)
      
    return unless message.to and message.body

    conversation = null
    
    # Save message before creating conversation, 
    # as we don't want conversation_id to be sent
    # to the server
    message.save 
      success: ->
        Spine.Ajax.disable =>
          conversation.changeID(@conversation_id)
        conversation.ajax().reload()
      error: ->
        alert('Message send error')
    
    # Create a empty conversation and navigate to it
    Spine.Ajax.disable =>
      conversation = App.Conversation.create(user: App.user, read: true)
      message.conversation(conversation)
      message.save()
      
    @close()
    @navigate '/conversations', conversation.cid