//
//  SHRouterManager.m
//  SHRouterManager
//
//  Created by 汤浩博 on 2020/6/26.
//  Copyright © 2020 feiyang.tang. All rights reserved.
//

#import "SHRouterManager.h"
#import "SHRouterTableManager.h"
#import "SHRouterCore.h"
#import "NSURL+SHRouter.h"
#import "NSError+SHRouter.h"
#import "MacroDefinesHeader.h"

@implementation SHRouterManager

+ (instancetype)sharedManager {
    static SHRouterManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc]init];
    });
    return manager;
}

#pragma mark - Public
+ (void)routerActionWithDefaultSchemeURLString:(NSString *)URLString paramaters:(NSDictionary *)paramaters callback:(void(^)(NSURL *URL, NSError *error))callback{
    [self routerActionWithURLString:[NSString stringWithFormat:@"%@://%@",kRouterDomain, URLString] paramaters:paramaters callback:callback];
}

+ (void)routerActionWithURLString:(NSString *)URLString paramaters:(NSDictionary *)paramaters callback:(void(^)(NSURL *URL, NSError *error))callback{
    if (!URLString.length) {
        return;
    }
    SHRouterURLRequest *URLRequest = [[SHRouterURLRequest alloc] initWithURL:[NSURL URLWithString:URLString]];
    [[SHRouterManager sharedManager] openURLWithRouterRequest:URLRequest callback:^(NSURL *URL, NSError *error) {
        
    }];
}

#pragma mark - SHRouterTableProtocol
- (BOOL)registerRouterTableDynamic {
    return [[SHRouterTableManager sharedManager] registerRouterTableDynamic];
}

#pragma mark - EGRouterManagerProtocol
- (void)openURLWithRouterRequest:(SHRouterURLRequest *)routerRequest callback:(SHRouterURLCallback)callback{
    NSURL *realURL = [self getRealURLWithRouterRequest:routerRequest];
    if (!realURL) {
        if (callback) {
            callback(realURL, [NSError routerErrorWithCode:kRouterErrorCode_URLParseError]);
        }
        return;
    }
    //解析URL
    __weak typeof(self) weakSelf = self;
    [realURL router_parseURLWithCallback:^(NSString *scheme, NSString *host, NSDictionary *params) {
        __strong typeof(self) strongSelf = weakSelf;
        
        if (![[SHRouterTableManager sharedManager] isSchemeExist:scheme]) {
            //external handler
            //            [self handleExternalRouterWithURL:realURL callback:callback];
            if (callback) {
                callback(realURL, [NSError routerErrorWithCode:kRouterErrorCode_OutsideOpenFailed]);
            }
            return;
        }
        
        NSMutableDictionary *dicParams = [NSMutableDictionary dictionary];
        if (params) {
            [dicParams setDictionary:params];
        }
        if (routerRequest.parameters) {
            [routerRequest.parameters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                if ([key isKindOfClass:[NSString class]]) {
                    [dicParams setObject:obj forKey:key];
                }
            }];
        }
        SHRouterActionRequest *routerActionRequest = [[SHRouterActionRequest alloc]initWithScheme:scheme host:host
                                                                                       parameters:dicParams];
        [strongSelf actionWithRouterRequest:routerActionRequest callback:^(NSError *error) {
            if (callback) {
                callback(realURL, error);
            }
        }];
    }];
}

- (void)actionWithRouterRequest:(SHRouterActionRequest *)routerRequest callback:(SHRouterActionCallback)callback {
    SHRouterTargetConfig *targetModel = [[SHRouterTableManager sharedManager] getRouterTableTargetWithScheme:routerRequest.scheme host:routerRequest.host];
    if (!targetModel) {
        if (callback) {
            callback([NSError routerErrorWithCode:kRouterErrorCode_TargetNotFound]);
        }
        return;
    }
    //router core handler
    [self handleRouterWithTarget:targetModel routerRequest:routerRequest callback:callback];
}

- (void)openOutSideURL:(NSURL *)URL callback:(void (^)(NSURL *URL, BOOL success))block {
    if ([[UIApplication sharedApplication] canOpenURL:URL]) {
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:URL options:@{UIApplicationOpenURLOptionUniversalLinksOnly:@(NO)} completionHandler:^(BOOL success) {
                if (block) {
                    block(URL, success);
                }
            }];
        } else {
            if ([[UIApplication sharedApplication] openURL:URL]) {
                if (block) {
                    block(URL, YES);
                }
            } else {
                if (block) {
                    block(URL, NO);
                }
            }
        }
    }
}

#pragma mark - Private
- (NSURL *)getRealURLWithRouterRequest:(SHRouterURLRequest *)routerRequest {
    if (routerRequest.url) {
        return routerRequest.url;
    }
    if (routerRequest.strUrl) {
        return [NSURL URLWithString:routerRequest.strUrl];
    }
    return nil;
}

- (void)handleRouterWithTarget:(SHRouterTargetConfig *)target routerRequest:(SHRouterActionRequest *)routerRequest callback:(SHRouterActionCallback)callback {
    [SHRouterCore gotoViewControllerWithTargetConfig:target parameters:routerRequest.parameters sourceVC:routerRequest.sourceVC callback:^(NSError *error) {
        if (callback) {
            callback(error);
        }
    }];
}

@end
