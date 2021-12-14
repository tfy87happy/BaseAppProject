//
//  CachesCleanManager.m
//  BaseAppProject
//
//  Created by 汤飞扬 on 2021/3/10.
//

#import "CachesCleanManager.h"

@implementation CachesCleanManager

+ (CGFloat)cachesSize {
    CGFloat cachesSize = 0;
//    cachesSize += [[SDWebImageManager sharedManager].imageCache getSize]/1024.0/1024;
    cachesSize += [CachesCleanUtils sizeWithFilePath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]];
    return cachesSize;
}

+ (void)cleanCachesWithCompletionHandler:(void(^)(void))completionHandler {
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    dispatch_group_enter(group);
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [[SDWebImageManager sharedManager].imageCache clearDiskOnCompletion:^{
//            dispatch_group_leave(group);
//        }];
    });
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //App沙盒移除操作
        dispatch_group_leave(group);
    });

    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if (completionHandler) {
            completionHandler();
        }
    });
}


@end
