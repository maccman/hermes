class App.Conversation extends Spine.Model
  @configure 'Conversation', 'read'
  @extend Spine.Model.Ajax
  
  @hasOne 'from_user', 'models/user'
  @hasMany 'to_users', 'models/user'
  @hasMany 'messages', 'models/message'
  
  @preview: ->
    @messages().first()