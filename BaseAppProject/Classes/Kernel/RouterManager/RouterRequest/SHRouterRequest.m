//
//  SHRouterRequest.m
//  SHRouterManager
//
//  Created by 汤浩博 on 2020/6/26.
//  Copyright © 2020 feiyang.tang. All rights reserved.
//

#import "SHRouterRequest.h"

@implementation SHRouterRequest

@end

@implementation SHRouterURLRequest

- (instancetype)initWithURL:(NSURL *)url {
    if (self = [super init]) {
        self.url = url;
    }
    return self;
}

@end

@implementation SHRouterActionRequest

- (instancetype)initWithScheme:(NSString *)scheme host:(NSString *)host {
    if (self = [super init]) {
        self.scheme = scheme;
        self.host = host;
    }
    return self;
}

- (instancetype)initWithScheme:(NSString *)scheme host:(NSString *)host parameters:(NSDictionary *)parameters {
    if (self = [self initWithScheme:scheme host:host]) {
        self.parameters = parameters;
    }
    return self;
}

@end
