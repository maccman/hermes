class App.Nav extends Spine.Controller
  constructor: ->
    super
    @render()
    
  render: ->
    @replace @view('nav')(App.user)