class App.Conversation extends Spine.Model
  @configure 'Conversation', 'read', 'received_at', 'to_users'
  @extend Spine.Model.Ajax
  @extend Spine.Timestamps
  
  @hasOne 'user', 'App.User'
  @hasMany 'messages', 'App.Message'
  
  # TODO - refactor
  to_users: (users) ->
    if users?
      @_to_users = []
      for user in users
        unless user instanceof App.User
          user = App.User.create(user)
        @_to_users.push(user)
    @_to_users or= []
    
  preview: ->
    messages = @messages().all().sort(App.Message.sentAtAsc)
    
    from_user = (msg.from_user() for msg in messages when not msg.isMe())[0]
    from_user or= @to_users()[0]
    
    message = (msg for msg in messages when not msg.isMe())[0]
    message or= messages[0] or {}
    
    {
      avatar_url: from_user?.avatar_url
      handle:     from_user?.toString() or App.user.handle
      body:       message.body
      timestamp:  new Date(message.sent_at).formatAgo()
    }
    
  open: ->
    return if @read is true
    @read = true
    @save()
  
  @sort: (a, b) ->
    earlier = Date.parse(a.updated_at) > Date.parse(b.updated_at)
    if earlier then -1 else 1
    
  @unreadCount: ->
    @select((c)-> not c.read).length