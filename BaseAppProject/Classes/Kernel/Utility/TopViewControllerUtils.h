//
//  TopViewControllerUtils.h
//  BaseAppProject
//
//  Created by 汤飞扬 on 2021/3/1.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface TopViewControllerUtils : NSObject

+ (UIViewController*)topViewControllerWithDefaultRootViewController;

+ (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController;

@end

NS_ASSUME_NONNULL_END
