//
//  NetworkConfigManager.m
//  BaseAppProject
//
//  Created by 汤飞扬 on 2021/3/1.
//

#import "NetworkConfigManager.h"
#import "AFNetworking.h"
#import "ZARequestUtilities.h"

@interface NetworkConfigManager ()

@property (nonatomic, strong) AFNetworkReachabilityManager *manager;

@end

@implementation NetworkConfigManager

+ (instancetype)sharedInstance {
    static NetworkConfigManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[NetworkConfigManager alloc] init];
    });
    return instance;
}

#pragma mark - Public
- (void)configSettingsWithPlatform:(NSString *)platform{
    [ZARequestUtilities setupWithHeaderInfoBlock:^NSDictionary *(NSURL *URL) {
        NSDictionary *headerInfo = @{@"channelId":@"",
                                     @"platformKey":@"",
                                     @"subChannelId":@"",
                                     };
        return headerInfo;
    }];
    
    [ZARequestUtilities setupWithErrorInfoBlock:^(NSURL *URL, NSError *error, NSInteger httpStatusCode, ZARequestSurveillanceLogicType logicType, NSInteger timeCost) {
        if (logicType == ZARequestSurveillanceLogicType_Success) {

        } else if(logicType == ZARequestSurveillanceLogicType_NetworkError){//网络错误
            
        } else { //ZARequestSurveillanceLogicType_BusinessError 业务逻辑错误
            
        }
    }];
}

- (void)startObserving {
    NSString *domain = @"www.baidu.com";
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager managerForDomain:domain];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        [self networkChange:status];
    }];
    [manager startMonitoring];
    self.manager = manager;
}

- (void)stopObserving {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.manager stopMonitoring];
}

#pragma mark - Private
- (void)networkChange:(AFNetworkReachabilityStatus)status{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNetworkStateDidChangedNotification object:@(self.manager.reachable)];
}
@end
