//
//  SHThemeResourceUtils.h
//  SHUIKit
//
//  Created by 汤飞扬 on 2021/4/8.
//



#import <Foundation/Foundation.h>
//#import "SHUIModuleDefine.h"


NS_ASSUME_NONNULL_BEGIN

@interface SHThemeResourceUtils : NSObject

@property (nonatomic, strong,readonly) NSDictionary *resourceDictionary;

/// 读取json配置资源
/// @param currentThemeIdentifier 当前主题
/// @param completion 回调
- (void)readResourceWithCurrentThemeIndetifier:(NSString *)currentThemeIdentifier completion:(void(^)(NSDictionary *resourceDictionary))completion;

/// 获取图片
/// @param name 图片定义的名称
/// @param defaultImageName 默认名称
/// @param themeIdentifier 主题标识
- (UIImage *)getImageWithName:(NSString *)name defaultImageNamed:(NSString *)defaultImageName themeIdentifier:(NSString *)themeIdentifier;

/// 获取颜色
/// @param name 颜色定义的名称
- (UIColor *)getColorWithName:(NSString *)name;

/// 清除缓存
- (void)removeCaches;

/// 获取缓存的图片
/// @param name 定义的图片名
- (UIImage *)getCacheImage:(NSString *)name;
@end

NS_ASSUME_NONNULL_END
