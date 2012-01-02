class App.Conversation extends Spine.Model
  @configure 'Conversation', 'read'
  @extend Spine.Model.Ajax
  
  @hasOne 'from_user', 'App.User'
  @hasMany 'to_users', 'App.User'
  @hasMany 'messages', 'App.Message'
  
  preview: ->
    message = @messages().first()
    {
      avatar_url: message.from_user()?.avatar_url
      subject:    'Some subject'
      body:       message.body
    }
