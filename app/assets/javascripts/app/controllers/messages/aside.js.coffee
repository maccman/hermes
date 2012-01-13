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
    @el.toggleClass('unread', not @record.read)
    
  toggleActive: (bool) ->
    @active = bool
    @el.toggleClass('active', @active)

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
    
    Conversation.bind 'refresh change', @render
        
  change: (item) ->
    @current = item
    
    for item in @items
      item.toggleActive(item.record.eql(@current))
    
  render: =>
    @items = []
    @itemsEl.html('')
    
    for record in Conversation.all().sort(Conversation.sort)
      item = new Item(record: record)
      item.toggleActive(item.record.eql(@current))
      @items.push(item)
      @itemsEl.append(item.render())
      
    # Select first item unless otherwise specified
    unless @current
      @itemsEl.find('.item:first').click()
      
  click: (e) ->
    itemID = $(e.currentTarget).data('cid')
    @navigate '/conversations', itemID