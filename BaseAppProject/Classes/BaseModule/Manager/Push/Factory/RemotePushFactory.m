//
//  RemotePushFactory.m
//  BaseAppProject
//
//  Created by 汤飞扬 on 2021/3/1.
//

#import "RemotePushFactory.h"
#import "RemoteJPushHandler.h"


@implementation RemotePushFactory

+ (RemotePushBaseHandler *)creatRemotePushHandlerWithType:(RemotePushType)type{
    if (type == RemotePushType_JPush) {
        return [[RemoteJPushHandler alloc] init];
    }
    return  nil;
}

@end
