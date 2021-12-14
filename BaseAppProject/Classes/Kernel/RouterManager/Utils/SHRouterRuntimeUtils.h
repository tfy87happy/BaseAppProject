//
//  SHRouterRuntimeUtils.h
//  SHRouterManager
//
//  Created by 汤浩博 on 2020/6/26.
//  Copyright © 2020 feiyang.tang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SHRouterRuntimeUtils : NSObject

/// 获取实现协议的类数组
/// @param protocol 协议
+ (NSArray *)getClassesWhichConfirmToProtocol:(Protocol *)protocol;

/// 获取类的属性
/// @param cls 类
+ (NSArray<NSString *> *)getClassProperties:(Class)cls;
@end

NS_ASSUME_NONNULL_END
