###
  Generate ContextMenu Template
###
sels = {}
atom.contextMenu.itemSets.map (d) ->
  sels[d.selector] = []  unless sels[d.selector]
  sels[d.selector] = sels[d.selector].concat(d.items)

  data = ""
  for sel of sels
    data += "  \"" + sel + "\":\n"
    sels[sel].map (d) ->
      return false  if d.type is "separator"
      data += "    \"" + d.command + "\": \"" + d.label + "\"\n"

  atom.clipboard.write data
