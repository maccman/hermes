$ = jQuery

Conversation = App.Conversation

class Item extends Spine.Controller
  active: false
  
  constructor: ->
    super
    throw 'record required' unless @record
    @record.bind 'change', @render
  
  render: =>
    @replace @view('messages/aside/item')(@record)
    @el.toggleClass('active', @active)
    
  toggleActive: (bool) ->
    @active = bool
    @render()

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
      
    Conversation.bind 'refresh', @addAll
    Conversation.bind 'create',  @addOne
    Conversation.bind 'change',  @render
  
  items: []
  
  addAll: (records = []) =>
    for record in records
      item = new Item(record: record)
      @items.push(item)
      @itemsEl.append(item.render())
      
  addOne: (record) =>
    item = new Item(record: record)
    @items.unshift(item)
    @itemsEl.prepend(item.render())    
      
  change: (item) ->
    @current = item
    @render()
    
  render: =>
    for item in @items
      item.toggleActive(item.record.eql(@current))
      
  click: (e) ->
    itemID = $(e.currentTarget).data('cid')
    @navigate '/conversations', itemID