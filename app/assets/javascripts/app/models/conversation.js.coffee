class App.Conversation extends Spine.Model
  @configure 'Conversation', 'read', 'starred', 'activity', 'received_at', 'to_users'
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
    
    # TODO - add default avatar
    {
      avatar_url: from_user?.avatar_url
      handle:     from_user?.toString() or 'Loading...'
      body:       message.body
      timestamp:  new Date(message.sent_at).formatAgo()
    }
    
  open: ->
    return if @read is true
    @read = true
    @save()
    
  toggleStarred: (bool) ->
    @starred = bool ? !@starred
    @save()
    
  @bind 'beforeCreate', (record) ->
    record.received_at or= new Date
  
  @sort: (a, b) ->
    earlier = Date.parse(a.received_at) > Date.parse(b.received_at)
    if earlier then -1 else 1
    
  @unreadCount: ->
    @select((rec)-> not rec.activity and not rec.read).length
    
  @latest: ->
    (@select (rec) -> not rec.activity).sort(@sort)
    
  @starred: ->
    (@select (rec) -> rec.starred).sort(@sort)
    
  @activity: ->
    (@select (rec) -> rec.activity).sort(@sort)
    
  @fetch: ->
    @ajax().fetch()
  
  @fetchStarred: ->
    @ajax().fetch(url: @url('starred'))

  @fetchActivity: ->
    @ajax().fetch(url: @url('activity'))