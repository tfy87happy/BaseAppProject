//
//  UIViewController+FindVC.h
//  SHRouterManager
//
//  Created by 汤浩博 on 2020/6/26.
//  Copyright © 2020 feiyang.tang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (FindVC)

/**
 当前的push容器
 
 @return 返回当前的容器
 */
+ (UINavigationController *)currentNavigationController;

/**
 当前的ViewController
 
 @return 返回当前最上面的ViewController
 */
+ (UIViewController *)currentViewController;
@end

NS_ASSUME_NONNULL_END
