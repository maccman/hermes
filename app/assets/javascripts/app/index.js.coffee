#= require json2
#= require jquery
#= require ./spine/spine
#= require spine/manager
#= require ./spine/ajax
#= require spine/route
#= require ./spine/relation
#= require spine/list
#= require gfx
#= require gfx/effects

#= require_tree ./lib
#= require_self
#= require_tree ./models
#= require_tree ./controllers
#= require_tree ./views

$ = jQuery

class App extends Spine.Controller
  @extend Spine.Events
  
  @load: (callback) ->
    if (typeof callback is 'function')
      @bind 'load', callback
    else
      @trigger('load', arguments...)
  
  @ready: (callback) ->
    if (typeof callback is 'function')
      @bind 'ready', callback
    else
      @trigger('ready', arguments...)
      
  events:
    'click a': 'clickLink'
  
  constructor: ->
    super
        
    @el.hide()
    @toggleSpinner(true)
    
    @append(@nav = new App.Nav)
    @append(@stack = new App.Stack)
    
    App.ready =>
      @el.queueNext =>
        @el.transform
          scale:   '.8'
          opacity: '0'
    
        @el.show().gfx
          scale:   '1'
          opacity: '1'
          
        @toggleSpinner(false)
        
    App.ready ->
      App.Conversation.fetchStarred()
      App.Conversation.fetchActivity()

    App.load()
    
    App.Conversation.fetch().success =>
      @navigate '/conversations'
      Spine.Route.setup()
      App.ready()
      
  toggleSpinner: (show) ->
    if show
      @spinner = $('<div />').addClass('spinner')
      @el.parent().append(@spinner)
      @spinner.spin(
        length: 7, width: 4, 
        color: 'rgba(255, 255, 255, 0.5)'
      )
    else
      @spinner?.remove()
      
  clickLink: (e) ->
    e.preventDefault()
    href = $(e.currentTarget).attr('href')
    
    if match = href.match(/mailto:(.+)/)
      (new App.Compose(value: match[1])).open()
      
    else    
      if macgap?
        macgap.app.open(href)
      else
        window.open(href)

class App.Stack extends Spine.Stack
  constructor: ->
    super

    @activity = new App.Activity(stack: @)
    @messages = new App.Messages(stack: @)
    @starred  = new App.Starred(stack: @)

    @add(@activity)
    @add(@messages)
    @add(@starred)

    @messages.active()    

window.App = App