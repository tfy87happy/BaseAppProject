//
//  UserLoginManager.h
//  BaseAppProject
//
//  Created by 汤飞扬 on 2021/3/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserLoginManager : NSObject

+ (instancetype)sharedInstance;

- (void)configSettings;

+ (void)loginWithAccount:(NSString *)account password:(NSString *)password validate:(NSString *)validate completion:(void(^)(NSError *error))completion;

+ (void)logoutWithCompletion:(void (^)(NSError *))completion;

+ (void)updateLoginTokenWithCompletion:(void (^)(NSError *))completion;

+ (void)resetPasswordByLoginDynamicallyWithPhoneNumber:(NSString *)phoneNumber password:(NSString *)password completion:(void (^)(NSError *))completion;

+ (void)resetPasswordWithCurrentPassword:(NSString *)currentPassword newPassword:(NSString *)newPassword completionHandler:(void(^)(NSString *msg, NSError *error))completionHandler;

+ (void)clearLoginDatasWithCompletion:(void (^)(NSError *))completion;

+ (BOOL)hasLoginSucessedHistory;

+ (BOOL)hasLogouted;

+ (BOOL)hasLoginSuccessedToken;

+ (BOOL)hasLoginSucessedStatus;

+ (NSString *)loginUserAccount;

+ (NSString *)loginUserPassword;

@end

NS_ASSUME_NONNULL_END
