//
//  CachesCleanManager.h
//  BaseAppProject
//
//  Created by 汤飞扬 on 2021/3/10.
//

#import <Foundation/Foundation.h>
#import "CachesCleanUtils.h"


NS_ASSUME_NONNULL_BEGIN

@interface CachesCleanManager : NSObject

/**
 获得所有缓存的大小

 @return 缓存大小
 */
+ (CGFloat)cachesSize;

/**
 清除所有缓存

 @param completionHandler 回调
 */
+ (void)cleanCachesWithCompletionHandler:(void(^)(void))completionHandler;

@end

NS_ASSUME_NONNULL_END
