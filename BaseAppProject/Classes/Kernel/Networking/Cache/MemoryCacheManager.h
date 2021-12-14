//
//  MemoryCacheManager.h
//  BaseAppProject
//
//  Created by 汤飞扬 on 2021/2/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MemoryCacheManager : NSObject

+ (instancetype)shareCache;

- (BOOL)containsObjectForKey:(id)key;

- (id)objectForKey:(id)key;

- (void)setObject:(id)object forKey:(id)key;

- (void)removeObjectForKey:(id)key;

- (void)removeAllObjects;

@end

NS_ASSUME_NONNULL_END
