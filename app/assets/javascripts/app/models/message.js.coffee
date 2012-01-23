class App.Message extends Spine.Model
  @configure 'Message', 'subject', 'body', 'html', 'starred', 'to', 'sent_at'
  @extend Spine.Model.Ajax
  @extend Spine.Timestamps
  
  @belongsTo 'from_user', 'App.User'
  @hasMany   'to_users', 'App.User'
  @belongsTo 'conversation', 'App.Conversation'
  
  isMe: ->
    App.user?.eql(@from_user()) or false
    
  toggleStarred: (bool) ->
    @starred = bool ? !@starred
    @save()
    if @starred
      @conversation()?.toggleStarred(true)
  
  @bind 'beforeCreate', (record) ->
    record.sent_at or= new Date
    record.html or= Utils.format(record.body)
      
  @sentAtDesc: (a, b) ->
    later = Date.parse(a.sent_at) < Date.parse(b.sent_at)
    if later then -1 else 1
    
  @sentAtAsc: (a, b) ->
    before = Date.parse(a.sent_at) > Date.parse(b.sent_at)
    if before then -1 else 1