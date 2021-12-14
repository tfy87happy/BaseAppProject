//
//  TabbarController.h
//  BaseAppProject
//
//  Created by 汤飞扬 on 2021/3/2.
//

#import <Foundation/Foundation.h>
#import <Foundation/Foundation.h>
#if __has_include(<CYLTabBarController/CYLTabBarController.h>)
#import <CYLTabBarController/CYLTabBarController.h>
#else
#import "CYLTabBarController.h"
#endif

NS_ASSUME_NONNULL_BEGIN

@interface TabbarController : CYLTabBarController

- (instancetype)initWithContext:(NSString *)context;

@end

NS_ASSUME_NONNULL_END
