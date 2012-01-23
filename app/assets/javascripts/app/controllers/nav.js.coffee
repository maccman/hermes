Conversation = App.Conversation

class App.Nav extends Spine.Controller
  elements:
    '[data-type=conversations]': 'conversations'
    
  events:
    'click .item[data-type]': 'click'
  
  constructor: ->
    super
    @render()
    
    Conversation.bind 'change refresh', @renderCount
    Spine.Route.bind 'navigate', @changeActive
    
  render: ->
    @replace @view('nav')(App.user)
    
  renderCount: =>
    count = Conversation.unreadCount()
    @conversations.attr('data-count', count or '')
    macgap?.dock.badge = if count then count + '' else ''
    
  changeActive: (url) =>
    type = url?.match(/^\/(\w+)/)[1]
    @el.find('[data-type]').removeClass('active')
    @el.find("[data-type=#{type}]").addClass('active')
  
  click: (e) ->
    type = $(e.currentTarget).data('type')
    @navigate "/#{type}"