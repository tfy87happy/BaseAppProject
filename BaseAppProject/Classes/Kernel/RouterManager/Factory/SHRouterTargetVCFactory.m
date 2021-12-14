//
//  SHRouterTargetVCFactory.m
//  SHRouterManager
//
//  Created by 汤浩博 on 2020/6/26.
//  Copyright © 2020 feiyang.tang. All rights reserved.
//

#import "SHRouterTargetVCFactory.h"
#import <UIKit/UIKit.h>


@implementation SHRouterTargetVCFactory

+ (UIViewController *)createTargetVCWithTargetConfig:(SHRouterTargetConfig *)targetConfig{
    UIViewController *targetVC = nil;
    switch (targetConfig.vcType) {
        case SHRouterVCType_Class: {
            targetVC = [self createTargetVCByClassWithTargetConfig:targetConfig];
        }
            break;
        case SHRouterVCType_Xib: {
            targetVC = [self createTargetVCByXibWithTargetConfig:targetConfig];
        }
            break;
        case SHRouterVCType_Storyboard: {
            targetVC = [self createTargetVCByStoryboardWithTargetConfig:targetConfig];
        }
            break;
            
        default:
            break;
    }
    return targetVC;
}

+ (UIViewController *)createTargetVCByClassWithTargetConfig:(SHRouterTargetConfig *)targetConfig {
    Class class = NSClassFromString(targetConfig.className);
    UIViewController *targetVC = [[class alloc]init];
    return targetVC;
}

+ (UIViewController *)createTargetVCByXibWithTargetConfig:(SHRouterTargetConfig *)targetConfig {
    Class class = NSClassFromString(targetConfig.className);
    UIViewController *targetVC = [[class alloc] initWithNibName:targetConfig.fileName bundle:[self bundleForResourceWithClass:class bundlePath:targetConfig.bundlePath]];
    return targetVC;
}

+ (UIViewController *)createTargetVCByStoryboardWithTargetConfig:(SHRouterTargetConfig *)targetConfig {
    Class class = NSClassFromString(targetConfig.className);
    UIViewController *targetVC = [[UIStoryboard storyboardWithName:targetConfig.fileName bundle:[self bundleForResourceWithClass:class bundlePath:targetConfig.bundlePath]] instantiateViewControllerWithIdentifier:targetConfig.identifier];
    return targetVC;
}

+ (NSBundle*)bundleForResourceWithClass:(Class)cls bundlePath:(NSString *)bundlePath {
    if (!cls)  {
        return nil;
    }
    NSBundle* bundle = [NSBundle bundleForClass:cls];
    
    if (!bundlePath || bundlePath.length == 0) {
        return bundle;
    }
    NSURL* bundleURL = [[bundle resourceURL] URLByAppendingPathComponent:bundlePath];
    NSBundle* resourceBundle = [NSBundle bundleWithURL:bundleURL];
    return resourceBundle;
}

@end
