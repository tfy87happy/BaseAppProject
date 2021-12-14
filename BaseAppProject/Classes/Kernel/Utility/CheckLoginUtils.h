//
//  CheckLoginUtils.h
//  BaseAppProject
//
//  Created by 汤飞扬 on 2021/3/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CheckLoginUtils : NSObject

+ (BOOL)isLogin;

+ (BOOL)checkLoginAndJump;

+ (BOOL)checkLoginAndJumpWithSuccessedHandler:(void (^)(void))successedHandler;

+ (void)jumpLogin;

@end

NS_ASSUME_NONNULL_END
