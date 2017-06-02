class ChineseSetting

  constructor: ->
    #菜单
    @M = require __dirname + '/../def/menu_'+process.platform+'.json'
    #右键菜单
    @C = require __dirname + '/../def/context.json'


  activate: (state) ->
    setTimeout(@delay,0)

  delay: () =>
    config = atom.config.get 'simplified-chinese-menu'

    if config.useMenu
      # Menu
      @updateMenu(atom.menu.template, @M.Menu)
      atom.menu.update()

    if config.useContext
      # ContextMenu
      @updateContextMenu()

    if config.useSetting
      # Settings (on init and open)
      @updateSettings()
      #重载后切换过来时
      atom.workspace.onDidChangeActivePaneItem (item) =>
        if item and item.uri and item.uri.indexOf('atom://config') isnt -1
          settingsTab = document.querySelector('.tab-bar [data-type="SettingsView"]')
          chineseStatus = settingsTab.getAttribute('inChinese')
          if chineseStatus isnt 'true'
            settingsTab.setAttribute('inChinese','true')
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
      if key is 'VERSION'
        menu.label = set.value+' '+atom.appVersion if set?
      else
        menu.label = set.value if set?
      if menu.submenu?
        @updateMenu(menu.submenu, set.submenu)

  updateContextMenu: () ->
    for itemSet in atom.contextMenu.itemSets
      set = @C.Context[itemSet.selector]
      continue if not set
      for item in itemSet.items
        console.log(item)
        continue if item.type is "separator"
        label = set[item.command]
        item.label = label if label?
        console.log(item)

  updateSettings: (onSettingsOpen = false) ->
    setTimeout(@delaySettings, 0, onSettingsOpen)

  delaySettings: (onSettingsOpen) ->
    settings = require './../tools/settings'
    settings.init()

  config:
    useMenu:
      title: '汉化菜单'
      description: '如果你不希望汉化`菜单`部分可以关闭此处,设置后可能需要重启 Atom。'
      type: 'boolean'
      default: true
    useSetting:
      title: '汉化设置'
      description: '如果你不希望汉化`设置`部分可以关闭此处,设置后可能需要重启 Atom。'
      type: 'boolean'
      default: true
    useContext:
      title: '汉化右键菜单'
      description: '如果你不希望汉化`右键菜单`部分可以关闭此处,设置后可能需要重启 Atom。'
      type: 'boolean'
      default: true

module.exports = new ChineseSetting()
