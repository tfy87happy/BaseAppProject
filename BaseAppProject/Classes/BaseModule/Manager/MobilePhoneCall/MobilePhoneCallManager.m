//
//  MobilePhoneCallManager.m
//  BaseAppProject
//
//  Created by 汤飞扬 on 2021/3/1.
//

#import "MobilePhoneCallManager.h"
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>

NSString *const MobilePhoneCallStateDialingNotificationName = @"MobilePhoneCallStateDialingNotificationName"; //发起主叫
NSString *const MobilePhoneCallStateConnectedNotificationName = @"MobilePhoneCallStateConnectedNotificationName"; //通话中
NSString *const MobilePhoneCallStateIncomingNotificationName = @"MobilePhoneCallStateIncomingNotificationName"; //被叫中
NSString *const MobilePhoneCallStateDisconnectedNotificationName = @"MobilePhoneCallStateDisconnectedNotificationName"; //已挂断

@interface MobilePhoneCallManager ()

@property (nonatomic, strong) CTCallCenter *callCenter;

@end

@implementation MobilePhoneCallManager

+ (instancetype)sharedInstance {
    static MobilePhoneCallManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MobilePhoneCallManager alloc] init];
    });
    return instance;
}

- (void)configSettings {
    CTCallCenter *callCenter = [[CTCallCenter alloc] init];
    callCenter.callEventHandler=^(CTCall* call){
        if ([call.callState isEqualToString:CTCallStateDialing]){
            [[NSNotificationCenter defaultCenter]postNotificationName:MobilePhoneCallStateDialingNotificationName object:nil];
        } else if ([call.callState isEqualToString:CTCallStateConnected]){
            [[NSNotificationCenter defaultCenter]postNotificationName:MobilePhoneCallStateConnectedNotificationName object:nil];
        } else if([call.callState isEqualToString:CTCallStateIncoming]) {
            [[NSNotificationCenter defaultCenter]postNotificationName:MobilePhoneCallStateIncomingNotificationName object:nil];
        } else if ([call.callState isEqualToString:CTCallStateDisconnected]){
            [[NSNotificationCenter defaultCenter]postNotificationName:MobilePhoneCallStateDisconnectedNotificationName object:nil];
        }
    };
    self.callCenter = callCenter;
}
@end
