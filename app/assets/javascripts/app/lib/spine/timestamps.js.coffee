Spine.Timestamps = 
  extended: ->
    @bind 'beforeSave', (item) ->
      item.updated_at or= new Date
      item.created_at or= new Date