//
//  SHAPPThemeCommonUI.h
//  SHUIKit
//
//  Created by 汤飞扬 on 2021/4/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SHAPPThemeCommonUI : NSObject

+ (void)renderGlobalAppearances;
@end

@interface SHAPPThemeCommonUI (ThemeColor)

+ (UIColor *)randomThemeColor;
@end

@interface SHAPPThemeCommonUI (Layer)

+ (CALayer *)generateSeparatorLayer;
@end

NS_ASSUME_NONNULL_END
