//
//  SHAPPThemeCommonUI.m
//  SHUIKit
//
//  Created by 汤飞扬 on 2021/4/8.
//

#import "SHAPPThemeCommonUI.h"
#import "SHThemeUIHelper.h"


@implementation SHAPPThemeCommonUI

+ (void)renderGlobalAppearances {
    [SHThemeUIHelper setThemeDefault];
}

@end

@implementation SHAPPThemeCommonUI (ThemeColor)

static NSArray<UIColor *> *themeColors = nil;
+ (UIColor *)randomThemeColor {
    if (!themeColors) {
//        themeColors = @[UIColorTheme1,
//                        UIColorTheme2,
//                        UIColorTheme3,
//                        UIColorTheme4,
//                        UIColorTheme5,
//                        UIColorTheme6,
//                        UIColorTheme7,
//                        UIColorTheme8,
//                        UIColorTheme9,
//                        UIColorTheme10];
    }
    return themeColors[arc4random() % themeColors.count];
}

@end

@implementation SHAPPThemeCommonUI (Layer)

+ (CALayer *)generateSeparatorLayer {
    CALayer *layer = [CALayer layer];
//    [layer qmui_removeDefaultAnimations];
//    layer.backgroundColor = UIColorSeparator.CGColor;
    return layer;
}

@end
