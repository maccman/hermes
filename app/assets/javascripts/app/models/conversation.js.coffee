class App.Conversation extends Spine.Model
  @configure 'Conversation', 'read', 'received_at'
  @extend Spine.Model.Ajax
  @extend Spine.Timestamps
  
  @hasOne 'user', 'App.User'
  @hasMany 'to_users', 'App.User'
  @hasMany 'messages', 'App.Message'
  
  preview: ->
    message = @messages().first()
    return {} unless message
    {
      avatar_url: message.from_user()?.avatar_url
      subject:    'Some subject'
      body:       message.body
    }
    
  open: ->
    @read = true
    @save()

  @sort: (a, b) ->
    earlier = Date.parse(a.updated_at) > Date.parse(b.updated_at)
    if earlier then -1 else 1