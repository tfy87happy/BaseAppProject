//
//  RemotePushManager.m
//  BaseAppProject
//
//  Created by 汤飞扬 on 2021/3/1.
//

#import "RemotePushManager.h"
#import "RemotePushBaseHandler.h"
#import "RemotePushFactory.h"


@interface RemotePushManager ()

@property (nonatomic, strong) RemotePushBaseHandler *handler;
@end

@implementation RemotePushManager

+ (instancetype)sharedInstance {
    static RemotePushManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[RemotePushManager alloc] init];
    });
    return instance;
}

#pragma mark - Public
- (void)registerJPushWithOptions:(NSDictionary *)launchOptions{
    [self.handler registerJPushWithOptions:launchOptions];
}

- (void)registerDeviceToken:(NSData *)deviceToken{
    [self.handler registerDeviceToken:deviceToken];
}

- (void)setAlias:(NSInteger)userSeq{
    [self.handler setAlias:userSeq];
}

- (void)removeAlias:(NSInteger)userSeq{
    [self.handler removeAlias:userSeq];
}


#pragma mark - Private

#pragma mark - Setter && Getter
- (RemotePushBaseHandler *)handler{
    if (!_handler) {
        _handler = [RemotePushFactory creatRemotePushHandlerWithType:RemotePushType_JPush];
    }
    return _handler;
}
@end
