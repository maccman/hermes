#= require juggernaut

class JuggernautClient extends Spine.Module
  @include Spine.Log
  
  constructor: ->
    @client = new Juggernaut(
      host: App.config.juggernaut.host,
      port: 80,
      transports: ['xhr-polling', 'jsonp-polling']
    )
    @client.on 'connect', @connected
    @client.on 'disconnect', @disconnected
    @client.subscribe("/observer/#{App.user.id}", @process)
  
  process: (message) =>
    model = App[message.model] or throw('Model required')
    switch message.type
      when 'create'
        unless model.exists(message.id)
          model.create(message.record)
      when 'update'
        model.update(message.id, message.record)
      when 'destroy'
        model.destroy(message.id)
      else
        throw("Unknown type: #{message.type}")
  
  logPrefix: '(Juggernaut)'
  
  connected: =>
    @log 'connected'
    
  disconnected: =>
    @log 'disconnected'

App.ready -> new JuggernautClient