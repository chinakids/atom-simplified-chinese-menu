/**
 * Generate ContextMenu Template
 */
var sels = {};
atom.contextMenu.itemSets.map(function(d){
  if (!sels[d.selector]) { sels[d.selector] = [] }
  sels[d.selector] = sels[d.selector].concat(d.items);
})
var data = "";
for (sel in sels) {
  data += '  "' + sel + '":\n'
  sels[sel].map(function(d){
    if (d.type === "separator") return false;
    data += '    "'+d.command+'": "'+d.label+'"\n'
  })
}
atom.clipboard.write(data);
