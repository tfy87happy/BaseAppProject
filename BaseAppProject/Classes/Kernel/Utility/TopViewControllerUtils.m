//
//  TopViewControllerUtils.m
//  BaseAppProject
//
//  Created by 汤飞扬 on 2021/3/1.
//

#import "TopViewControllerUtils.h"

@implementation TopViewControllerUtils

+ (UIViewController *)topViewControllerWithDefaultRootViewController {
    
    return [TopViewControllerUtils topViewControllerWithRootViewController:[UIApplication sharedApplication].delegate.window.rootViewController];
}

+ (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController {
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController*)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}

@end
