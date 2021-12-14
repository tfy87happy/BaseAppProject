//
//  AppStartUpManager.m
//  BaseAppProject
//
//  Created by 汤飞扬 on 2021/3/2.
//

#import "AppStartUpManager.h"
#import "AppWindowRootViewManager.h"
#import "RemotePushManager.h"
#import "MobilePhoneCallManager.h"
//#import "SHAPPUIThemeManager.h"
#import "NetworkConfigManager.h"
#import "SHRouterManager.h"

@interface AppStartUpManager ()

@end

@implementation AppStartUpManager

+ (instancetype)sharedInstance {
    static AppStartUpManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[AppStartUpManager alloc] init];
    });
    return instance;
}

#pragma mark - Public
- (void)startupEventsOnAppDidFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    //推送
    [[RemotePushManager sharedInstance] registerJPushWithOptions:launchOptions];
    
    //网络
    [[NetworkConfigManager sharedInstance] configSettingsWithPlatform:@""];
    
    //主题
//    [[SHAPPUIThemeManager sharedInstance] configSettings];
    
    //来电
    [[MobilePhoneCallManager sharedInstance] configSettings];
    
    //跳转
    [[SHRouterManager sharedManager] registerRouterTableDynamic];
    
    //根视图
    [[AppWindowRootViewManager sharedInstance] startAppLauncherLogic];
    
}

- (void)startupEventsOnDidAppearAppContentWithOptions:(NSDictionary *)launchOptions{
    
}

#pragma mark - Private

@end
