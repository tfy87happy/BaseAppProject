//
//  ZARequestUtilities.h
//  ZANetworking
//
//  Created by Jason Ruan on 2017/8/24.
//  Copyright © 2017年 ZhenAiWang. All rights reserved.
//
//  ZANetworking Version 1.1
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "ZAHttpFileFormData.h"

//[notification object]为NSError

#pragma mark 配置相关
//Host
#ifdef DEBUG
#define HOST    [NSString stringWithFormat:@"http://api.%@/",ZANetwokingDomain]
#else
#define HOST    [NSString stringWithFormat:@"https://api.%@/",ZANetwokingDomain]
#endif

#pragma mark 业务相关
///Domain
extern NSString *const ZANetwokingDomain;
///业务逻辑错误Domain
extern NSString *const ZANetwokingBusinessErrorDomain;
///在其他设备登录
extern NSString *const ZAOtherDeviceLoginNotificationName;
///成功登录Token已经过期
extern NSString *const ZAUserLoginSuccessedTokenOverdueNotificationName;
///成功登录Token已经过期Code
extern NSInteger ZATokenOverdueErrorCode;
///用户未登录
extern NSString *const ZAUserNotLoggedInNotificationName;
///用户未登录Code
extern NSInteger ZAUserNotLoggedInErrorCode;
/// sid Key
extern NSString *const ZATokenDefaultValue;

#pragma mark 解析相关
///解析错误Domain
extern NSString *const ZANetwokingAnalyzeErrorDomain;
///解析错误Code
extern NSInteger ZAErrorCodeAnalyze;

#pragma mark 网络相关
///网络错误Domain
extern NSString *const ZANetwokingURLErrorDomain;

#pragma mark 错误码相关

extern NSInteger const ZASystemErrorCode;
extern NSInteger const ZAParametersErrorCode;


/**
 获取原始JSON对象的回调
 
 @param JSON 原始JSON
 @param error 错误
 */
typedef void(^ZARequestRawCompletionBlock)(id JSON, NSError *error);

/**
 获取解析后的Data的回调
 
 @param data 对象，类型通常字典或数组
 @param error 错误
 */
typedef void(^ZARequestDataCompletionBlock)(id data, NSError *error);

/**
 获取下载对象的回调
 
 @param data 对象
 @param error 错误
 */
typedef void(^ZADownloadDataCompletionBlock)(NSData *data, NSError *error);

/**
 获取对象的回调
 
 @param filePath 对象本地URL地址
 @param error 错误
 */
typedef void(^ZALoadDataCompletionBlock)(NSURL *filePath, NSError *error);

/// 请求结果类型
typedef NS_ENUM(NSInteger,ZARequestSurveillanceLogicType) {
    ZARequestSurveillanceLogicType_Success = 1, ///< 请求成功且业务逻辑成功
    ZARequestSurveillanceLogicType_NetworkError = 2,///< 请求失败(包括网络错误和业务逻辑错误中的“-001”和“-002”)
    ZARequestSurveillanceLogicType_BusinessError = 3,///< 请求成功且业务逻辑失败
};

/** 请求工具类
 # 背景
 需要一个类封装ZAHttpUtilities、业务网络层逻辑、缓存的逻辑，暴露给业务层使用
 # 简介
 暴露给业务层使用的ZARequestUtilities封装了ZAHttpUtilities、业务网络层逻辑、缓存的逻辑。将请求的Json数据或文件路径或错误以回调的方式返回给业务层，并将特殊的情况(如在其他设备登陆，Token过期等)以通知的形式广播
 */
@interface ZARequestUtilities : NSObject

#pragma mark - 公有类方法
/// @name 公有类方法

/**
 初始化请求头回调
 
 @param headerInfoBlock 请求头回调
 */
+ (void)setupWithHeaderInfoBlock:(NSDictionary *(^)(NSURL *URL))headerInfoBlock;

/**
 初始化默认缓存路径(如果不设置，默认在Library/Cache/zhenai.com下)

 @param diskCacheURL 默认缓存路径
 */
+ (void)setupDefaultDiskCacheURL:(NSURL *)diskCacheURL;

/**
 设置Post/Get请求超时时间(如果不设置，默认在Debug下为60s,Release下为15s)

 @param timeoutInterval 请求超时时间
 */
+ (void)setupTimeoutInterval:(NSTimeInterval)timeoutInterval;
/**
 网络错误回调
 
 @param errorInfoBlock 网络错误回调
 */
+ (void)setupWithErrorInfoBlock:(void(^)(NSURL *URL, NSError *error, NSInteger httpStatusCode, ZARequestSurveillanceLogicType logicType, NSInteger timeCost))errorInfoBlock;
/**
 设置是否DEBUG
 
 @param debugEnable 是否DEBUG
 */
+ (void)setupDebugEnable:(BOOL)debugEnable;

/**
 发送请求，并获取原始的JSON对象
 
 @param URL 请求URL
 @param para 请求参数
 @param completionHandler 完成的回调
 */
+ (void)requestRawPostWithURL:(NSURL *)URL
               parameters:(NSDictionary *)para
        completionHandler:(ZARequestRawCompletionBlock)completionHandler;

/**
 发送POST请求，并获取解析后的Data对象
 
 @param URL 请求URL
 @param para 请求参数
 @param completionHandler 完成的回调
 */
+ (void)requestPostWithURL:(NSURL *)URL
                parameters:(NSDictionary *)para
         completionHandler:(ZARequestDataCompletionBlock)completionHandler;

/**
 发送GET请求
 
 @param URL 请求URL
 @param para 请求参数
 @param completionHandler 完成的回调
 */
+ (void)requestRawGetWithURL:(NSURL *)URL
                  parameters:(NSDictionary *)para
           completionHandler:(ZARequestRawCompletionBlock)completionHandler;

/**
 发送GET请求，并获取解析后的Data对象
 
 @param URL 请求URL
 @param para 请求参数
 @param completionHandler 完成的回调
 */
+ (void)requestGetWithURL:(NSURL *)URL
               parameters:(NSDictionary *)para
        completionHandler:(ZARequestDataCompletionBlock)completionHandler;

/**
 上传数据,发送POST请求,不含进度progress
 
 @param URL 请求URL
 @param para 上传的自定义参数
 @param fileFormDatas 上传的文件的信息，ZAHttpFileFormData
 @param progress   进度回调
 @param completionHandler 完成的回调
 @return 当前网络任务的Key
 */

+ (NSString *)uploadDataWithURL:(NSURL *)URL
                     parameters:(NSDictionary *)para
                  fileFormDatas:(NSArray <ZAHttpFileFormData *> *)fileFormDatas
                       progress:(void(^)(float progress))progress
              completionHandler:(ZARequestDataCompletionBlock)completionHandler;
/**
 下载数据,发送POST请求,不做缓存
 
 @param URL 请求URL
 @param para 请求参数
 @param progress 进度回调
 @param completionHandler 完成的回调
 @return 任务的唯一标识
 */
+ (NSString *)downloadDataWithURL:(NSURL *)URL
                       parameters:(NSDictionary *)para
                         progress:(void(^)(float progress))progress
                completionHandler:(ZADownloadDataCompletionBlock)completionHandler;
/**
 根据URL获取数据,如有缓存,优先取缓存,没有则下载
 
 @param URL 请求URL
 @param para 请求参数
 @param progress 进度回调
 @param completionHandler 完成的回调
 @return 任务的唯一标识
 */
+ (NSString *)loadDataWithURL:(NSURL *)URL
                   parameters:(NSDictionary *)para
                     progress:(void(^)(float progress))progress
            completionHandler:(ZALoadDataCompletionBlock)completionHandler;

/**
 根据URL获取数据,如有缓存,优先取缓存,没有则下载
 
 @param URL 请求URL
 @param para 请求参数
 @param progress 进度回调
 @param destination 文件缓存路径(为空则为默认路径)
 @param completionHandler 完成的回调
 @return 任务的唯一标识
 */
+ (NSString *)loadDataWithURL:(NSURL *)URL
                   parameters:(NSDictionary *)para
                     progress:(void(^)(float progress))progress
                  destination:(NSURL *)destination
            completionHandler:(ZALoadDataCompletionBlock)completionHandler;

/**
 根据URL获取数据,如有缓存,优先取缓存,没有则断点下载（需要服务器支持）
 
 @param URL 请求URL
 @param para 请求参数
 @param progress 进度回调
 @param completionHandler 完成的回调
 @return 任务的唯一标识
 */
+ (NSString *)loadResumeBrokenDataWithURL:(NSURL *)URL
                               parameters:(NSDictionary *)para
                                 progress:(void(^)(float progress))progress
                        completionHandler:(ZALoadDataCompletionBlock)completionHandler;

/**
 根据URL获取数据,如有缓存,优先取缓存,没有则断点下载（需要服务器支持）
 
 @param URL 请求URL
 @param para 请求参数
 @param progress 进度回调
 @param destination 文件缓存路径(为空则为默认路径)
 @param completionHandler 完成的回调
 @return 任务的唯一标识
 */
+ (NSString *)loadResumeBrokenDataWithURL:(NSURL *)URL
                               parameters:(NSDictionary *)para
                                 progress:(void(^)(float progress))progress
                              destination:(NSURL *)destination
                        completionHandler:(ZALoadDataCompletionBlock)completionHandler;

/**
 根据URL判断是否存在文件

 @param URL URL 请求URL
 @param para 请求参数
 @return 是否存在文件
 */
+ (BOOL)fileExistsAtURL:(NSURL *)URL parameters:(NSDictionary *)para;

/**
 同步获取默认路劲下的缓存大小

 @return 缓存大小
 */
+ (CGFloat)cachesSize;

/**
 异步获取默认路劲下的缓存大小

 @param completionHandler 回调
 */
+ (void)getCachesSizeWithCompletionHandler:(void(^)(CGFloat size))completionHandler;

/**
 清理默认路径下的缓存

 @param completionHandler 回调
 */
+ (void)clearCachesWithCompletionHandler:(void(^)())completionHandler;

/**
 取消特定网络任务
 
 @param taskKey 任务的唯一标识
 @return 是否成功取消
 */
+ (BOOL)cancelTaskWithTaskKey:(NSString *)taskKey;

/**
 cookies
 
 @param URL 通过URL获取Cookies
 @return cookies
 */
+ (NSArray<NSHTTPCookie *> *)getCookiesForURL:(NSURL *)URL;

/**
 删除所有Cookies
 */
+ (void)clearCookies;

@end

