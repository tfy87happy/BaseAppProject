//
//  SHAPPUIThemeManager.m
//  SHUIKit
//
//  Created by 汤飞扬 on 2021/4/8.
//

#import "SHAPPUIThemeManager.h"
#import "UIColor+QMUITheme.h"
#import "SHAPPThemeProtocol.h"
#import "QMUIThemeManagerCenter.h"
#import "QMUITheme.h"
#import "SHThemeResourceUtils.h"
#import "SHAPPThemeCommonUI.h"
#import "QMUIConfigurationTemplateDark.h"
#import "QMUIConfigurationTemplate.h"
#import "QMUIConfigurationTemplateGolden.h"
#import "UIColor+QMUI.h"
#import "SHAppThemeColorDefine.h"
#import "SHAppThemeImageDefine.h"
#import "UIImage+QMUI.h"


static NSDictionary *colorTestDictionary;


@interface SHAPPUIThemeManager ()

@property (nonatomic, strong) NSDictionary *resourceDictionary;

@property (nonatomic, strong) SHThemeResourceUtils *themeResourceUtils;//资源读取管理类

@end

@implementation SHAPPUIThemeManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static SHAPPUIThemeManager *instance = nil;
    dispatch_once(&onceToken,^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    return [self sharedInstance];
}

- (instancetype)init {
    if (self = [super init]) {
        colorTestDictionary = @{
            QDThemeIdentifierDefault:@"90dfed",
            QDThemeIdentifierDark:@"ffffff",
            QDThemeIdentifierGolden:@"434cbf",
        };
    }
    return self;
}

+ (NSObject<SHAPPThemeProtocol> *)currentTheme {
    return QMUIThemeManagerCenter.defaultThemeManager.currentTheme;
}

#pragma mark - Notification
- (void)addNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleThemeDidChangeNotification:) name:QMUIThemeDidChangeNotification object:nil];
}

- (void)handleThemeDidChangeNotification:(NSNotification *)notification{
    QMUIThemeManager *manager = notification.object;
    //if (![manager.name isEqual:QMUIThemeManagerNameDefault]) return;
    NSString *currentThemeIdentifier = manager.currentThemeIdentifier;
    
    [[NSUserDefaults standardUserDefaults] setObject:currentThemeIdentifier forKey:QDSelectedThemeIdentifier];
    
    if ([[NSUserDefaults standardUserDefaults] synchronize]) {
        NSLog(@"selectedThemeIdentifier save  is %@",currentThemeIdentifier);
    }
    
    [SHAPPUIThemeManager.currentTheme applyConfigurationTemplate];
    
    // 主题发生变化，在这里更新全局 UI 控件的 appearance
    [SHAPPThemeCommonUI renderGlobalAppearances];
    
    //通知外面主题更新
    [self postThemeChangeNotification];
}

//更换主题 通知刷新UI控件
- (void)postThemeChangeNotification{
    [[NSNotificationCenter defaultCenter] postNotificationName:SHQMUIThemeChangeNotification object:[self getCurrentThemeIdentifier]];
}

#pragma mark - Public
- (void)setUpDefault{
    [self readResourceWithCompletion:nil];
    
    // 1. 先注册主题监听，在回调里将主题持久化存储，避免启动过程中主题发生变化时读取到错误的值
    [self addNotifications];
    // 2. 然后设置主题的生成器
    QMUIThemeManagerCenter.defaultThemeManager.themeGenerator = ^__kindof NSObject * _Nonnull(NSString * _Nonnull identifier) {
        if ([identifier isEqualToString:QDThemeIdentifierDefault]) return QMUIConfigurationTemplate.new;
        if ([identifier isEqualToString:QDThemeIdentifierGolden]) return QMUIConfigurationTemplateGolden.new;
        if ([identifier isEqualToString:QDThemeIdentifierDark]) {
            QMUIConfigurationTemplateDark.new;
        }
        return nil;
    };

//    // 3. 再针对 iOS 13 开启自动响应系统的 Dark Mode 切换
//    // 如果不需要这个功能，则不需要这一段代码
//    if (@available(iOS 13.0, *)) {
//        // 做这个 if(currentThemeIdentifier) 的保护只是为了避免 QD 里的配置表没启动时，没人为 currentTheme/currentThemeIdentifier 赋值，导致后续的逻辑会 crash，业务项目里理论上不会有这种情况出现，所以可以省略这个 if 块
//        if (QMUIThemeManagerCenter.defaultThemeManager.currentThemeIdentifier) {
//            QMUIThemeManagerCenter.defaultThemeManager.identifierForTrait = ^__kindof NSObject<NSCopying> * _Nonnull(UITraitCollection * _Nonnull trait) {
//                return [self themeForTrait:trait];
//            };
//            QMUIThemeManagerCenter.defaultThemeManager.respondsSystemStyleAutomatically = YES;
//        }
//    }
    
    // QMUIConsole 默认只在 DEBUG 下会显示，作为 Demo，改为不管什么环境都允许显示
//    [QMUIConsole sharedInstance].canShow = YES;
    
    // QD自定义的全局样式渲染
    [SHAPPThemeCommonUI renderGlobalAppearances];
}

- (void)changeTheme:(NSString *)themeName{
    if (!themeName.length) {
        return;
    }
    
    if ([[self getCurrentThemeIdentifier] isEqualToString:themeName]) {
        return;
    }
    [self changeTheme:themeName needModifyLaunchScreen:NO];
}

- (void)readResourceWithCompletion:(void(^)(NSDictionary *resourceDictionary))completion{
    [self.themeResourceUtils readResourceWithCurrentThemeIndetifier:[self getCurrentThemeIdentifier] completion:completion];
}


#pragma mark - Private
- (UIImage *)getImageWithName:(NSString *)name defaultImageNamed:(NSString *)defaultImageName{
    if (!name.length) {
        return [[UIImage alloc] init];
    }
//    return [self.themeResourceUtils getImageWithName:name themeIdentifier:[self getCurrentThemeIdentifier]];
//    UIImage *cacheImage = [self.themeResourceUtils getCacheImage:name];
//    if (cacheImage) {
//        return cacheImage;
//    }
    return  [UIImage qmui_imageWithThemeProvider:^UIImage * _Nonnull(__kindof QMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, __kindof NSObject * _Nullable theme) {
        return [self.themeResourceUtils getImageWithName:name defaultImageNamed:defaultImageName themeIdentifier:identifier];
    }];
}

- (UIColor *)getColorWithName:(NSString *)name{
    return  [UIColor qmui_colorWithThemeProvider:^UIColor * _Nonnull(__kindof QMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, __kindof NSObject * _Nullable theme) {
        return [self.themeResourceUtils getColorWithName:name];
    }];
}

- (NSString *)getCurrentThemeIdentifier{
    NSString *currentThemeIdentifier = QMUIThemeManagerCenter.defaultThemeManager.currentThemeIdentifier;
    if (!currentThemeIdentifier.length) {
        currentThemeIdentifier = QDThemeIdentifierDefault;
    }
    return currentThemeIdentifier;
}

-(NSObject<NSCopying> *)themeForTrait:(UITraitCollection * _Nonnull) trait{
    if (trait.userInterfaceStyle == UIUserInterfaceStyleDark) {
        return QDThemeIdentifierDark;
    }

    if ([QMUIThemeManagerCenter.defaultThemeManager.currentThemeIdentifier isEqual:QDThemeIdentifierDark]) {
        return QDThemeIdentifierDefault;
    }
    return QMUIThemeManagerCenter.defaultThemeManager.currentThemeIdentifier;
}

- (void)changeTheme:(NSString *)themeName needModifyLaunchScreen:(BOOL)needModifyLaunchScreen{
    __weak typeof(self) weakSelf = self;
    
    NSLog(@"selectedThemeIdentifier **** %@",themeName);
    [[NSUserDefaults standardUserDefaults] setObject:themeName forKey:@"currentThemeIdentifier"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.themeResourceUtils readResourceWithCurrentThemeIndetifier:themeName completion:^(NSDictionary * _Nonnull resourceDictionary) {
        __strong typeof(self) strongSelf = weakSelf;
        
//        if (!resourceDictionary.allKeys.count) {
//            return;
//        }
        
        QMUIThemeManagerCenter.defaultThemeManager.currentThemeIdentifier  = themeName;
        
        if (needModifyLaunchScreen) {
            [strongSelf modifyLaunchScreen];
        }
    }];
}

// 换肤LaunchScreen
- (void)modifyLaunchScreen{
    
}

#pragma mark - Setter && Getter
- (SHThemeResourceUtils *)themeResourceUtils{
    if (!_themeResourceUtils) {
        _themeResourceUtils = [[SHThemeResourceUtils alloc] init];
    }
    return _themeResourceUtils;
}

@end

@implementation UIColor (SHTheme)

+ (UIColor *)themeColorWithName:(NSString *)name{
    return [[SHAPPUIThemeManager sharedInstance] getColorWithName:name];
}

+ (UIColor *)sh_themeColor{
    return [[SHAPPUIThemeManager sharedInstance] getColorWithName:SHMainThemeColorKey];
}

+ (UIColor *)sh_themeAlphaColor{
    return [UIColor.sh_themeColor colorWithAlphaComponent:0.4];
}

+ (UIColor *)sh_themeSecondColor{
    return [[SHAPPUIThemeManager sharedInstance] getColorWithName:SHMainThemeSecondColorKey];
}

+ (UIColor *)sh_themeSecondfunctionColor{
    return [[SHAPPUIThemeManager sharedInstance] getColorWithName:SHMainThemeSecondFunctionColorKey];
}

+ (UIColor *)sh_backgroundColor {
    return [[SHAPPUIThemeManager sharedInstance] getColorWithName:SHBackgroundColorKey];
}

+ (UIColor *)sh_mainTextColor {
    return [[SHAPPUIThemeManager sharedInstance] getColorWithName:SHMainTextColorKey];
}

+ (UIColor *)sh_mainDetailColor{
    return [UIColor.sh_mainTextColor colorWithAlphaComponent:0.5];
}

+ (UIColor *)sh_placeholderColor {
    return [[SHAPPUIThemeManager sharedInstance] getColorWithName:SHPlaceholderColorKey];
}

+ (UIColor *)sh_navBarBackgroundColor {
    return [UIColor clearColor];
    return [[SHAPPUIThemeManager sharedInstance] getColorWithName:SHNavBarBackgroundColorKey];
}

+ (UIColor *)sh_navBarTitleColor {
    return [[SHAPPUIThemeManager sharedInstance] getColorWithName:SHNavBarTitleColorKey];
}

+ (UIColor *)sh_navBarTitleGradientColor {
    return [[SHAPPUIThemeManager sharedInstance] getColorWithName:SHNavBarTitleGradientColorKey];
}

+ (UIColor *)sh_navBarTintColor {
    return [[SHAPPUIThemeManager sharedInstance] getColorWithName:SHNavBarTintColorKey];
}

+ (UIColor *)sh_tabBarBackgroundColor {
    return [[SHAPPUIThemeManager sharedInstance] getColorWithName:SHTabBarBackgroundColorKey];
}

+ (UIColor *)sh_tabBarTitleColor {
    return [[SHAPPUIThemeManager sharedInstance] getColorWithName:SHTabBarTitleColorKey];
}

+ (UIColor *)sh_tabBarTitleSeletedColor {
    CGRect frame = CGRectMake(0, 0, 25, 10);
    UIColor *color = [[SHAPPUIThemeManager sharedInstance] getColorWithName:SHTabBarTitleSeletedColorKey];
//    if (@available(iOS 13.0, *)){
//        color = [UIColor sh_defaultGradientColorWithFrame:frame];
//    }
    return color;
}

+ (UIColor *)sh_tabBarSeletedTitleColor {
    return [[SHAPPUIThemeManager sharedInstance] getColorWithName:SHTabBarTitleSeletedColorKey];
}

+ (UIColor *)sh_tableViewCellBackgroundColor {
    return [[SHAPPUIThemeManager sharedInstance] getColorWithName:SHTableViewCellBackgroundColorKey];
}

+ (UIColor *)sh_tableViewCellTitleColor {
    return [[SHAPPUIThemeManager sharedInstance] getColorWithName:SHTableViewCellTitleColorKey];
}

+ (UIColor *)sh_tableViewCellDetailColor {
    return [[SHAPPUIThemeManager sharedInstance] getColorWithName:SHTableViewCellDetailColorKey];
}

+ (UIColor *)sh_tableViewCellSeparatorColor {
    return [[[SHAPPUIThemeManager sharedInstance] getColorWithName:SHTableViewCellSeparatorColorKey] colorWithAlphaComponent:0.1];
}

+ (UIColor *)sh_tableViewCellBorderColor {
    return [[SHAPPUIThemeManager sharedInstance] getColorWithName:SHTableViewCellBorderColorKey];
}

@end


@implementation UIImage (SHTheme)

+ (UIImage *)themeImageNamed:(NSString *)name defaultImageNamed:(NSString *)defaultImageName{
    return [[SHAPPUIThemeManager sharedInstance] getImageWithName:name defaultImageNamed:defaultImageName];
}

+ (UIImage *)themeColorImageWithColorNamed:(NSString *)name{
    UIColor *color = [[SHAPPUIThemeManager sharedInstance] getColorWithName:name];
    return [UIImage qmui_imageWithColor:color];
}

+ (UIImage *)sh_backgroundImage{
    return [UIImage themeImageNamed:SHMainBackgroundImageKey defaultImageNamed:nil];
}

@end

@implementation  UIFont (SHTheme)

+ (UIFont *)sh_font:(CGFloat)fontValue{
    return [UIFont fontWithName:@"PingFangSC-Regular" size:fontValue];
}

+ (UIFont *)sh_font_28{
    return [self sh_font:28];
}

+ (UIFont *)sh_font_23{
    return [self sh_font:23];
}

+ (UIFont *)sh_font_18{
    return [self sh_font:28];
}

+ (UIFont *)sh_font_14{
    return [self sh_font:14];
}

+ (UIFont *)sh_font_12{
    return [self sh_font:12];
}

@end
