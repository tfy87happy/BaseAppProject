//
//  SHRouterCore.m
//  SHRouterManager
//
//  Created by 汤浩博 on 2020/6/26.
//  Copyright © 2020 feiyang.tang. All rights reserved.
//

#import "SHRouterCore.h"
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "SHRouterProtocol.h"
#import "SHRouterTargetVCFactory.h"
#import "UIViewController+FindVC.h"
#import "SHRouterRuntimeUtils.h"
#import "NSError+SHRouter.h"

@implementation SHRouterCore

+ (void)gotoViewControllerWithTargetConfig:(SHRouterTargetConfig *)targetConfig parameters:(NSDictionary *)parameters sourceVC:(UIViewController *)sourceVC callback:(SHRouterActionCallback)callback{
    //1.创建目标控制器
    UIViewController *targetVC = [SHRouterTargetVCFactory createTargetVCWithTargetConfig:targetConfig];
    //2.目标控制器处理认证
    if ([targetVC conformsToProtocol:@protocol(SHRouterProtocol)]) {
        UIViewController<SHRouterProtocol> *targetDynamicVC = (UIViewController<SHRouterProtocol> *)targetVC;
        if ([targetDynamicVC respondsToSelector:@selector(handleRouterAuthentication)]){
            id<SHRouterAuthObjectProtocol> authObj = [targetDynamicVC handleRouterAuthentication];
            if (authObj.code != 0) {
                if (callback) {
                    callback([NSError routerErrorWithCode:kRouterErrorCode_HandleAuthentication additionalObject:authObj]);
                }
                return;
            }
        }
        
        //实现了协议的(动态注册)
        if (![self handleRouterDynamicProtocolWithParameters:parameters targetVC:targetVC]) {
            if (callback) {
                callback([NSError routerErrorWithCode:kRouterErrorCode_HandleParamDynamic]);
            }
            return;
        }
    }
    
    //4.确定源控制器
    if (!sourceVC || ![sourceVC isKindOfClass:[UIViewController class]]) {
        sourceVC = [self findCurrentViewController];
    }
    if (!sourceVC) {
        if (callback) {
            callback([NSError routerErrorWithCode:kRouterErrorCode_FindSourceVC]);
        }
        return;
    }
    
    //5.执行跳转
    if (![self handleShowWithSourceVC:sourceVC targetVC:targetVC showType:targetConfig.showType]) {
        if (callback) {
            callback([NSError routerErrorWithCode:kRouterErrorCode_HandleJump]);
        }
        return;
    }
    
    //6.成功回调
    if (callback) {
        callback(nil);
    }
}

#pragma mark - private
+ (BOOL)handleRouterDynamicProtocolWithParameters:(NSDictionary *)parameters targetVC:(UIViewController *)targetVC {
    UIViewController<SHRouterProtocol> *targetDynamicVC = (UIViewController<SHRouterProtocol> *)targetVC;
    BOOL canHandle = YES; //默认可以处理
    if ([targetDynamicVC respondsToSelector:@selector(canHandleRouterWithParameters:)]) {
        canHandle = [targetDynamicVC canHandleRouterWithParameters:parameters];
    }
    if (!canHandle) {
        return NO;
    }
    if ([targetDynamicVC respondsToSelector:@selector(handleRouterWithParameters:)]) {
        [targetDynamicVC handleRouterWithParameters:parameters];
    }
    return YES;
}

+ (UIViewController *)findCurrentViewController {
    return [UIViewController currentViewController];
}

+ (BOOL)handleShowWithSourceVC:(UIViewController *)sourceVC targetVC:(UIViewController *)targetVC showType:(SHRouterShowType)showType {
    switch (showType) {
        case SHRouterShowType_Push:{
            [sourceVC.navigationController pushViewController:targetVC animated:YES];
        }
            break;
        case SHRouterShowType_Present:{
            [sourceVC presentViewController:targetVC animated:YES completion:nil];
        }
            break;
        case SHRouterShowType_Custom:{
            if ([targetVC conformsToProtocol:@protocol(SHRouterProtocol)] && [targetVC respondsToSelector:@selector(handleCustomShowWithSourceVC:targetVC:)]) {
                UIViewController<SHRouterProtocol> *targetDynamicVC = (UIViewController<SHRouterProtocol> *)targetVC;
                [targetDynamicVC handleCustomShowWithSourceVC:sourceVC targetVC:targetDynamicVC];
            } else {
                //默认PUSH
                [sourceVC.navigationController pushViewController:targetVC animated:YES];
            }
        }
            break;
            
        default:
            break;
    }
    return YES;
}

@end
