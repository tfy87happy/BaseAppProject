//
//  SHAPPUIThemeManager.h
//  SHUIKit
//
//  Created by 汤飞扬 on 2021/4/8.
//

#import <Foundation/Foundation.h>
#import "SHAPPThemeProtocol.h"
//#import "SHUIModuleDefine.h"

static NSString * const SHQMUIThemeChangeNotification = @"SHQMUIThemeChangeNotification";


NS_ASSUME_NONNULL_BEGIN

@interface SHAPPUIThemeManager : NSObject

@property(class, nonatomic, readonly, nullable) NSObject<SHAPPThemeProtocol> *currentTheme;

+ (instancetype)sharedInstance;

- (void)setUpDefault;

- (void)changeTheme:(NSString *)themeName;

/// 读取json配置资源
/// @param completion 回调
- (void)readResourceWithCompletion:(void(^)(NSDictionary *resourceDictionary))completion;


@end

@interface UIColor (SHTheme)

+ (UIColor *)themeColorWithName:(NSString *)name;

@property (class, nonatomic, strong,readonly) UIColor *sh_themeColor;//主色33AICF

@property (class, nonatomic, strong,readonly) UIColor *sh_themeAlphaColor;//主色33AICF加0.4的alpha

@property (class, nonatomic, strong,readonly) UIColor *sh_themeSecondColor;//辅色131313

@property (class, nonatomic, strong,readonly) UIColor *sh_themeSecondfunctionColor;//功能辅色FF5D57

@property(class, nonatomic, strong, readonly) UIColor *sh_backgroundColor;//背景颜色

@property(class, nonatomic, strong, readonly) UIColor *sh_mainTextColor;//标题颜色

@property(class, nonatomic, strong, readonly) UIColor *sh_mainDetailColor;//副标题颜色

@property(class, nonatomic, strong, readonly) UIColor *sh_placeholderColor;//placeholder颜色

@property(class, nonatomic, strong, readonly) UIColor *sh_navBarBackgroundColor;//导航背景颜色

@property (class, nonatomic, strong,readonly) UIColor *sh_navBarTitleColor;//导航标题颜色

@property (class, nonatomic, strong,readonly) UIColor *sh_navBarTitleGradientColor;//导航渐变标题颜色

@property (class, nonatomic, strong,readonly) UIColor *sh_navBarTintColor;//导航tint颜色

@property (class, nonatomic, strong,readonly) UIColor *sh_tabBarBackgroundColor;//tabbar背景颜色

@property(class, nonatomic, strong, readonly) UIColor *sh_tabBarTitleColor;//tabbar标题颜色

@property(class, nonatomic, strong, readonly) UIColor *sh_tabBarTitleSeletedColor;//tabbar标题选中颜色

@property(class, nonatomic, strong, readonly) UIColor *sh_tableViewCellBackgroundColor;//cell背景颜色

@property (class, nonatomic, strong,readonly) UIColor *sh_tableViewCellTitleColor;//cell标题颜色

@property(class, nonatomic, strong, readonly) UIColor *sh_tableViewCellDetailColor;//cell详情颜色

@property (class, nonatomic, strong,readonly) UIColor *sh_tableViewCellSeparatorColor;//cell分割线颜色

@property (class, nonatomic, strong,readonly) UIColor *sh_tableViewCellBorderColor;//cell边框颜色

@end


@interface UIImage (SHTheme)

/// 获取图片
/// @param name 图片名称
/// @param defaultImageName 默认图片
+ (UIImage *)themeImageNamed:(NSString *)name defaultImageNamed:(NSString *)defaultImageName;

/// 通过颜色生成图片
/// @param name 颜色名称
+ (UIImage *)themeColorImageWithColorNamed:(NSString *)name;

@property(class, nonatomic, strong, readonly) UIImage *sh_backgroundImage;//背景图片


@end

@interface UIFont (SHTheme)

@property (class, nonatomic, strong,readonly) UIFont *sh_font_28;

@property (class, nonatomic, strong,readonly) UIFont *sh_font_23;

@property (class, nonatomic, strong,readonly) UIFont *sh_font_18;

@property (class, nonatomic, strong,readonly) UIFont *sh_font_14;

@property (class, nonatomic, strong,readonly) UIFont *sh_font_12;

+ (UIFont *)sh_font:(CGFloat)fontValue;

@end
NS_ASSUME_NONNULL_END
