//
//  SHRouterManagerProtocol.h
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

@protocol SHRouterManagerProtocol <NSObject>

/// 请求路由跳转(URL)
/// @param routerRequest 请求体，包含请求URL
/// @param callback 结果回调
- (void)openURLWithRouterRequest:(SHRouterURLRequest *)routerRequest callback:(SHRouterURLCallback)callback;

/// 请求路由跳转
/// @param routerRequest 请求体，包含scheme、host
/// @param callback 结果回调
- (void)actionWithRouterRequest:(SHRouterActionRequest *)routerRequest callback:(SHRouterActionCallback)callback;

/// 跳转外部
/// @param URL url
/// @param block 回调
- (void)openOutSideURL:(NSURL *)URL callback:(void (^)(NSURL *URL, BOOL success))block;
@end

NS_ASSUME_NONNULL_END
