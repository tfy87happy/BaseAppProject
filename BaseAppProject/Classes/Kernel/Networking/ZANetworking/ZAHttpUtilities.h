//
//  ZAHttpClient.h
//  ZANetworking
//
//  Created by Jason Ruan on 2017/8/24.
//  Copyright © 2017年 ZhenAiWang. All rights reserved.
//
/**
 *  对网络请求进行封装,内部包含一个网络队列,所有的网络请求都是加到队列中,让队列自己去触发
 本类是一个单例,使用的时候,请 [ZAHttpClient sharedHttpUtilities]获取单例
 *
 */
#import <Foundation/Foundation.h>

#define ZAHttpDLog(fmt, ...) if(self.debugEnable) {\
NSLog((@"[%s]" "%s" "[%d]" fmt), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);\
}

@class ZAHttpFileFormData;

typedef void(^ZAHttpDownloadCompletionBlock)(NSURL *filePath, NSError *networkingError,NSInteger httpStatusCode);

/**
 请求的回调

 @param JSON JSON数据
 @param networkingError 网络错误
 @param httpStatusCode HTTP请求码
 */
typedef void(^ZAHttpCompletionBlock)(id JSON, NSError *networkingError,NSInteger httpStatusCode);

extern NSString *const ZANetworkingErrorLocalizedDescription;///网络异常Release下的提示语

/**
 # 背景
 网络请求需要底层封装一层解耦，如果未来不使用AFNetworking，可以在这层替换掉，高层不需要关心
 # 简介
 底层实现`请求`/`普通下载`/`断点下载`/`上传`的网络工具类，外部不需关心内部具体实现方式。
 
 目前实现方式是引用市面上最为成熟的轻量网络三方库[AFNetworking](https://github.com/AFNetworking/AFNetworking)，这里将不再细说。
 */
@interface ZAHttpUtilities : NSObject

#pragma mark - 公有属性
/// @name 公有属性

/// 请求头,如有需要外部调用
@property (nonatomic, copy) NSDictionary *(^headerInfoBlock)(NSURL *URL);
/// POST GET超时时间
@property (nonatomic, assign) NSTimeInterval timeoutInterval;
/// 是否debug
@property (nonatomic, assign) BOOL debugEnable;

#pragma mark - 公有类方法
/// @name 公有类方法

/// 底层HTTP请求单例
+ (ZAHttpUtilities *)sharedHttpUtilities;

#pragma mark - 公有实例方法
/// @name 公有实例方法

/**
 *  POST网络请求
 *
 *  @param URL            请求的URL
 *  @param para           请求的自定义参数
 *  @param completionHandler 完成的回调
 *
 */
- (void)requestPostWithURL:(NSURL *)URL
                parameters:(NSDictionary *)para
         completionHandler:(ZAHttpCompletionBlock)completionHandler;
/**
 *  GET网络请求
 *
 *  @param URL            请求的URL
 *  @param para           请求的自定义参数
 *  @param completionHandler 完成的回调
 *
 */
- (void)requestGetWithURL:(NSURL *)URL
               parameters:(NSDictionary *)para
        completionHandler:(ZAHttpCompletionBlock)completionHandler;

/**
 上传文件,含进度progress

 @param URL 上传的URL
 @param para 上传的自定义参数
 @param fileFormDatas 上传的文件的信息，含以下键 name file contentType fileName。其中name是服务器定义的,file是NSData
 @param progress 进度block
 @param completionHandler 完成的回调
 @return 当前网络任务的Key
 */
- (NSString *)uploadWithURL:(NSURL *)URL
                 parameters:(NSDictionary *)para
              fileFormDatas:(NSArray <ZAHttpFileFormData *> *)fileFormDatas
                   progress:(void(^)(float progress))progress
          completionHandler:(ZAHttpCompletionBlock)completionHandler;

/**
 下载文件

 @param URL 上传的URL
 @param para 上传的自定义参数
 @param progress 进度
 @param destination 包括文件名的文件路径
 @param completionHandler 完成的回调
 @return 任务的唯一标识
 */
- (NSString *)downloadWithURL:(NSURL *)URL
             parameters:(NSDictionary *)para
               progress:(void(^)(float progress))progress
            destination:(NSURL *)destination
      completionHandler:(ZAHttpDownloadCompletionBlock)completionHandler;

/**
 下载文件(支持断点下载,需要服务器配合)

 @param URL 上传的URL
 @param para 上传的自定义参数
 @param progress 进度
 @param destination 包括文件名的文件路径
 @param completionHandler 完成的回调
 @return 任务的唯一标识
 */
- (NSString *)resumeBrokenDownloadWithURL:(NSURL *)URL
                         parameters:(NSDictionary *)para
                           progress:(void(^)(float progress))progress
                        destination:(NSURL *)destination
                  completionHandler:(ZAHttpDownloadCompletionBlock)completionHandler;

/**
 取消特定网络任务

 @param taskKey 任务的唯一标识
 @return 是否成功取消
 */
- (BOOL)cancelTaskWithTaskKey:(NSString *)taskKey;

@end
