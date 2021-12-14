//
//  AppWindowRootViewManager.h
//  BaseAppProject
//
//  Created by 汤飞扬 on 2021/3/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AppWindowRootViewManager : NSObject

+ (instancetype)sharedInstance;
/**
 App启动逻辑
 */
- (void)startAppLauncherLogic;

@end

NS_ASSUME_NONNULL_END
