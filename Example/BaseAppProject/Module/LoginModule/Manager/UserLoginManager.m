//
//  UserLoginManager.m
//  BaseAppProject
//
//  Created by 汤飞扬 on 2021/3/1.
//

#import "UserLoginManager.h"
#import "UICKeyChainStore.h"
#import "NotificationNameHeader.h"
#import "ZARequestUtilities.h"


static NSString *const kUserLoginManagerHasLoginSucessedHistoryKey = @"kUserLoginManagerHasLoginSucessedHistoryKey"; //是否成功登录过
static NSString *const kUserLoginManagerHasLoginOutKey = @"kUserLoginManagerHasLoginOutKey"; //是否成功登出过
static NSString *const kUserLoginManagerAccountKey = @"kUserLoginManagerAccountKey"; //手机号
static NSString *const kUserLoginManagerPasswordKey = @"kUserLoginManagerPasswordKey"; //密码
static NSString *const kUserLoginIsSuccessedGotTokenKey = @"kUserLoginIsSuccessedGotTokenKey"; //是否成功获取登录Token
static NSString *const kUserLoginSuccessedTokeGetTimeStampKey = @"kUserLoginSuccessedTokeGetTimeStampKey"; //获取到登录成功Token的时间戳

static NSString *const kOldKeyChainStoreServiceName = @"com.zhenaiwang.username"; //老版本的钥匙串服务名
static NSString *const kOldUserAutologinKey = @"autologin"; //老版本用户是否自动登录key
static NSString *const kKeyChainStoreServiceName = @"com.zhenaiwang.renascence"; //新版本的钥匙串服务名

@interface UserLoginManager ()

@end

@implementation UserLoginManager

+ (instancetype)sharedInstance {
    static UserLoginManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[UserLoginManager alloc] init];
    });
    return instance;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Notification
- (void)receiveUserLoginSuccessedTokenOverdueNotification:(NSNotification *)notification{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kUserLoginIsSuccessedGotTokenKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)receiveRegisterSuccessedNotification:(NSNotification *)notification{
    NSString *phone = @"";
    NSString *password = @"";
    
}

#pragma mark - Public
- (void)configSettings{
    [self registerNotifivations];
}

+ (void)loginWithAccount:(NSString *)account password:(NSString *)password validate:(NSString *)validate completion:(void(^)(NSError *error))completion{
    
}

+ (void)logoutWithCompletion:(void (^)(NSError *))completion{
    
}

+ (void)updateLoginTokenWithCompletion:(void (^)(NSError *))completion{
    
}

+ (void)resetPasswordByLoginDynamicallyWithPhoneNumber:(NSString *)phoneNumber password:(NSString *)password completion:(void (^)(NSError *))completion{
    
}

+ (void)resetPasswordWithCurrentPassword:(NSString *)currentPassword newPassword:(NSString *)newPassword completionHandler:(void(^)(NSString *msg, NSError *error))completionHandler{
    
}

+ (void)clearLoginDatasWithCompletion:(void (^)(NSError *))completion {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kUserLoginManagerHasLoginOutKey];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kUserLoginIsSuccessedGotTokenKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (completion) {
        completion(nil);
    }
}

+ (BOOL)hasLoginSucessedHistory{
    BOOL hasLoginSucessedHistory = [[NSUserDefaults standardUserDefaults] boolForKey:kUserLoginManagerHasLoginSucessedHistoryKey];
    
    if (hasLoginSucessedHistory) {
        NSString *account = [self loginUserAccount];
        NSString *password = [self loginUserPassword];
        
        if (account.length == 0 || password.length == 0) {
            hasLoginSucessedHistory = NO;
        }
    }
    
    return hasLoginSucessedHistory;
}

+ (BOOL)hasLogouted{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kUserLoginManagerHasLoginOutKey];
}

+ (BOOL)hasLoginSuccessedToken{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kUserLoginIsSuccessedGotTokenKey];
}

+ (BOOL)hasLoginSucessedStatus{
    return ([self hasLoginSucessedHistory] && ![self hasLogouted] && [self hasLoginSuccessedToken]);
}

+ (NSString *)loginUserAccount{
    BOOL hasLoginSucessedHistory = [[NSUserDefaults standardUserDefaults] boolForKey:kUserLoginManagerHasLoginSucessedHistoryKey];
    if (!hasLoginSucessedHistory) {
        return nil;
    }
    
    UICKeyChainStore *keyChainStore = [self keyChainStore];
    NSString *account = [keyChainStore stringForKey:kUserLoginManagerAccountKey];
    return account;
}

+ (NSString *)loginUserPassword{
    BOOL hasLoginSucessedHistory = [[NSUserDefaults standardUserDefaults] boolForKey:kUserLoginManagerHasLoginSucessedHistoryKey];
    if (!hasLoginSucessedHistory) {
        return nil;
    }
    
    UICKeyChainStore *keyChainStore = [self keyChainStore];
    NSString *password = [keyChainStore stringForKey:kUserLoginManagerPasswordKey];
    return password;
}

#pragma mark - Private
- (void)registerNotifivations{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveUserLoginSuccessedTokenOverdueNotification:) name:ZAUserLoginSuccessedTokenOverdueNotificationName object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveRegisterSuccessedNotification:) name:ZAUserRegisterSuccessedNotificationName object:nil];
}

+ (UICKeyChainStore *)keyChainStore{
    return [UICKeyChainStore keyChainStoreWithService:kKeyChainStoreServiceName];
}

+ (void)updateLoginSuccessedStatus{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kUserLoginManagerHasLoginOutKey];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kUserLoginManagerHasLoginSucessedHistoryKey];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kUserLoginIsSuccessedGotTokenKey];
    [[NSUserDefaults standardUserDefaults] setDouble:[[NSDate date] timeIntervalSince1970] forKey:kUserLoginSuccessedTokeGetTimeStampKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)saveAccount:(NSString *)account andPassword:(NSString *)password{
    if (account.length == 0 || password.length == 0) {
        return;
    }
    
    [self updateLoginSuccessedStatus];
    
    UICKeyChainStore *keyChainStore = [self keyChainStore];
    [keyChainStore setString:account forKey:kUserLoginManagerAccountKey];
    [keyChainStore setString:password forKey:kUserLoginManagerPasswordKey];
}

- (void)saveOldAccount:(NSString *)account andOldPassword:(NSString *)password {
    if (account.length == 0 || password.length == 0) {
        return;
    }
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kUserLoginManagerHasLoginSucessedHistoryKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    UICKeyChainStore *keyChainStore = [[self class] keyChainStore];
    [keyChainStore setString:account forKey:kUserLoginManagerAccountKey];
    [keyChainStore setString:password forKey:kUserLoginManagerPasswordKey];
}

+ (NSTimeInterval)lastLoginTokenUpdateSuccessedTimeStamp {
    return [[NSUserDefaults standardUserDefaults] doubleForKey:kUserLoginSuccessedTokeGetTimeStampKey];
}

@end
