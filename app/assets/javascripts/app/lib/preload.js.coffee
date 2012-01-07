preload = ['/assets/stard.png']

jQuery ->
  for src in preload
    (new Image).src = src