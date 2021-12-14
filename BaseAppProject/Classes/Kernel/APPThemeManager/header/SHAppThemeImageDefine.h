//
//  SHAppThemeImageDefine.h
//  SHUIKit
//
//  Created by 汤飞扬 on 2021/4/9.
//

#ifndef SHAppThemeImageDefine_h
#define SHAppThemeImageDefine_h


#import "SHAPPUIThemeManager.h"

#define SHUIImageNamed(name) [UIImage themeImageNamed:name defaultImageNamed:nil]
#define SHUIImageWithColorNamed(name) [UIImage themeColorImageWithColorNamed:name]


#pragma mark - **********************System*************************
static NSString *const SHMainHomeTabImageKey = @"SHMainHomeTabImageKey";
static NSString *const SHMainHomeSeletedTabImageKey = @"SHMainHomeSeletedTabImageKey";
static NSString *const SHDeviceTabImageKey = @"SHDeviceTabImageKey";
static NSString *const SHDeviceSeletedTabImageKey = @"SHDeviceSeletedTabImageKey";
static NSString *const SHMainTabImageKey = @"SHMainTabImageKey";
static NSString *const SHMainSeletedTabImageKey = @"SHMainSeletedTabImageKey";
static NSString *const SHMainBackgroundImageKey = @"SHMainBackgroundImageKey";

#pragma mark - **********************Main**************************

#pragma mark - **********************MainDevice*********************

#pragma mark - **********************User**************************

#pragma mark - **********************Family**************************

#pragma mark - **********************Room**************************

#pragma mark - **********************Device**************************

#pragma mark - **********************Scene**************************

#pragma mark - **********************Service**************************

#pragma mark - **********************Other**************************

#endif /* SHAppThemeImageDefine_h */
