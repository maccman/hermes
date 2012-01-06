Spine.Timestamps = 
  extended: ->
    @attributes.push 'created_at'
    @attributes.push 'updated_at'

    @bind 'beforeSave', (item) ->
      item.updated_at or= new Date
      item.created_at or= new Date