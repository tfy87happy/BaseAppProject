//
//  SHRouterTableManager.m
//  SHRouterManager
//
//  Created by 汤浩博 on 2020/6/26.
//  Copyright © 2020 feiyang.tang. All rights reserved.
//

#import "SHRouterTableManager.h"
#import "SHRouterRuntimeUtils.h"
#import "SHRouterProtocol.h"

@interface SHRouterTableManager()

//路由表集合，表结构 NSDictionary<scheme, NSDictionary<host, targetConfig>>
@property(nonatomic, strong) NSMutableDictionary<NSString *, NSMutableDictionary<NSString *, SHRouterTargetConfig *> *> *routerTables;

@end

@implementation SHRouterTableManager

+ (instancetype)sharedManager {
    static SHRouterTableManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc]init];
    });
    return manager;
}

- (NSMutableDictionary *)routerTables {
    if (!_routerTables) {
        _routerTables = [NSMutableDictionary dictionary];
    }
    return _routerTables;
}

#pragma mark - PUBLIC
- (SHRouterTargetConfig *)getRouterTableTargetWithScheme:(NSString *)scheme host:(NSString *)host {
    if (!scheme || scheme.length == 0) {
        return nil;
    }
    if (!host || host.length == 0) {
        return nil;
    }
    //获取路由表
    NSDictionary *routerTable = self.routerTables[scheme];
    if (!routerTable) {
        return nil;
    }
    //获取路由表目标项
    SHRouterTargetConfig *targetConfig = routerTable[host];
    if (!targetConfig) {
        return nil;
    }
    
    if ([targetConfig isKindOfClass:[SHRouterTargetConfig class]]) {
        return targetConfig;
    }
    return nil;
}

- (BOOL)isSchemeExist:(NSString *)scheme {
    if (!scheme || scheme.length == 0) {
        return NO;
    }
    if (self.routerTables[scheme]) {
        return YES;
    }
    return NO;
}

#pragma mark - SHRouterTableProtocol
- (BOOL)registerRouterTableDynamic {
    NSArray *classes = [SHRouterRuntimeUtils getClassesWhichConfirmToProtocol:@protocol(SHRouterProtocol)];
    for (Class<SHRouterProtocol> class in classes) {
        NSString *scheme = nil;
        NSString *host = nil;
        SHRouterTargetConfig *targetConfig = nil;
        
        if ([class respondsToSelector:@selector(schemeForRouter)]) {
            scheme = [class schemeForRouter];
        }
        
        if ([class respondsToSelector:@selector(hostForRouter)]) {
            host = [class hostForRouter];
        } else {
            host = NSStringFromClass(class);
        }
        
        if ([class respondsToSelector:@selector(targetConfigForRouter)]) {
            targetConfig = [class targetConfigForRouter];
        }
        
        if (scheme && host && targetConfig) {
            [self addRouterTableTargetWithScheme:scheme host:host targetConfig:targetConfig];
        }
    }
    return YES;
}

#pragma mark - Private
- (BOOL)addRouterTableTargetWithScheme:(NSString *)scheme host:(NSString *)host targetConfig:(SHRouterTargetConfig *)targetConfig {
    NSMutableDictionary *originRouterTable = self.routerTables[scheme];
    if (originRouterTable) {
        [originRouterTable setObject:targetConfig forKey:host];
    } else {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:targetConfig forKey:host];
        [self.routerTables setObject:dic forKey:scheme];
    }
    return YES;
}
@end
