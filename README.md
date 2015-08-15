# Atom - Chinese(Simplified) Menu

Atom  的简体中文汉化语言包

![screenshot](https://github.com/chinakids/atom-chinese-menu/raw/master/screenshot.png)

![screenshot](https://github.com/chinakids/atom-chinese-menu/raw/master/screenshot2.png)

###更新说明
- v3.1.6  (2015-08-06)

	优化 mac 下部分翻译，另外做个统计，是否需要汉化第三方插件扩展的菜单 or Setting菜单？有需要的请到 [Issues](https://github.com/chinakids/atom-simplified-chinese-menu/issues) 告诉我~

- v3.1.5  (2015-08-05)

	优化部分翻译，代码完全 coffee 化，修复 bug

- v3.1.0  (2015-07-21)

	优化部分翻译，本地化翻译内容

- v3.0.8  (2015-07-10)

	解决官方1.0.2升级造成的4处汉化失效(设置，打开，打开文件夹，另存为)
	bug 产生 因为官方 menu 中这几处的 label 值中`...`变为了`…`(查证后为官方正常改动，后期均为`…`)
	解决方案：在 main.coffee 中对`…` 确认，替换为`...`，从而兼容后期 atom 官方的更改`...` -> `…`
	目前版本兼容Atom 所有已发布版本，请放心使用，建议所有用户更新

###说明
- 基于 syon 的 japanese-menu 的衍生的中文解决方案(完整汉化)。

	[japanese-menu](https://atom.io/packages/japanese-menu)

	Setting 部分并未汉化，第一考虑到部分朋友熟悉了 Setting的英文设置，第二考虑到官方并未给出完美的setting 设置接口


- 翻译参考

	sublime 的汉化方案
	以及其他来自网络的资料

###其他

- 繁体中文(Sheng-Bo)：

	[cht-menu](https://atom.io/packages/cht-menu)

- 日文(syon)：

	[japanese-menu](https://atom.io/packages/japanese-menu)

###平台测试

linux，mac，win 均通过测试


###LICENSE
[MIT](https://github.com/chinakids/atom-chinese-menu/raw/master/LICENSE.md)
