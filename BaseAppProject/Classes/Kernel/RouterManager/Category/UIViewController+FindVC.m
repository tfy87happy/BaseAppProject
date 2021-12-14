//
//  UIViewController+FindVC.m
//  SHRouterManager
//
//  Created by 汤浩博 on 2020/6/26.
//  Copyright © 2020 feiyang.tang. All rights reserved.
//

#import "UIViewController+FindVC.h"

@implementation UIViewController (FindVC)

+ (UINavigationController *)currentNavigationController {
    return [self currentViewController].navigationController;
}

+ (UIViewController *)currentViewController {
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    UIViewController *topViewController = [window rootViewController];
    while (1) {
        if (topViewController.presentedViewController) {
            topViewController = topViewController.presentedViewController;
        } else if ([topViewController isKindOfClass:[UINavigationController class]] && [(UINavigationController*)topViewController topViewController]) {
            topViewController = [(UINavigationController *)topViewController topViewController];
        } else if ([topViewController isKindOfClass:[UITabBarController class]]) {
            UITabBarController *tab = (UITabBarController *)topViewController;
            topViewController = tab.selectedViewController;
        } else {
            break;
        }
    }
    return topViewController;
}
@end
