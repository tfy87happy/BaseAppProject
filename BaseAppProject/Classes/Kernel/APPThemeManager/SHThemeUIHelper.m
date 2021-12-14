//
//  SHThemeUIHelper.m
//  SHUIKit
//
//  Created by 汤飞扬 on 2021/4/8.
//

#import "SHThemeUIHelper.h"
#import "UIImage+QMUI.h"
#import "UIColor+QMUI.h"
#import "QMUIConfiguration.h"
#import "SHAPPUIThemeManager.h"
#import "UIImage+YYAdd.h"
#import "SHAppThemeImageDefine.h"


@implementation SHThemeUIHelper

#pragma mark - Public
+ (void)setThemeDefault{
    //tabbar
//    [self setTabbarDefault];
//    //Navigationbar
//    [self setNavigationDefault];
}

+ (void)setTabbarDefault{
    QMUIConfiguration *configuration = [QMUIConfiguration sharedInstance];
    configuration.tabBarItemTitleColor = UIColor.sh_tabBarTitleColor;
    configuration.tabBarItemTitleColorSelected = UIColor.sh_tabBarTitleSeletedColor;
    configuration.tabBarShadowImageColor = [UIColor clearColor];
    configuration.tabBarBackgroundImage = [UIImage imageWithColor:UIColor.sh_tabBarBackgroundColor];
}

+ (void)setNavigationDefault{
    QMUIConfiguration *configuration = [QMUIConfiguration sharedInstance];
    configuration.navBarBackgroundImage = [UIImage imageWithColor:[UIColor.sh_navBarBackgroundColor colorWithAlphaComponent:0.04]];
}
@end

@implementation SHThemeUIHelper (Theme)

@end
