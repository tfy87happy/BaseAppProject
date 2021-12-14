//
//  SHRouterTableProtocol.h
//  SHRouterManager
//
//  Created by 汤浩博 on 2020/6/26.
//  Copyright © 2020 feiyang.tang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SHRouterTableProtocol <NSObject>

/// 动态创建路由表
- (BOOL)registerRouterTableDynamic;

@end

NS_ASSUME_NONNULL_END
