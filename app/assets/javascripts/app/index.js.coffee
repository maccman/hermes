#= require json2
#= require jquery
#= require ./spine/spine
#= require spine/manager
#= require spine/ajax
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

class App extends Spine.Controller
  constructor: ->
    super
    
    @append new App.Nav
    @append new App.Stack
    
    App.Conversation.one 'refresh', ->
      Spine.Route.setup()
      
    App.Conversation.fetch()    

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