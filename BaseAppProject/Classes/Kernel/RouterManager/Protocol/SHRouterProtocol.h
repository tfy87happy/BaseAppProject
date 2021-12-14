//
//  SHRouterProtocol.h
//  SHRouterManager
//
//  Created by 汤浩博 on 2020/6/26.
//  Copyright © 2020 feiyang.tang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHRouterTargetConfig.h"
#import "SHRouterAuthObjectProtocol.h"
#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@protocol SHRouterProtocol <NSObject>

/// 获取目标控制器所属模块的协议名称
+ (NSString *)schemeForRouter;

/// 获取目标控制器配置
+ (SHRouterTargetConfig *)targetConfigForRouter;

@optional

/// 获取目标控制器的路径名称(如果未实现该协议，默认使用控制器类名)
+ (NSString *)hostForRouter;

/// 处理认证，认证成功后才能处理路由跳转
- (id<SHRouterAuthObjectProtocol>)handleRouterAuthentication;

///  根据路由参数判断是否可以该路由(如果未实现该协议，默认YES)
/// @param parameters 路由参数
- (BOOL)canHandleRouterWithParameters:(NSDictionary *)parameters;

/// 处理路由，可以对目标项做参数赋值（如果未实现该协议，默认使用KVC赋值）
/// @param parameters 路由参数
- (void)handleRouterWithParameters:(NSDictionary *)parameters;

/// 支持自定义控制器跳转（如果定义为CustomType，而未实现该协议，默认Push的方式跳转）
/// @param sourceVC 源控制器
/// @param targetVC 目标控制器
- (void)handleCustomShowWithSourceVC:(UIViewController *)sourceVC targetVC:(UIViewController *)targetVC;
@end

NS_ASSUME_NONNULL_END
