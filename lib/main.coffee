class ChineseSetting

  constructor: ->
    CSON = require 'cson'
    #菜单
    @M = CSON.load __dirname + '/../def/menu_'+process.platform+'.cson'
    #右键菜单
    @C = CSON.load __dirname + '/../def/context.cson'


  activate: (state) ->
    setTimeout(@delay,0)

  delay: () =>
    # Menu
    @updateMenu(atom.menu.template, @M.Menu)
    atom.menu.update()

    # ContextMenu
    @updateContextMenu()

    #console.log @S
    # Settings (on init and open)
    @updateSettings()
    #重载后切换过来时
    atom.workspace.onDidChangeActivePaneItem (item) =>
      if item isnt undefined and item.uri is 'atom://config'
        @updateSettings(true)

  updateMenu : (menuList, def) ->
    return if not def
    for menu in menuList
      continue if not menu.label
      key = menu.label
      if key.indexOf '…' isnt -1
        key = key.replace('…','...')
      set = def[key]
      continue if not set
      menu.label = set.value if set?
      if menu.submenu?
        @updateMenu(menu.submenu, set.submenu)

  updateContextMenu: () ->
    console.log '执行 updateContextMenu'
    for itemSet in atom.contextMenu.itemSets
      set = @C.Context[itemSet.selector]
      continue if not set
      for item in itemSet.items
        continue if item.type is "separator"
        label = set[item.command]
        item.label = label if label?

  updateSettings: (onSettingsOpen = false) ->
    setTimeout(@delaySettings, 0, onSettingsOpen)

  delaySettings: (onSettingsOpen) ->
    settings = require './../tools/settings'
    settings.init()

module.exports = new ChineseSetting()
