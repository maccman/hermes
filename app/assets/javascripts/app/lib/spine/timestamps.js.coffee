Spine.Timestamps = 
  extended: ->
    @bind 'save', ->
      @updated_at or= new Date
      @created_at or= new Date