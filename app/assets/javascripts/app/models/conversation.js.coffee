class App.Conversation extends Spine.Model
  @configure 'Conversation', 'read', 'received_at'
  @extend Spine.Model.Ajax
  @extend Spine.Timestamps
  
  @hasOne 'user', 'App.User'
  @hasMany 'to_users', 'App.User'
  @hasMany 'messages', 'App.Message'
  
  preview: ->
    messages = @messages().all().sort(App.Message.sentAtAsc)
    
    avatar_url = (msg.from_user()?.avatar_url for msg in messages when not msg.isMe())
    avatar_url = (val for val in avatar_url when val)[0]
    avatar_url or= @to_users().first()?.avatar_url
    
    message = (msg for msg in messages when not msg.isMe())[0]
    message or= messages[0] or {}
    
    {
      avatar_url: avatar_url
      subject:    'Some subject'
      body:       message.body
    }
    
  open: ->
    return if @read
    @read = true
    @save()

  @sort: (a, b) ->
    earlier = Date.parse(a.updated_at) > Date.parse(b.updated_at)
    if earlier then -1 else 1
    
  @unreadCount: ->
    @select((c)-> not c.read).length