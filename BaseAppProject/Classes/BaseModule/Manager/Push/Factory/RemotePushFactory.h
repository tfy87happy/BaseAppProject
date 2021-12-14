//
//  RemotePushFactory.h
//  BaseAppProject
//
//  Created by 汤飞扬 on 2021/3/1.
//

#import <Foundation/Foundation.h>
#import "RemotePushBaseHandler.h"

typedef NS_ENUM(NSInteger, RemotePushType) {
    RemotePushType_JPush,
    RemotePushType_GeTui,
};

NS_ASSUME_NONNULL_BEGIN

@interface RemotePushFactory : NSObject

+ (RemotePushBaseHandler *)creatRemotePushHandlerWithType:(RemotePushType)type;

@end

NS_ASSUME_NONNULL_END
