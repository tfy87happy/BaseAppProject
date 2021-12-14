//
//  SHRouterCore.h
//  SHRouterManager
//
//  Created by 汤浩博 on 2020/6/26.
//  Copyright © 2020 feiyang.tang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHRouterTargetConfig.h"
#import "SHRouterRequest.h"
#import "SHRouterDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface SHRouterCore : NSObject

/**
 跳转目标Controller

 @param targetConfig 目标项配置
 @param parameters 目标Controller需要的参数
 @param sourceVC 源Controller，默认为nil，若为nil，使用当前viewController作为源
 @param callback 结果回调
 */
+ (void)gotoViewControllerWithTargetConfig:(SHRouterTargetConfig *)targetConfig parameters:(NSDictionary *)parameters sourceVC:(UIViewController *)sourceVC callback:(SHRouterActionCallback)callback;
@end

NS_ASSUME_NONNULL_END
