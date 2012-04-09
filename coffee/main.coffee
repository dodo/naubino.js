window.P = (x...) ->
  console.log 'P', x...
  if x.length > 1 then x else x[0]
window.M = (o, xs...) -> ((o[k]=v for k,v of x)for x in xs); o

define ["Game"], (Game) ->
  window.onload = ->
    $naubino = $ '#Naubino'
    game = new Game ->
      $naubino.append game.$el







