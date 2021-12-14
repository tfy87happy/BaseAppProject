//
//  RemotePushManager.h
//  BaseAppProject
//
//  Created by 汤飞扬 on 2021/3/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RemotePushManager : NSObject

+ (instancetype)sharedInstance;

- (void)registerJPushWithOptions:(NSDictionary *)launchOptions;

- (void)registerDeviceToken:(NSData *)deviceToken;

- (void)setAlias:(NSInteger)userSeq;

- (void)removeAlias:(NSInteger)userSeq;

@end

NS_ASSUME_NONNULL_END
