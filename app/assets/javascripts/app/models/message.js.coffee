class App.Message extends Spine.Model
  @configure 'Message', 'subject', 'body', 'starred', 'to', 'sent_at'
  @extend Spine.Model.Ajax
  @extend Spine.Timestamps
  
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
    later = Date.parse(a.sent_at) < Date.parse(b.sent_at)
    if later then -1 else 1