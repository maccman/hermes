class App.Message extends Spine.Model
  @configure 'Message', 'subject', 'body', 'starred', 'to', 'updated_at'
  @extend Spine.Model.Ajax
  
  @belongsTo 'from_user', 'App.User'
  @hasMany   'to_users', 'App.User'
  @belongsTo 'conversation', 'App.Conversation'
  
  isMe: ->
    App.user?.eql(@from_user()) or false
    
  toggleStarred: ->
    @starred = !@starred
    @save()
    
  @bind 'create', (record) ->
    Spine.Ajax.disable ->
      record.conversation()?.save()
      
  @sort: (a, b) ->
    earlier = Date(a.updated_at) > Date(b.updated_at)
    if earlier then -1 else 1