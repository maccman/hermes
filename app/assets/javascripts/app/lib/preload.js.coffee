preload = [
  '/assets/stard.png',
  '/assets/messages-sel.png',
  '/assets/starred-sel.png',
  '/assets/activity-sel.png'
]

jQuery ->
  for src in preload
    (new Image).src = src