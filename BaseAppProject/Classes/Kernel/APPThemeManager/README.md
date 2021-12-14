1、SHAPPUIThemeManager为换肤框架总体管理类，需要在项目App中初始化setUpDefault方法；现在在工程中提供了DefaultTheme和GoldenTheme两套皮肤封装成bundle，默认是用DefaultTheme，所有图片需要放在smartHome的Resources/Classes/DefaultTheme里面，不要再放assets了,DefaultTheme里面可以通过子文件夹来区分不同的图片来源。如果暂时不用换肤则直接在DefaultTheme里面配置即可，换肤的测试可以在SMHomeThemeDebugViewController里面查看。

2、当需要获取一个图片时，可以调用SHAppThemeImageDefine里面的SHUIImageNamed定义获取。
eg：SHUIImageNamed(SHMainSeletedTabKey),可以在工程中搜索SHMainSeletedTabKey看看，
需要先定义SHMainSeletedTabKey字符串，然后再把SHMainSeletedTabKey映射到DefaultTheme默认主题下的SHConfigTheme.json文件中。调用逻辑是通过SHUIImageNamed——[UIImage themeImageNamed:]——[[SHAPPUIThemeManager sharedInstance] getImageWithName:]——[UIImage qmui_imageWithThemeProvider:]——[themeResourceUtils getImageWithName:]

3、当需要获取一个颜色时，可以调用SHAppThemeColorDefine里面的SHUIColorNamed方法。
eg：SHUIColorNamed(SHMainThemeColorKey),可以在工程中搜索SHMainThemeColorKey看看，
需要先定义SHMainThemeColorKey字符串，然后再把SHMainThemeColorKey映射到DefaultTheme默认主题下的SHConfigTheme.json文件中。调用逻辑是通过SHUIColorNamed——[UIColor themeColorWithName:]——[[SHAPPUIThemeManager sharedInstance] getColorWithName:]——[UIColor qmui_colorWithThemeProvider:]——[themeResourceUtils getColorWithName:]
注意：通用的颜色可以在SHAPPUIThemeManager类里面的UIColor (SHTheme)再封装一层，eg：+ (UIColor *)sh_navBarBackgroundColor，可以直接访问成UIColor.sh_navBarBackgroundColor。所有头文件基本都是已经集成了，不需要再导入。