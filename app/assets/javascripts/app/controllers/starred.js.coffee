class App.Starred extends Spine.Controller
  className: 'starred'
  
  constructor: ->
    super
    
    @routes
      '/starred': -> @active()