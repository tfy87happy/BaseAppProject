//
//  NetBaseCodec.h
//  BaseAppProject
//
//  Created by 汤飞扬 on 2021/2/26.
//

#import <Foundation/Foundation.h>
#import "ZARequestUtilities.h"


NS_ASSUME_NONNULL_BEGIN

typedef void(^SuccessCallback)(id result);
typedef void(^FailureCallback)(NSError *error);

@protocol NetCodecTemplateMethod <NSObject>

@required

- (NSString *)requestPath;

/// 传入参数
- (NSDictionary*_Nullable)encodeParams;

/// 解析参数
- (id _Nullable )decodeParams:(NSDictionary *_Nonnull)response;

@optional

- (NSString *)requestDomain;

//发送包是否加密
- (BOOL)security;

// 是否需要将接口数据缓存,默认不需要。如果设置为YES 则优先从缓存获取
- (BOOL)isNeedCacheResponse;

//缓存超时时间。默认是不缓存，设置为-1
- (NSInteger)cacheTimeInSeconds;

/// 请求超时时间 默认10S
- (NSTimeInterval)requestTimeOut;

/// 请求参数封装 ---- 兼容不了标准格式，可以子类封装数据
- (NSDictionary*_Nullable)requestParamDictionary;

@end

@interface NetBaseCodec : NSObject <NetCodecTemplateMethod>

/// 发送POST请求，并获取解析后的Data对象
/// @param completionHandler 完成的回调
- (void)requestPostWithCompletionHandler:(ZARequestDataCompletionBlock)completionHandler;

/// 发送GET请求，并获取解析后的Data对象
/// @param completionHandler 完成的回调
- (void)requestGetWithCompletionHandler:(ZARequestDataCompletionBlock)completionHandler;



@end

NS_ASSUME_NONNULL_END
