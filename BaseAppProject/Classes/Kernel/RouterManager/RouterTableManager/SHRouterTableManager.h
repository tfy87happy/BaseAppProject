//
//  SHRouterTableManager.h
//  SHRouterManager
//
//  Created by 汤浩博 on 2020/6/26.
//  Copyright © 2020 feiyang.tang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHRouterTargetConfig.h"
#import "SHRouterTableProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface SHRouterTableManager : NSObject<SHRouterTableProtocol>

+ (instancetype)sharedManager;

/// 获取路由表目标项配置
/// @param scheme 路由表名称
/// @param host 路径名称
- (SHRouterTargetConfig *)getRouterTableTargetWithScheme:(NSString *)scheme host:(NSString *)host;

/// scheme是否在路由表中
/// @param scheme 路由协议
- (BOOL)isSchemeExist:(NSString *)scheme;
@end

NS_ASSUME_NONNULL_END
