@Utils =
  escape: (value) ->
    ('' + value)
      .replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;')
      
  format: (value) ->
    value = @escape(value).replace(/\n/g, '<br>')
    "<p>#{value}</p>"