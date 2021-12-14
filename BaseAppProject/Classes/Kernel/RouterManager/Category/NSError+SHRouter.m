//
//  NSError+SHRouter.m
//  SHRouterManager
//
//  Created by 汤浩博 on 2020/6/26.
//  Copyright © 2020 feiyang.tang. All rights reserved.
//

#import "NSError+SHRouter.h"

static NSString * const CLRouterDomain = @"com.router.domain";

static NSMutableDictionary *dicErrorMsgs;

@implementation NSError (SHRouter)

+ (void)initialize {
    dicErrorMsgs = [NSMutableDictionary dictionary];
    [self addErrorMsgs];
}

+ (void)addErrorMsgs {
    @synchronized(dicErrorMsgs) {
        dicErrorMsgs[@(kRouterErrorCode_CreateVC)] = @"Create View Controller or Class error!";
        dicErrorMsgs[@(kRouterErrorCode_HandleParamDynamic)] = @"Handle Parameters setting (dynamic) for View Controller error!";
        dicErrorMsgs[@(kRouterErrorCode_HandleParamStatic)] = @"Handle Parameters setting (static) for View Controller error!";
        dicErrorMsgs[@(kRouterErrorCode_FindSourceVC)] = @"Can not found the source view controller!";
        dicErrorMsgs[@(kRouterErrorCode_HandleJump)] = @"Handle Jump in view controllers failed!";
        dicErrorMsgs[@(kRouterErrorCode_HandleAuthentication)] = @"Handle Authentication in view controllers failed!";
        
        dicErrorMsgs[@(kRouterErrorCode_URLParseError)] = @"the input url parse error!";
        dicErrorMsgs[@(kRouterErrorCode_TargetNotFound)] = @"can not found the target config in router table!";
        dicErrorMsgs[@(kRouterErrorCode_OutsideOpenFailed)] = @"open url with outside failed!";
    }
}

+ (instancetype)routerErrorWithCode:(NSInteger)code {
    return [self errorWithDomain:CLRouterDomain code:code userInfo:@{@"msg":[self routerErrorMsgWithCode:code]}];
}

+ (NSString *)routerErrorMsgWithCode:(NSInteger)code {
    return dicErrorMsgs[@(code)] ?: @"can not found reason!";
}

+ (instancetype)routerErrorWithCode:(NSInteger)code additionalObject:(id)obj {
    return [self errorWithDomain:CLRouterDomain code:code userInfo:
  @{
    @"msg":[self routerErrorMsgWithCode:code],
    @"obj":obj ?: @{}
    }];
}
@end
