$ = jQuery

Conversation = App.Conversation

class Item extends Spine.Controller
  constructor: ->
    super
    throw 'record required' unless @record
    @record.bind 'change', @render
  
  render: =>
    @replace @view('messages/aside/item')(@record)
    
  toggleActive: (bool) ->
    this.el.toggleClass('active', bool)

class App.Messages.Aside extends Spine.Controller
  elements:
    '.items': 'itemsEl'
    
  events:
    'click .items .item': 'click'
    
  constructor: ->
    super
    
    # Render inital template
    @replace @view('messages/aside')()

    # Subscribe active events
    @active (params = {}) ->
      @change(Conversation.find(params.id)) if params.id
      
    Conversation.bind 'refresh', @add
  
  items: []
  
  add: (records = []) =>
    for record in records
      item = new Item(record: record)
      @items.push(item)
      @itemsEl.append(item.render())
      
  change: (item) ->
    @current = item
    @render()
    
  render: ->
    for item in @items
      item.toggleActive(item.record.eql(@current))
      
  click: (e) ->
    itemID = $(e.currentTarget).data('id')
    @navigate '/conversations', itemID