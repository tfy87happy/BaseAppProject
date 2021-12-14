//
//  SHAppThemeColorDefine.h
//  SHUIKit
//
//  Created by 汤飞扬 on 2021/4/8.
//

#ifndef SHAppThemeColorDefine_h
#define SHAppThemeColorDefine_h
#import "SHAPPUIThemeManager.h"

static NSString *const QDSelectedThemeIdentifier = @"selectedThemeIdentifier";
static NSString *const QDThemeIdentifierDefault = @"Default";
static NSString *const QDThemeIdentifierGolden = @"Golden";
static NSString *const QDThemeIdentifierDark = @"Dark";

#define SHUIColorNamed(name) [UIColor themeColorWithName:name]

#pragma mark - **********************themeColor**************************
static NSString *const SHMainThemeColorKey = @"SHMainThemeColorKey";//主色

static NSString *const SHMainThemeSecondColorKey = @"SHMainThemeSecondColorKey";//辅色

static NSString *const SHMainThemeSecondFunctionColorKey = @"SHMainThemeSecondFunctionColorKey";//功能辅色

static NSString *const SHBackgroundColorKey = @"SHBackgroundColorKey";

static NSString *const SHMainTextColorKey = @"SHMainTextColorKey";

static NSString *const SHMainDetailColorKey = @"SHMainDetailColorKey";

static NSString *const SHPlaceholderColorKey = @"SHPlaceholderColorKey";

#pragma mark - **********************navigationbarColor*********************

static NSString *const SHNavBarBackgroundColorKey = @"SHNavBarBackgroundColorKey";

static NSString *const SHNavBarTitleColorKey = @"SHNavBarTitleColorKey";

static NSString *const SHNavBarTitleGradientColorKey = @"SHNavBarTitleGradientColorKey";

static NSString *const SHNavBarTintColorKey = @"SHNavBarTitleColorKey";

#pragma mark - **********************tabbarColor*********************
static NSString *const SHTabBarBackgroundColorKey = @"SHTabBarBackgroundColorKey";

static NSString *const SHTabBarTitleColorKey = @"SHTabBarTitleColorKey";

static NSString *const SHTabBarTitleSeletedColorKey = @"SHTabBarTitleSeletedColorKey";


#pragma mark - **********************tableViewColor**************************
static NSString *const SHTableViewCellBackgroundColorKey = @"SHTableViewCellBackgroundColorKey";

static NSString *const SHTableViewCellTitleColorKey = @"SHTableViewCellTitleColorKey";

static NSString *const SHTableViewCellDetailColorKey = @"SHTableViewCellDetailColorKey";

static NSString *const SHTableViewCellSeparatorColorKey = @"SHTableViewCellSeparatorColorKey";

static NSString *const SHTableViewCellBorderColorKey = @"SHTableViewCellBorderColorKey";

#pragma mark - **********************textFieldColor**************************

#pragma mark - **********************other*******************************


#endif /* SHAppThemeColorDefine_h */
