$ = jQuery

isOpen = ->
  !!$('#overlay').length

close = ->
  overlay = $('#overlay')
  overlay.find('article').gfx(scale: '1.1', opacity: 0, translate3d: '0,-10%,0')
  overlay.gfx(background: 'rgba(0,0,0,0)')
  overlay.queueNext -> overlay.remove()
  
panelCSS = 
  opacity:    0
  scale:      1.3
  translate3d: '0,-20%,0'
  
overlayStyles = 
  display:    'block'
  position:   'fixed'
  zIndex:     99
  top:        0
  left:       0
  width:      '100%'
  height:     '100%'
  background: 'rgba(0,0,0,0)'
  
window.onkeyup = (e) ->
  if e.keyCode is 27 and isOpen()
    close()

$.overlay = (element, options = {}) ->
  close() if isOpen()
  
  element = $(element)
    
  options.css or= {}
  options.css.width  = options.width  if options.width
  options.css.height = options.height if options.height
  
  overlay = $('<div />').attr('id': 'overlay')
  overlay.css(overlayStyles)
  overlay.click (e) ->
    close() if (e.target is overlay[0])
  
  overlay.delegate('.close', 'click', close)
  overlay.bind('close', close)

  panel = $('<article />')
  panel.transform($.extend({}, panelCSS, options.css))

  panel.append(element)
  overlay.append(panel)
  $('body').append(overlay)
  
  overlay.delay().gfx({background: 'rgba(0,0,0,0.5)'})
  panel.delay().gfx({scale: 1, opacity: 1, translate3d: '0,0,0'}, {duration: 200})