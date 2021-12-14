//
//  SHRouterManager.h
//  SHRouterManager
//
//  Created by 汤浩博 on 2020/6/26.
//  Copyright © 2020 feiyang.tang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHRouterManagerProtocol.h"
#import "SHRouterTableProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface SHRouterManager : NSObject<SHRouterTableProtocol,SHRouterManagerProtocol>

+ (instancetype)sharedManager;

/// 跳转默认scheme的方法
/// @param URLString 具体的url
/// @param paramaters 参数
/// @param callback 回调
+ (void)routerActionWithDefaultSchemeURLString:(NSString *)URLString paramaters:(NSDictionary *)paramaters callback:(void(^)(NSURL *URL, NSError *error))callback;

/// 跳转方法
/// @param URLString shcheme+url
/// @param paramaters 参数
/// @param callback 回调
+ (void)routerActionWithURLString:(NSString *)URLString paramaters:(NSDictionary *)paramaters callback:(void(^)(NSURL *URL, NSError *error))callback;


@end

NS_ASSUME_NONNULL_END
