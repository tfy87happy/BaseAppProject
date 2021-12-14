//
//  NSError+SHRouter.h
//  SHRouterManager
//
//  Created by 汤浩博 on 2020/6/26.
//  Copyright © 2020 feiyang.tang. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSInteger const kRouterErrorCode_CreateVC  = 5000101;
static NSInteger const kRouterErrorCode_HandleParamDynamic  = 5000102;
static NSInteger const kRouterErrorCode_HandleParamStatic  = 5000103;
static NSInteger const kRouterErrorCode_FindSourceVC  = 5000104;
static NSInteger const kRouterErrorCode_HandleJump  = 5000105;
static NSInteger const kRouterErrorCode_HandleAuthentication  = 5000106;

static NSInteger const kRouterErrorCode_URLParseError  = 5000201;
static NSInteger const kRouterErrorCode_TargetNotFound  = 5000202;
static NSInteger const kRouterErrorCode_OutsideOpenFailed  = 5000203;


NS_ASSUME_NONNULL_BEGIN

@interface NSError (SHRouter)

+ (instancetype)routerErrorWithCode:(NSInteger)code;

+ (instancetype)routerErrorWithCode:(NSInteger)code additionalObject:(id)obj;

@end

NS_ASSUME_NONNULL_END
