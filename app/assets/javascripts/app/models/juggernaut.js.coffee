#= require juggernaut

class JuggernautClient extends Spine.Module
  @include Spine.Log
  
  constructor: ->
    @client = new Juggernaut(
      host: App.config.juggernaut.host,
      port: App.config.juggernaut.port,
      transports: ['xhr-polling', 'jsonp-polling']
    )
    @client.on 'connect', @connected
    @client.on 'disconnect', @disconnected
    @client.subscribe("/observer/#{App.user.id}", @processWithoutAjax)
  
  process: (message) =>
    @log 'processing', message
    
    model = App[message.model] or throw('Model required')
    switch message.type
      when 'create', 'update'
        if model.exists(message.id)
          model.update(message.id, message.record)
        else
          model.create(message.record)
      when 'destroy'
        model.destroy(message.id)
      else
        throw("Unknown type: #{message.type}")
        
  processWithoutAjax: (message) =>
    Spine.Ajax.disable =>
      @process(message)
  
  logPrefix: '(Juggernaut)'
  
  connected: =>
    @log 'connected'    
    
  disconnected: =>
    @log 'disconnected'
    
  getID: ->
    @client.sessionID
    
jQuery.ajaxPrefilter (options, originalOptions, xhr) ->
  sessionID = App.Juggernaut?.getID()
  xhr.setRequestHeader('X-Session-ID', sessionID) if sessionID

App.ready -> 
  App.Juggernaut = new JuggernautClient