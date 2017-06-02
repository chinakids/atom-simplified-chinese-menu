#设置
S = require __dirname + '/../def/settings.json'

applyToPanel = (e) ->
  # Settings panel
  for d in S.Settings.settings
    applyTextContentBySettingsId(d)

  sv = document.querySelector('.settings-view')

  sv.querySelector('#core-settings-note').innerHTML = "下述为Atom核心部分的设置，个别扩展包可能拥有额外独立设置，浏览扩展包设置请在 <a class='link packages-open'>扩展包列表</a> 中选择对应名称扩展的设置。"
  sv.querySelector('#editor-settings-note').innerHTML = "下述为Atom文本编辑器部分的设置，其中一些设置将会基于每个语言覆盖，检查语言设置请在 <a class='link packages-open'>扩展包列表</a> 中选择对应语言扩展的设置。"

  #sv.querySelector('[title="System Settings"]').closest('.panels-item').querySelector('.text').innerHTML = "这些设置可以将Atom集成到你的操作系统中。"
  # Keybindings
  info = sv.querySelector('.keybinding-panel>div:nth-child(2)')
  unless isAlreadyLocalized(info)
    info.querySelector('span:nth-child(2)').textContent = "您可以覆盖这些按键绑定通过复制　"
    info.querySelector('span:nth-child(4)').textContent = "并且粘贴进"
    info.querySelector('a.link').textContent = " 用户键盘映射 "
    span = document.createElement('span')
    span.textContent = "进行修改。"
    info.appendChild(span)
    info.setAttribute('data-localized', 'true')

  # Themes panel
  info = sv.querySelector('.themes-panel>div>div:nth-child(2)')
  unless isAlreadyLocalized(info)
    info.querySelector('span').textContent = "您也可以在"
    info.querySelector('a.link').textContent = " 用户样式设置 "
    span = document.createElement('span')
    span.textContent = "中扩展 Atom 的样式。"
    # console.log info
    info.appendChild(span)
    tp1 = sv.querySelector('.themes-picker>div:nth-child(1)')
    tp1.querySelector('.setting-title').textContent = "UI 主题"
    tp1.querySelector('.setting-description').textContent = "该主题将应用在标签，状态栏，树形视图和下拉菜单等。"
    tp2 = sv.querySelector('.themes-picker>div:nth-child(2)')
    tp2.querySelector('.setting-title').textContent = "语法主题"
    tp2.querySelector('.setting-description').textContent = "该主题将应用在编辑器内的文本。"
    info.setAttribute('data-localized', 'true')

  # Updates panel
  applySpecialHeading(sv, "Available Updates", "可用更新")
  applyTextWithOrg(sv.querySelector('.update-all-button.btn-primary'), "全部更新")
  applyTextWithOrg(sv.querySelector('.update-all-button:not(.btn-primary)'), "检查更新")
  applyTextWithOrg(sv.querySelector('.alert.icon-hourglass'), "检查更新中...")
  applyTextWithOrg(sv.querySelector('.alert.icon-heart'), "已安装的扩展都是最新的!")

  # Install panel
  applySectionHeadings()
  inst = document.querySelector('div.section:not(.themes-panel)')
  info = inst.querySelector('.native-key-bindings')
  unless isAlreadyLocalized(info)
    info.querySelector('span:nth-child(2)').textContent = "扩展·主题 "
    tc = info.querySelector('span:nth-child(4)')
    tc.textContent = tc.textContent.replace("and are installed to", "它们将被安装在 ")
    # info.appendChild(span)
    info.setAttribute('data-localized', 'true')
  applyTextWithOrg(inst.querySelector('.search-container .btn:nth-child(1)'), "扩展")
  applyTextWithOrg(inst.querySelector('.search-container .btn:nth-child(2)'), "主题")

  # Buttons
  applyButtonToolbar()

applyInstallPanelOnSwitch = () ->
  try
    applySectionHeadings(true)
    applyButtonToolbar()
    inst = document.querySelector('div.section:not(.themes-panel)')
    info = inst.querySelector('.native-key-bindings')
    info.querySelector('span:nth-child(2)').textContent = "扩展·主题 "
  catch e
    console.log e

applySpecialHeading = (area, org, text) ->
  try
    sh = getTextMatchElement(area, '.section-heading', org)
    return unless sh && !isAlreadyLocalized(sh)
    sh.textContent = text
    # span = document.createElement('span')
    # span.textContent = org
    # applyTextWithOrg(span, text)
    # sh.appendChild(span)
  catch e
    console.log e

applySectionHeadings = (force) ->
  try
    sv = document.querySelector('.settings-view')
    for sh in S.Settings.sectionHeadings
      el = getTextMatchElement(sv, '.section-heading', sh.label)
      continue unless el
      if !isAlreadyLocalized(el) and force
        applyTextWithOrg(el, sh.value)
    for sh in S.Settings.subSectionHeadings
      el = getTextMatchElement(sv, '.sub-section-heading', sh.label)
      continue unless el
      if !isAlreadyLocalized(el) and force
        applyTextWithOrg(el, sh.value)
  catch e
    console.log e

applyButtonToolbar = () ->
  try
    sv = document.querySelector('.settings-view')
    for btn in sv.querySelectorAll('.meta-controls .install-button')
      applyTextWithOrg(btn, "安装")
    for btn in sv.querySelectorAll('.meta-controls .settings')
      applyTextWithOrg(btn, "设置")
    for btn in sv.querySelectorAll('.meta-controls .uninstall-button')
      applyTextWithOrg(btn, "卸载")
    for btn in sv.querySelectorAll('.meta-controls .icon-playback-pause span')
      applyTextWithOrg(btn, "关闭")
    for btn in sv.querySelectorAll('.meta-controls .icon-playback-play span')
      applyTextWithOrg(btn, "启用")
  catch e
    console.log e

getTextMatchElement = (area, query, text) ->
  elems = area.querySelectorAll(query)
  result
  for el in elems
    if el.textContent.includes(text)
      result = el
      break
  return result

isAlreadyLocalized = (elem) ->
  localized = elem.getAttribute('data-localized') if elem
  return localized is 'true'

applyTextContentBySettingsId = (data) ->
  try
    el = document.querySelector("[id='#{data.id}']")
    return unless el
    ctrl = el.closest('.control-group')
    applyTextWithOrg(ctrl.querySelector('.setting-title'), data.title)
    applyHtmlWithOrg(ctrl.querySelector('.setting-description'), data.desc)
    if data.selectOptions
      options = el.querySelectorAll('option')
      for opt in options
        before = String(opt.textContent)
        applyTextWithOrg(opt, data.selectOptions[before].value)
  catch e
    console.log e

applyTextWithOrg = (elem, text) ->
  try
    return unless text
    before = String(elem.textContent)
    return if before is text
    elem.textContent = text
    elem.setAttribute('title', before)
    elem.setAttribute('data-localized', 'true')
  catch e
    console.log e

applyHtmlWithOrg = (elem, text) ->
  try
    return unless text
    before = String(elem.textContent)
    return if before is text
    elem.innerHTML = text
    elem.setAttribute('title', before)
    elem.setAttribute('data-localized', 'true')
  catch e
    console.log e


Settings =
  init : () ->
    settingsTab = document.querySelector('.tab-bar [data-type="SettingsView"]')
    settingsEnabled = settingsTab.className.includes 'active' if settingsTab
    return unless settingsTab && settingsEnabled
    #try
    # Tab title
    # settingsTab.querySelector('.title').textContent = "设置"
    sv = document.querySelector('.settings-view')

    # Font
    if process.platform is 'win32'
      font = atom.config.get('editor.fontFamily')
      if font
        sv.style["fontFamily"] = font
      else
        sv.style["fontFamily"] = "'Segoe UI', Microsoft Yahei, sans-serif"
        sv.style["fontSize"] = "12px"

    # Load all settings panels
    lastMenu = sv.querySelector('.panels-menu .active a')
    panelMenus = sv.querySelectorAll('.settings-view .panels-menu li a')
    for pm in panelMenus
      pm.click()
      pm.addEventListener('click', applyInstallPanelOnSwitch)
    # Restore last active menu
    lastMenu.click() if lastMenu

    # on Init
    applyToPanel()

    # Left-side menu
    menu = sv.querySelector('.settings-view .panels-menu')
    return unless menu
    for d in S.Settings.menu
      el = menu.querySelector("[name='#{d.label}']>a")
      applyTextWithOrg el, d.value

    # Left-side button
    ext = sv.querySelector('.settings-view .icon-link-external')
    applyTextWithOrg ext, "打开插件源码目录"

    # Add Events
    btns = sv.querySelectorAll('div.section:not(.themes-panel) .search-container .btn')
    for btn in btns
      btn.addEventListener('click', applyInstallPanelOnSwitch)

    # catch e
    #   console.error "软件汉化失败。", e

module.exports = Settings
