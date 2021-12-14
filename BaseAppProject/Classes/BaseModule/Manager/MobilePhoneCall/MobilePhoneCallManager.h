//
//  MobilePhoneCallManager.h
//  BaseAppProject
//
//  Created by 汤飞扬 on 2021/3/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - 来电通知
extern NSString *const MobilePhoneCallStateDialingNotificationName; //发起主叫
extern NSString *const MobilePhoneCallStateConnectedNotificationName; //通话中
extern NSString *const MobilePhoneCallStateIncomingNotificationName; //被叫中
extern NSString *const MobilePhoneCallStateDisconnectedNotificationName; //已挂断

@interface MobilePhoneCallManager : NSObject

+ (instancetype)sharedInstance;

- (void)configSettings;

@end

NS_ASSUME_NONNULL_END
