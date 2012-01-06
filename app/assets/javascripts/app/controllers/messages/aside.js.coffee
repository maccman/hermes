$ = jQuery

Conversation = App.Conversation

class Item extends Spine.Controller
  active: false
  
  constructor: ->
    super
    throw 'record required' unless @record
  
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
    Conversation.bind 'refresh change', @render
  
  items: []
  
  addAll: (records = []) =>
    @addOne(record) for record in records
      
  addOne: (record) =>
    item = new Item(record: record)
    @items.push(item)
      
  change: (item) ->
    @current = item
    
    for item in @items
      item.toggleActive(item.record.eql(@current))
    
  render: =>
    # @items = @items.sort(Conversation.sort)
    
    @itemsEl.html('')
    
    for item in @items
      @itemsEl.append(item.render())
      
    # Select first item unless otherwise specified
    unless @current
      @itemsEl.find('.item:first').click()
      
  click: (e) ->
    itemID = $(e.currentTarget).data('cid')
    @navigate '/conversations', itemID