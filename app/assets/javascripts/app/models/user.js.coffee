class App.User extends Spine.Model
  @configure 'User', 'handle', 'name', 'avatar_url'
  
  load: ->
    super
    @avatar_url or= "http://robohash.org/#{@email}.png?size=48x48&bgset=1"