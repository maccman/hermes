$ = jQuery

$.fn.innerText = ->
  @[0].innerText or
    @html()
      .replace(/<br>/gi, '\n')
        .replace(/<\/?[^>]+>/gi, '')