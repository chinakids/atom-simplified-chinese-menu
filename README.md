# Atom - Chinese(Simplified) Menu

Atom  的简体中文汉化语言包

![screenshot](https://github.com/chinakids/atom-chinese-menu/raw/master/screenshot.png)

![screenshot](https://github.com/chinakids/atom-chinese-menu/raw/master/screenshot2.png)

###更新说明

- v3.0.8  (2015-07-10)

	解决官方1.0.2升级造成的4处汉化失效(设置，打开，打开文件夹，另存为)
	bug 产生 因为官方 menu 中这几处的 label 值中`...`变为了`…`(只有这四处，所以怀疑为官方 bug)
	解决方案：在 main.coffee 中对`…` 确认，替换为`...`，从而兼容后期 atom 官方的更改`…` -> `...` or `...` -> `…`
	目前版本兼容1.0.0以及1.0.2，请放心使用，建议所有用户更新

###说明
- 基于 syon 的 japanese-menu 的中文解决方案(完整汉化)。

	[japanese-menu](https://atom.io/packages/japanese-menu)


- 翻译参考

	sublime 的汉化方案

- 繁体中文(Sheng-Bo)：

	[cht-menu](https://atom.io/packages/cht-menu)

- 日文(syon)：

	[japanese-menu](https://atom.io/packages/japanese-menu)

###平台测试

linux，mac，win 均通过测试


###LICENSE
[MIT](https://github.com/chinakids/atom-chinese-menu/raw/master/LICENSE.md)
