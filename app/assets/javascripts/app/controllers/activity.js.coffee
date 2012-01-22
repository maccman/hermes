class App.Activity extends Spine.Controller
  className: 'activity'
  
  constructor: ->
    super
    
    @routes
      '/activity': -> @active()