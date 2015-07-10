module.exports =

  activate : (state) ->
    setTimeout(@delay, 0, this)

  delay : (that) ->
    CSON = require 'cson'
    defM = CSON.load __dirname + "/../def/menu_#{process.platform}.cson"
    defC = CSON.load __dirname + "/../def/context.cson"

    # Menu
    that.updateMenu(atom.menu.template, defM.Menu)
    atom.menu.update()

    # ContextMenu
    that.updateContextMenu(defC.Context)

  updateMenu : (menuList, def) ->
    return if not def
    for menu in menuList
      continue if not menu.label
      key = menu.label
      if key.indexOf '…' != -1
        key = key.replace('…','...')
      set = def[key]
      continue if not set
      menu.label = set.value if set?
      if menu.submenu?
        @updateMenu(menu.submenu, set.submenu)

  updateContextMenu : (def) ->
    for itemSet in atom.contextMenu.itemSets
      set = def[itemSet.selector]
      continue if not set
      for item in itemSet.items
        continue if item.type is "separator"
        label = set[item.command]
        item.label = label if label?
