class App.User extends Spine.Model
  @configure 'User', 'handle', 'name', 'avatar_url'
  
  toString: ->
    @name or (@handle and "@#{@handle}") or @email