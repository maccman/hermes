records = [
  {
    subject: 'New Email idea',
    body: 'This is the new email idea',
    avatar_url: 'https://secure.gravatar.com/avatar/11d44fdc7a81963600d079813ede2b69'
  }
]

class Item extends Spine.Controller
  className: 'item active'
  
  render: ->
    @html @view('messages/aside/item')(@record)

class App.Messages.Aside extends Spine.Controller
  elements:
    '.items': 'items'
    
  constructor: ->
    super
    @replace @view('messages/aside')()
    @add(records)
    
  add: (records) ->
    for record in records
      @items.append(new Item(record: record).render())