//
//  RemotePushBaseHandler.h
//  BaseAppProject
//
//  Created by 汤飞扬 on 2021/3/1.
//

#import <Foundation/Foundation.h>

@protocol RemotePushProtocol <NSObject>

- (void)registerJPushWithOptions:(NSDictionary *)launchOptions;

- (void)registerDeviceToken:(NSData *)deviceToken;

- (void)setAlias:(NSInteger)userSeq;

- (void)removeAlias:(NSInteger)userSeq;

@end

NS_ASSUME_NONNULL_BEGIN

@interface RemotePushBaseHandler : NSObject<RemotePushProtocol>

@end

NS_ASSUME_NONNULL_END
