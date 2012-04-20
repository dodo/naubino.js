entry = process.argv[2]
if !entry
  console.log "argv: ENTRY"
  process.exit(-1)

Path = require 'path'
path = Path.dirname entry

req = Path.basename(entry)
req = req[...req.lastIndexOf '.']
requirements = [req]

global.define = (reqs..., body) ->
  reqs = reqs[0] if reqs[0]
  for req in reqs when req not in requirements
    requirements.push req
  for req in reqs
    require "../#{path}/#{req}"

# compatibility
global.window = {}
# fill requirements
require "../#{entry}"

#scripts = []
#for req in requirements
#  scripts.push  "<script src=\"js/#{req}.js\"></script>"
#scripts = scripts.join '\n'

requirements = ("./#{path}/#{req}.js" for req in requirements)
console.log JSON.stringify requirements
#console.log scripts