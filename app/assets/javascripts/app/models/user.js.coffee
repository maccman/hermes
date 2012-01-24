class App.User extends Spine.Model
  @configure 'User', 'handle', 'name', 'avatar_url', 'email'
  
  toUID: ->
    if @handle then "@#{@handle}" else @email
  
  toString: ->
    @name or (@handle and "@#{@handle}") or @email