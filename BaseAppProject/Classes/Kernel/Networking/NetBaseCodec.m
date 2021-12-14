//
//  NetBaseCodec.m
//  BaseAppProject
//
//  Created by 汤飞扬 on 2021/2/26.
//

#import "NetBaseCodec.h"
#import "CacheMetaDataModel.h"
#import "MemoryCacheManager.h"

@interface NetBaseCodec ()

@end

@implementation NetBaseCodec

#pragma mark - Public
- (void)requestPostWithCompletionHandler:(ZARequestDataCompletionBlock)completionHandler{
    [ZARequestUtilities setupTimeoutInterval:[self requestTimeOut]];
    [ZARequestUtilities requestPostWithURL:[self getRequestURL] parameters:[self requestParamDictionary] completionHandler:^(id data, NSError *error) {
        if (!error && data) {
            [self saveCacheDataWithData:data];
        }
    }];
}

- (void)requestGetWithCompletionHandler:(ZARequestDataCompletionBlock)completionHandler{
    [ZARequestUtilities setupTimeoutInterval:[self requestTimeOut]];
    [ZARequestUtilities requestGetWithURL:[self getRequestURL] parameters:[self requestParamDictionary] completionHandler:^(id data, NSError *error) {
        if (!error && data) {
            [self saveCacheDataWithData:data];
        }
    }];
}

#pragma mark - NetCodecTemplateMethod

- (nonnull NSString *)requestPath {
    return @"";
}

- (NSDictionary*_Nullable)encodeParams{
    return nil;
}

- (id)decodeParams:(NSDictionary *)response {
    if (response.count < 1) {
        return nil;
    }
    return response;
}

- (NSString *)requestDomain{
    return HOST;
}

- (BOOL)security{
    return YES;
}

- (NSDictionary*_Nullable)requestParamDictionary{
    if ([self security]) {
        return  @{};
    }
    return  [self encodeParams];
}

// 是否需要将接口数据缓存,默认不需要
- (BOOL)isNeedCacheResponse{
    return NO;
}

- (NSInteger)cacheTimeInSeconds{
    return -1;
}

- (NSTimeInterval)requestTimeOut{
    return 10;
}

#pragma mark - Private
- (NSURL *)getRequestURL{
    NSString *string = [NSString stringWithFormat:@"%@/%@",[self requestDomain],[self requestPath]];
    return [NSURL URLWithString:string];
}

- (NSDictionary *)hasCacheData{
    //取缓存
    if ([self isNeedCacheResponse]) {
        if ([[MemoryCacheManager shareCache] containsObjectForKey:NSStringFromClass([self class])]) {
            CacheMetaDataModel *cacheMetaDataModel =  [[MemoryCacheManager shareCache] objectForKey:NSStringFromClass([self class])];
            
            NSDate *createDate = cacheMetaDataModel.createDate;
            NSTimeInterval duration = -[createDate timeIntervalSinceNow];
            if ([self cacheTimeInSeconds] > 0 || duration < [self cacheTimeInSeconds]) {
                return [self decodeParams:cacheMetaDataModel.response];
            }
        }
    }
    return nil;
}

- (void)saveCacheDataWithData:(id )data{
    if ([data isKindOfClass:[NSDictionary class]]){
        NSDictionary *responseDic = (NSDictionary *)data;
        CacheMetaDataModel *cacheMetaDataModel = [[CacheMetaDataModel alloc] init];
        cacheMetaDataModel.createDate = [NSDate date];
        cacheMetaDataModel.response = responseDic;
        [[MemoryCacheManager shareCache] setObject:cacheMetaDataModel forKey:NSStringFromClass([self class])];
    }
}
@end
