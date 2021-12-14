//
//  SHRouterAuthObjectProtocol.h
//  SHRouterManager
//
//  Created by 汤浩博 on 2020/6/26.
//  Copyright © 2020 feiyang.tang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SHRouterAuthObjectProtocol <NSObject>

//认证状态码：0代表成功，非0代表失败，失败原因可由业务层用非0数字标识
@property(nonatomic, assign) NSInteger code;

@end

NS_ASSUME_NONNULL_END
