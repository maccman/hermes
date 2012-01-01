records = [
  {
    subject: 'New Email idea',
    body: 'This is the new email idea',
    avatar_url: 'https://secure.gravatar.com/avatar/11d44fdc7a81963600d079813ede2b69'
  },
  
  {
    subject: 'New Email idea',
    body: 'This is the new email idea',
    avatar_url: 'https://secure.gravatar.com/avatar/11d44fdc7a81963600d079813ede2b69',
    me: true
  }
]

compose = {
  avatar_url: 'https://secure.gravatar.com/avatar/11d44fdc7a81963600d079813ede2b69'
}

class Item extends Spine.Controller
  className: 'item'

  render: ->
    @el.toggleClass('me', @record.me or false)
    @html @view('messages/article/item')(@record)
  
class Compose extends Spine.Controller
  className: 'item me compose'
    
  constructor: ->
    super
    @render()
    
  render: ->
    @html @view('messages/article/compose')(compose)

class App.Messages.Article extends Spine.Controller
  elements:
    '.items': 'items'
  
  constructor: ->
    super
    
    @replace @view('messages/article')()
    
    @add(records)
    
  add: (records) ->
    for record in records
      @items.append(new Item(record: record).render())