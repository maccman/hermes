$ = Spine.$
  
class App.Messages extends Spine.Controller
  className: 'messages'
  
  constructor: ->
    super
    @render()
    
  render: ->
    @append new App.Messages.Aside
    @append $('<div />').addClass('vdivide')
    @append new App.Messages.Article