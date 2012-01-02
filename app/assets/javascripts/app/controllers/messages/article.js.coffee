Conversation = App.Conversation

class Item extends Spine.Controller
  className: 'item'

  render: ->
    @el.toggleClass('me', @record.isMe())
    @html @view('messages/article/item')(@record)
  
class Compose extends Spine.Controller
  className: 'item me compose'
    
  constructor: ->
    super
    @render()
    
  render: ->
    # TODO
    @html @view('messages/article/compose')(compose)

class App.Messages.Article extends Spine.Controller
  elements:
    '.items': 'items'
  
  constructor: ->
    super
    
    @active (params = {}) ->
      @change(Conversation.find(params.id)) if params.id
      
  change: (item) ->
    @current = item
    @render()
    
  render: ->
    @replace @view('messages/article')()
    
    messages = @current?.messages().all()
    @add(messages)
    
  add: (records = []) ->
    for record in records
      @items.append(new Item(record: record).render())