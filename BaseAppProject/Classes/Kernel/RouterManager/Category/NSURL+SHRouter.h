//
//  NSURL+SHRouter.h
//  SHRouterManager
//
//  Created by 汤浩博 on 2020/6/26.
//  Copyright © 2020 feiyang.tang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSURL (SHRouter)

/// 解析一个URL
/// @param block 回调
- (void)router_parseURLWithCallback:(void(^)(NSString *scheme, NSString *host, NSDictionary *params))block;
@end

NS_ASSUME_NONNULL_END
