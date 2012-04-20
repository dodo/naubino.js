stuff = ["./js/Load.js","./js/Naubino.js","./js/Background.js","./js/Game.js","./js/Graph.js","./js/Keybindings.js","./js/Menu.js","./js/Overlay.js","./js/StandardGame.js","./js/TestCase.js","./js/Settings.js","./js/Tutorial.js","./js/Layer.js","./js/Naub.js","./js/Shapes.js","./js/PhysicsModel.js"]
first = stuff[0].match(/^.*\/(.*).js$/)[1]

modules = {}
not_loaded = {}
defined = []

load = (name, reqs, body) ->
  body (for req in reqs
    module = modules[req]
    if !module
      module = not_loaded[req]
      delete not_loaded[req]
      if !module
        throw new Error "missing module '#{req}' as a requirement for '#{name}'"
      module = modules[req] = module()
    module)...

start = ->
  for { name, reqs, body } in defined
    do (name, reqs, body) ->
      if !name
        name = stuff[0].match(/^.*\/(.*).js$/)[1]
        stuff = stuff[1..]
      not_loaded[name] = -> load name, reqs, body
  not_loaded[first]()

window.define = (args..., body) ->
  for arg in args
    name = arg if typeof arg == 'string'
    reqs = arg if Array.isArray(arg)
  name ?= null
  reqs ?= []

  if defined.length == 0
    window.addEventListener 'load', start
  defined.push { name, reqs, body }

for s in stuff
  script = document.createElement 'script'
  script.setAttribute 'src', s
  document.head.appendChild script

