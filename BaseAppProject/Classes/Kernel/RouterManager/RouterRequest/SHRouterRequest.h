//
//  SHRouterRequest.h
//  SHRouterManager
//
//  Created by 汤浩博 on 2020/6/26.
//  Copyright © 2020 feiyang.tang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

/// 基类
@interface SHRouterRequest : NSObject

/// 传值
@property(nonatomic, copy) NSDictionary *parameters;

/// 源控制器
@property(nonatomic, strong) UIViewController *sourceVC;

@end


/// url类
@interface SHRouterURLRequest : SHRouterRequest

// The url to jump. the url's priority is higher than strUrl.
@property(nonatomic, copy) NSURL *url;

// The string url to jump.
@property(nonatomic, copy) NSString *strUrl;

- (instancetype)initWithURL:(NSURL *)url;

@end


/// param请求类
@interface SHRouterActionRequest : SHRouterRequest

// The scheme to jump.
@property(nonatomic, copy) NSString *scheme;

// The host to jump.
@property(nonatomic, copy) NSString *host;

- (instancetype)initWithScheme:(NSString *)scheme host:(NSString *)host;

- (instancetype)initWithScheme:(NSString *)scheme host:(NSString *)host parameters:(NSDictionary *)parameters;

@end
NS_ASSUME_NONNULL_END
