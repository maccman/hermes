Conversation = App.Conversation
Message      = App.Message

class Item extends Spine.Controller
  className: 'item'
    
  events:
    'click .star': 'toggleStarred'
    
  constructor: ->
    super
    throw 'record required' unless @record
    @record.bind 'change', @render

  render: =>
    @el.toggleClass('me', @record.isMe())
    @html @view('messages/article/item')(@record)
    
  toggleStarred: ->
    @record.toggleStarred()
  
class Compose extends Spine.Controller
  className: 'item me'
  
  events:
    'submit form': 'submit'
    'keypress textarea': 'keypress'
    
  elements:
    'form': 'form'
    
  constructor: ->
    super
    throw 'record required' unless @record
    @render()
    
  render: ->
    @html @view('messages/article/compose')(App.user)

  keypress: (e) ->
    if e.keyCode is 13 and (e.shiftKey or e.metaKey)
      @submit(e)

  submit: (e) ->
    e.preventDefault()
    message = Message.fromForm(@form)
    message.conversation(@record)
    if message.body
      @form[0].reset()
      message.save()
    
class App.Messages.Article extends Spine.Controller
  elements:
    '.items': 'items'
    '.compose': 'compose'
  
  constructor: ->
    super
    
    Conversation.bind 'change', (record) =>
      @render() if record.eql(@current)
    
    @active (params = {}) ->
      @change(Conversation.find(params.id)) if params.id
      
  change: (item) ->
    @current = item
    @render()
    
  render: ->
    @replace @view('messages/article')()
    @compose.append(new Compose(record: @current).render())
    
    messages = @current?.messages().all()
    @add(messages)
    
  add: (records = []) ->
    for record in records
      @items.append(new Item(record: record).render())