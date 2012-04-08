window.P = (x...) -> console.log 'P', x...; x
window.M = (xs..., o={}) -> ((o[k]=v for k,v of x)for x in xs); o

'''
if 1
  Template: class Template extends dynamictemplate.Template
    constructor: ->
      super
      dynamictemplate.domify @

  SvgTemplate: class SvgTemplate extends Template
    constructor: (opts = {}) ->
      opts.schema ?= 'svg'
      @svgns = "http://www.w3.org/2000/svg"
      that = this
      super opts, -> that.svg = @$svg
        xmlns: @svgns
#        version: '1.1'
#        viewBox: '0 0 1 1'
'''

define ["Game"], (Game) ->
  game = new Game
  window.onload = ->
    $naubino = $ '#Naubino'
    $naubino.append game.$el







