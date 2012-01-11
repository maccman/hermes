$            = Spine.$.sub()
Conversation = App.Conversation
Message      = App.Message
  
class Item extends Spine.Controller
  className: 'item'
    
  events:
    'click .star': 'toggleStarred'
    
  elements:
    '.star': 'star'
    
  constructor: ->
    super
    throw 'record required' unless @record
    @record.bind 'change', @render

  render: =>
    @el.toggleClass('me', @record.isMe())
    @html @view('messages/article/item')(@record)
    
  toggleStarred: ->
    @record.toggleStarred()
    @star.gfx(rotate: if @record.starred then '360deg' else '-360deg')
  
class Compose extends Spine.Controller
  className: 'item me'
  
  events:
    'keypress .input': 'keypress'
    'submit form': 'submit'
    
  elements:
    '.input': 'input'
    
  constructor: ->
    super
    throw 'record required' unless @record
    
  render: ->
    @html @view('messages/article/compose')(App.user)
    @delay -> @input.focus()
    @el

  keypress: (e) ->
    if e.keyCode is 13 and (e.shiftKey or e.metaKey)
      @submit(e)

  submit: (e) ->
    e.preventDefault()
    message = new Message(body: @input.innerText())
    message.from_user(App.user)
    message.conversation(@record)
    if message.body
      @input.text('')
      message.save()
      @record.open()
    
class App.Messages.Article extends Spine.Controller
  elements:
    '.items': 'items'
    '.compose': 'compose'
  
  constructor: ->
    super
    
    Message.bind 'create', (record) =>
      if record.conversation()?.eql(@current)
        @add([record])
    
    @active (params = {}) ->
      @change(Conversation.find(params.id)) if params.id
      
  change: (item) ->
    @current = item
    @render()
    
    setTimeout =>
      if item.eql(@current)
        @current.open()
    , 1000
    
  render: ->
    @replace @view('messages/article')(@current)
    @compose.append(new Compose(record: @current).render())
    
    messages = @current?.messages().all().sort(Message.sentAtDesc)
    @add(messages)
    
  add: (records = []) ->
    for record in records
      @items.append(new Item(record: record).render())
    @scrollToBottom()
    
  scrollToBottom: ->
    @items.scrollTop(@items[0].scrollHeight)
  