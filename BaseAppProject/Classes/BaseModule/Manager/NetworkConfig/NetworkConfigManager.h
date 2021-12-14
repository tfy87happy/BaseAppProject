//
//  NetworkConfigManager.h
//  BaseAppProject
//
//  Created by 汤飞扬 on 2021/3/1.
//

#import <Foundation/Foundation.h>

static NSString * _Nullable const kNetworkStateDidChangedNotification = @"kNetworkStateDidChangedNotification";

NS_ASSUME_NONNULL_BEGIN

@interface NetworkConfigManager : NSObject

+ (instancetype)sharedInstance;

- (void)configSettingsWithPlatform:(NSString *)platform;

- (void)startObserving;

- (void)stopObserving;

@end

NS_ASSUME_NONNULL_END
