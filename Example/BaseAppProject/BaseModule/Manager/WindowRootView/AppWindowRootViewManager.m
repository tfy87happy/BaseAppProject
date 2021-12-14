//
//  AppWindowRootViewManager.m
//  BaseAppProject
//
//  Created by 汤飞扬 on 2021/3/1.
//

#import "AppWindowRootViewManager.h"
#import "SHAppDelegate.h"
#import "TopViewControllerUtils.h"
#import "NavigationController.h"
#import "LandingViewController.h"
#import "UserLoginManager.h"
#import "SHViewController.h"
#import "TabbarController.h"
#import "NotificationNameHeader.h"
#import "ZARequestUtilities.h"

@interface AppWindowRootViewManager ()


@end

@implementation AppWindowRootViewManager

+ (instancetype)sharedInstance {
    static AppWindowRootViewManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[AppWindowRootViewManager alloc] init];
    });
    return instance;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveRegisterNotification:) name:ZAUserRegisterSuccessedNotificationName object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveLoginSuccessNotification:) name:ZAUserLoginSuccessedNotificationName object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveUserLoginSuccessedTokenOverdueNotification:) name:ZAUserLoginSuccessedTokenOverdueNotificationName object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveUserUserNotLoggedNotification:) name:ZAUserNotLoggedInNotificationName object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveOtherDeviceLoginNotification:) name:ZAOtherDeviceLoginNotificationName object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoLoginView) name:ZAUserLogoutSuccessedNotificationName object:nil];
    }
    return self;
}
#pragma - mark Public
- (void)startAppLauncherLogic{
    [self startAppLauncherMainLogic];
}

#pragma mark - Notification
- (void)receiveRegisterNotification:(NSNotification *)notification{
    
}

- (void)receiveLoginSuccessNotification:(NSNotification *)notification{
    
}

- (void)receiveOtherDeviceLoginNotification:(NSNotification *)notification{
    
}

- (void)receiveUserLoginSuccessedTokenOverdueNotification:(NSNotification *)notification{
    
}

- (void)receiveUserUserNotLoggedNotification:(NSNotification *)notification{
    
}

#pragma - mark GoToView
- (void)startAppLauncherMainLogic{
    BOOL hasLoginSucessed = YES;
    if (hasLoginSucessed) {
        [self gotoHomeView];
    }else{
        [self gotoLoginView];
    }
}

- (void)setAppConfigurationThenGoHome{
    
}

- (void)gotoHomeView{
    TabbarController *mainViewController = [[TabbarController alloc] initWithContext:@""];
    [self setRootViewController:mainViewController];
}

/**
 进入登录页面
 */
- (BOOL)gotoLoginView {
    return [self gotoLandingViewWithViewAutoTransitionType:[self getLoginVerificationType]];
}

#pragma - mark Private
// 登陆后淡入淡出更换rootViewController
- (void)setRootViewController:(UIViewController *)rootViewController {
    typedef void (^Animation)(void);
    UIWindow *window = [[self appDelegate] window];
    
    UIViewController *nav;
    if ([rootViewController isKindOfClass:[UITabBarController class]] || [rootViewController isKindOfClass:[UINavigationController class]]) {
        nav = rootViewController;
    } else {
        nav = [[NavigationController alloc] initWithRootViewController:rootViewController];
    }
    nav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    Animation animation = ^{
        BOOL oldState = [UIView areAnimationsEnabled];
        [UIView setAnimationsEnabled:NO];
//        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:YES];
        window.rootViewController = nav;
        [UIView setAnimationsEnabled:oldState];
    };
    
    [UIView transitionWithView:window
                      duration:0.5f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:animation
                    completion:nil];
}

- (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController {
    return [TopViewControllerUtils topViewControllerWithRootViewController:rootViewController];
}

- (UIViewController *)rootViewController {
    return [[[self appDelegate] window] rootViewController];
}

- (SHAppDelegate *)appDelegate {
    return (SHAppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (BOOL)gotoLandingViewWithViewAutoTransitionType:(NSInteger)viewAutoTransitionType{
    LandingViewController *landingViewController = [[LandingViewController alloc] init];
    NavigationController *nav = [[NavigationController alloc] initWithRootViewController:landingViewController];
    [self setRootViewController:nav];
    return NO;
}

- (NSInteger)getLoginVerificationType{
    return 0;
}


@end
