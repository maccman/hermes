class App.Message extends Spine.Model
  @configure 'Message', 'subject', 'body', 'starred'
  @extend Spine.Model.Ajax
  
  @belongsTo 'from_user', 'App.User'
  @hasMany   'to_users', 'App.User'
  @belongsTo 'conversation', 'App.Conversation'
  
  isMe: ->
    App.user?.eql(@from_user()) or false