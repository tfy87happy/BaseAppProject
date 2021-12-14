//
//  AppStartUpManager.h
//  BaseAppProject
//
//  Created by 汤飞扬 on 2021/3/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AppStartUpManager : NSObject

+ (instancetype)sharedInstance;

/// 启动伴随 didFinishLaunchingWithOptions 启动的事件.
/// 启动类型为:环境配置 / 日志 / 统计 / 等需要第一时间启动的.
/// @param launchOptions 值
- (void)startupEventsOnAppDidFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

/// 启动在第一个界面显示完(用户已经进入主界面)以后可以加载的事件.
/// 启动类型为:
/// @param launchOptions 值
- (void)startupEventsOnDidAppearAppContentWithOptions:(NSDictionary *)launchOptions;

@end

NS_ASSUME_NONNULL_END
