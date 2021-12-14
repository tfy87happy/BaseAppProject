//
//  ZAHttpClient.m
//  ZANetworking
//
//  Created by Jason Ruan on 2017/8/24.
//  Copyright © 2017年 ZhenAiWang. All rights reserved.
//

#import "ZAHttpUtilities.h"
#import "AFNetworking.h"
#import "ZAHttpFileFormData.h"
#import <objc/runtime.h>
#import "ZAMD5Utils.h"

NSString *const ZANetworkingErrorLocalizedDescription = @"网络出问题了";
static NSString *const kURLEmptyErrorLocalizedDescription = @"URL为空";

/// 任务最大并发数
static NSInteger const kHttpUtilitiesMaxConcurrentOperationCount = 5;
/// debug 超时时间
static NSInteger const kHttpUtilitiesDebugTimeoutInterval = 60;
/// Release 超时时间
static NSInteger const kHttpUtilitiesReleaseTimeoutInterval = 15;
/// cookieKey
static NSString *const kHttpUtilitiesCookieKey = @"kHttpUtilitiesCookieKey";

@interface ZAHttpUtilities ()

@property (nonatomic, strong) NSCache *taskQueue;///< 任务队列
@property (nonatomic, strong) AFHTTPSessionManager *postAndGetSessionManager;///< post和get的manager
@property (nonatomic, strong) AFHTTPSessionManager *uploadAndDownloadSessionManager;///< 上传和下载的manager

@end

@implementation ZAHttpUtilities

+ (instancetype)sharedHttpUtilities {
    static ZAHttpUtilities *sharedInstance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance =  [[self alloc] init];
        
        {
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.requestSerializer.timeoutInterval = kHttpUtilitiesReleaseTimeoutInterval;
            manager.operationQueue.maxConcurrentOperationCount = kHttpUtilitiesMaxConcurrentOperationCount;
            sharedInstance.postAndGetSessionManager = manager;
        }

        {
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.operationQueue.maxConcurrentOperationCount = kHttpUtilitiesMaxConcurrentOperationCount;
            sharedInstance.uploadAndDownloadSessionManager = manager;
        }
        
    });
    return sharedInstance;
}

/**
 设置请求头

 @param manager 请求manager
 @param URL 请求URL
 */
- (void)__setupHeaderWithHTTPRequestOperationManager:(AFHTTPSessionManager *)manager URL:(NSURL *)URL{
    if (self.headerInfoBlock) {
        [self.headerInfoBlock(URL) enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [manager.requestSerializer setValue:obj forHTTPHeaderField:key];
        }];
    }
}

- (void)requestPostWithURL:(NSURL *)URL
                parameters:(NSDictionary *)para
         completionHandler:(ZAHttpCompletionBlock)completionHandler {
    
    if (!URL) {
        NSError *error = [NSError errorWithDomain:AFURLResponseSerializationErrorDomain code:NSURLErrorBadURL userInfo:@{NSLocalizedDescriptionKey:self.debugEnable?kURLEmptyErrorLocalizedDescription:ZANetworkingErrorLocalizedDescription}];
        ZAHttpDLog(@"Error:%@", error);
        if (completionHandler) {
            completionHandler(nil,error,0);
        }
        return;
    }
    //域名选择
    //    URL = [self URLWithOriginURL:URL params:para];
    
    AFHTTPSessionManager *manager = [ZAHttpUtilities sharedHttpUtilities].postAndGetSessionManager;
    
    [self __setupHeaderWithHTTPRequestOperationManager:manager URL:URL];
    [manager POST:[URL absoluteString] parameters:para headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ZAHttpDLog(@"URL:%@\nparameters:%@\nJSON:%@",URL,para,responseObject);
        NSHTTPURLResponse * responses = (NSHTTPURLResponse *)task.response;
        NSInteger httpStatusCode = responses.statusCode;
        if (completionHandler) {
            completionHandler(responseObject,nil,httpStatusCode);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse * responses = (NSHTTPURLResponse *)task.response;
        NSInteger httpStatusCode = responses.statusCode;
        ZAHttpDLog(@"URL:%@\nparameters:%@\nError:%@\nhttpStatusCode:%zd",URL,para,error,httpStatusCode);
        if (completionHandler) {
            completionHandler(nil,error,httpStatusCode);
        }
    }];
}


- (void)requestGetWithURL:(NSURL *)URL
               parameters:(NSDictionary *)para
        completionHandler:(ZAHttpCompletionBlock)completionHandler {
    
    if (!URL) {
        NSError *error = [NSError errorWithDomain:AFURLResponseSerializationErrorDomain code:NSURLErrorBadURL userInfo:@{NSLocalizedDescriptionKey:self.debugEnable?kURLEmptyErrorLocalizedDescription:ZANetworkingErrorLocalizedDescription}];
        ZAHttpDLog(@"Error:%@", error);
        if (completionHandler) {
            completionHandler(nil,error,0);
        }
        return;
    }
    //域名选择
    //    URL = [self URLWithOriginURL:URL params:para];
    
    AFHTTPSessionManager *manager = [ZAHttpUtilities sharedHttpUtilities].postAndGetSessionManager;
    
    [self __setupHeaderWithHTTPRequestOperationManager:manager URL:URL];
    
    [manager GET:[URL absoluteString] parameters:para headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ZAHttpDLog(@"URL:%@\nparameters:%@\nJSON:%@",URL,para,responseObject);
        NSHTTPURLResponse * responses = (NSHTTPURLResponse *)task.response;
        NSInteger httpStatusCode = responses.statusCode;
        if (completionHandler) {
            completionHandler(responseObject,nil,httpStatusCode);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ZAHttpDLog(@"URL:%@\nparameters:%@\nError:%@",URL,para,error);
        NSHTTPURLResponse * responses = (NSHTTPURLResponse *)task.response;
        NSInteger httpStatusCode = responses.statusCode;
        ZAHttpDLog(@"URL:%@\nparameters:%@\nError:%@",URL,para,error);
        if (completionHandler) {
            completionHandler(nil,error,httpStatusCode);
        }
    }];
    
}

- (NSString *)uploadWithURL:(NSURL *)URL
                 parameters:(NSDictionary *)para
              fileFormDatas:(NSArray <ZAHttpFileFormData *> *)fileFormDatas
                   progress:(void(^)(float progress))progress
          completionHandler:(ZAHttpCompletionBlock)completionHandler {
    
    if (!URL) {
        NSError *error = [NSError errorWithDomain:AFURLResponseSerializationErrorDomain code:NSURLErrorBadURL userInfo:@{NSLocalizedDescriptionKey:self.debugEnable?kURLEmptyErrorLocalizedDescription: ZANetworkingErrorLocalizedDescription}];
        ZAHttpDLog(@"Error:%@", error);
        if (completionHandler) {
            completionHandler(nil,error,0);
        }
        return nil;
    }
    
    [fileFormDatas enumerateObjectsUsingBlock:^(ZAHttpFileFormData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        unsigned int count = 0;
        objc_property_t *properties = class_copyPropertyList([obj class], &count);
        for (int i = 0; i < count; i++) {
            NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
            id value = [obj valueForKey:key];
            if (!value) {
                NSError *error = [NSError errorWithDomain:AFURLResponseSerializationErrorDomain code:NSURLErrorBadURL userInfo:@{NSLocalizedDescriptionKey:self.debugEnable?[NSString stringWithFormat:@"第%zd个文件:%@为空",idx,key]:ZANetworkingErrorLocalizedDescription}];
                ZAHttpDLog(@"Error:%@", error);
                if (completionHandler) {
                    completionHandler(nil,error,0);
                }
                free(properties);
                return;
            }
        }
        free(properties);
    }];
    
    AFHTTPSessionManager *manager = [ZAHttpUtilities sharedHttpUtilities].uploadAndDownloadSessionManager;

    [self __setupHeaderWithHTTPRequestOperationManager:manager URL:URL];
    
    NSString *taskKey = [self __MD5WithURL:URL parameters:para fileFormDatas:fileFormDatas];
    
    __weak typeof (self) weakSelf = self;
    NSURLSessionDataTask *task = [manager POST:[URL absoluteString] parameters:para headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [fileFormDatas enumerateObjectsUsingBlock:^(ZAHttpFileFormData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [formData appendPartWithFileData:obj.data name:obj.name fileName:obj.fileName mimeType:obj.mimeType];
        }];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (uploadProgress.totalUnitCount) {
                    progress((double)uploadProgress.completedUnitCount / (double)uploadProgress.totalUnitCount);
                }else {
                    progress(0);
                }
            });
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ZAHttpDLog(@"URL:%@\nparameters:%@\nJSON:%@",URL,para,responseObject);
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf __removeTaskForTaskKey:taskKey];
        NSHTTPURLResponse * responses = (NSHTTPURLResponse *)task.response;
        NSInteger httpStatusCode = responses.statusCode;
        if (completionHandler) {
            completionHandler(responseObject,nil,httpStatusCode);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ZAHttpDLog(@"URL:%@\nparameters:%@\nError:%@",URL,para,error);
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf __removeTaskForTaskKey:taskKey];
        NSHTTPURLResponse * responses = (NSHTTPURLResponse *)task.response;
        NSInteger httpStatusCode = responses.statusCode;
        ZAHttpDLog(@"URL:%@\nparameters:%@\nError:%@",URL,para,error);
        if (completionHandler) {
            completionHandler(nil,error,httpStatusCode);
        }
    }];
    [self __addTask:task taskKey:taskKey];
    return taskKey;
}

- (NSString *)downloadWithURL:(NSURL *)URL
                   parameters:(NSDictionary *)para
                     progress:(void(^)(float progress))progress
                  destination:(NSURL *)destination
            completionHandler:(ZAHttpDownloadCompletionBlock)completionHandler {
    if (!URL) {
        NSError *error = [NSError errorWithDomain:AFURLResponseSerializationErrorDomain code:NSURLErrorBadURL userInfo:@{NSLocalizedDescriptionKey:self.debugEnable?kURLEmptyErrorLocalizedDescription:ZANetworkingErrorLocalizedDescription}];
        ZAHttpDLog(@"Error:%@", error);
        if (completionHandler) {
            completionHandler(nil,error,0);
        }
        return nil;
    }
    
    AFHTTPSessionManager *manager = [ZAHttpUtilities sharedHttpUtilities].uploadAndDownloadSessionManager;
    
    [self __setupHeaderWithHTTPRequestOperationManager:manager URL:URL];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSString *taskKey = [self __MD5WithURL:URL parameters:para];
    __weak typeof (self) weakSelf = self;
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progress) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (downloadProgress.totalUnitCount) {
                    progress((double)downloadProgress.completedUnitCount / (double)downloadProgress.totalUnitCount);
                } else {
                    progress(0);
                }
            });
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return destination;
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf __removeTaskForTaskKey:taskKey];
        if (!error) {
            ZAHttpDLog(@"URL:%@\nparameters:%@\filePath:%@",URL,para,filePath);
            if ([filePath isKindOfClass:[NSNull class]]) {
                filePath = nil;
            }
            NSHTTPURLResponse * responses = (NSHTTPURLResponse *)response;
            NSInteger httpStatusCode = responses.statusCode;
            if (completionHandler) {
                completionHandler(filePath ,nil,httpStatusCode);
            }
        } else {
            ZAHttpDLog(@"URL:%@\nparameters:%@\nError:%@",URL,para,error);
            NSHTTPURLResponse * responses = (NSHTTPURLResponse *)response;
            NSInteger httpStatusCode = responses.statusCode;
            if (completionHandler) {
                completionHandler(nil,error,httpStatusCode);
            }
        }
    }];
    [self __addTask:task taskKey:taskKey];
    
    [task resume];
    return taskKey;
}

- (NSString *)resumeBrokenDownloadWithURL:(NSURL *)URL
                               parameters:(NSDictionary *)para
                                 progress:(void(^)(float progress))progress
                              destination:(NSURL *)destination
                        completionHandler:(ZAHttpDownloadCompletionBlock)completionHandler {
    if (!URL) {
        NSError *error = [NSError errorWithDomain:AFURLResponseSerializationErrorDomain code:NSURLErrorBadURL userInfo:@{NSLocalizedDescriptionKey:self.debugEnable?kURLEmptyErrorLocalizedDescription:ZANetworkingErrorLocalizedDescription}];
        ZAHttpDLog(@"Error:%@", error);
        if (completionHandler) {
            completionHandler(nil,error,0);
        }
        return nil;
    }
    //域名选择
    //    URL = [self URLWithOriginURL:URL params:para];
    
    //通过传入的文件路径创建流
    NSOutputStream *outputStream = [NSOutputStream outputStreamWithURL:destination append:YES];
    
    AFHTTPSessionManager *manager = self.uploadAndDownloadSessionManager;
    
    [self __setupHeaderWithHTTPRequestOperationManager:manager URL:URL];
    
    NSString *taskKey = [self __MD5WithURL:URL parameters:para];
    
    //通过URL实例化可变请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    __block long long fileLength = 0;
    //通过传入的文件路径找到文件，查看大小
    __block long long writtenLength = [[[NSFileManager defaultManager] attributesOfItemAtPath: [destination path] error:nil][NSFileSize] longLongValue];
    if (writtenLength) {
        //放入请求头的Range中，@"bytes=%lld-%lld"，前一个long表示从哪里开始下载，后一个表示下载到哪里，我们是需要下载完的，可以不写
        NSString *range = [NSString stringWithFormat:@"bytes=%lld-", writtenLength];
        [request setValue:range forHTTPHeaderField:@"Range"];
    }
    NSURLSessionDataTask *task = [manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:nil];
    [manager setDataTaskDidReceiveResponseBlock:^NSURLSessionResponseDisposition(NSURLSession * _Nonnull session, NSURLSessionDataTask * _Nonnull dataTask, NSURLResponse * _Nonnull response) {
        ZAHttpDLog(@"NSURLSessionResponseDisposition");
        
        // 获得下载文件的总长度：请求下载的文件长度 + 当前已经下载的文件长度
        fileLength = response.expectedContentLength + writtenLength;
        //打开流
        [outputStream open];
        
        // 允许处理服务器的响应，才会继续接收服务器返回的数据
        return NSURLSessionResponseAllow;
    }];
    //任务进度回调
    [manager setDataTaskDidReceiveDataBlock:^(NSURLSession * _Nonnull session, NSURLSessionDataTask * _Nonnull dataTask, NSData * _Nonnull data) {
        ZAHttpDLog(@"setDataTaskDidReceiveDataBlock");
        
        NSInteger result = [outputStream write:data.bytes maxLength:data.length];
        if (result == -1) {
            //错误
            ZAHttpDLog(@"%@",outputStream.streamError);
            [task cancel];
        } else {
            // 拼接文件总长度
            writtenLength += data.length;
            if (progress) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (fileLength > 0) {
                        progress((double)writtenLength / (double)fileLength);
                    } else {
                        progress(0);
                    }
                });
            }
        }
    }];
    __weak typeof (self) weakSelf = self;
    //任务完成回调
    [manager setTaskDidCompleteBlock:^(NSURLSession * _Nonnull session, NSURLSessionTask * _Nonnull task, NSError * _Nullable error) {
        [outputStream close];
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf __removeTaskForTaskKey:taskKey];
        if (completionHandler) {
            if (!error) {
                NSHTTPURLResponse * responses = (NSHTTPURLResponse *)task.response;
                NSInteger httpStatusCode = responses.statusCode;
                completionHandler(destination,nil,httpStatusCode);
            } else {
                ZAHttpDLog(@"URL:%@\nparameters:%@\nError:%@",URL,para,error);
                NSHTTPURLResponse * responses = (NSHTTPURLResponse *)task.response;
                NSInteger httpStatusCode = responses.statusCode;
                completionHandler(nil,error,httpStatusCode);
            }
        }
    }];
    [self __addTask:task taskKey:taskKey];
    [task resume];
    return taskKey;
}


/**
 取消一个任务
 
 @param taskKey 任务的唯一标识
 @return 是否取消成功
 */
- (BOOL)cancelTaskWithTaskKey:(NSString *)taskKey {
    NSURLSessionDataTask *task = [self.taskQueue objectForKey:taskKey];
    if (task) {
        [task cancel];
        [self __removeTaskForTaskKey:taskKey];
        return YES;
    } else {
        return NO;
    }
}

/**
 向队列加入一个任务
 
 @param task 任务
 @param taskKey 任务的唯一标识
 */
- (void)__addTask:(NSURLSessionTask *)task taskKey:(NSString *)taskKey {
    [self.taskQueue setObject:task forKey:taskKey];
}

/**
 删除队列的一个任务
 
 @param taskKey 任务的唯一标识
 */
- (void)__removeTaskForTaskKey:(NSString *)taskKey {
    [self.taskQueue removeObjectForKey:taskKey];
}

/**
 计算URL和参数的MD5值

 @param URL URL
 @param parameters 参数
 @return MD5值
 */
- (NSString *)__MD5WithURL:(NSURL *)URL parameters:(NSDictionary *)parameters {
    NSString *mixString = [NSString stringWithFormat:@"%@%@",[ZAMD5Utils MD5WithURL:URL],[ZAMD5Utils MD5WithDictionary:parameters]];
    return [ZAMD5Utils MD5WithString:mixString];
}

/**
 计算URL、参数、上传的文件的MD5值

 @param URL URL
 @param parameters 参数
 @param fileFormDatas 上传的文件
 @return MD5值
 */
- (NSString *)__MD5WithURL:(NSURL *)URL parameters:(NSDictionary *)parameters fileFormDatas:(NSArray <ZAHttpFileFormData *> *)fileFormDatas {
    NSMutableString *fileFormDatasMD5 = [NSMutableString string];
    [fileFormDatas enumerateObjectsUsingBlock:^(ZAHttpFileFormData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [fileFormDatasMD5 appendFormat:@"%@",[ZAMD5Utils MD5WithData:obj.data]];
    }];
    NSString *mixString = [NSString stringWithFormat:@"%@%@%@",[ZAMD5Utils MD5WithURL:URL],[ZAMD5Utils MD5WithDictionary:parameters],fileFormDatas];
    return [ZAMD5Utils MD5WithString:mixString];
}

#pragma mark Getter & Setter

/**
 懒加载任务队列
 */
- (NSCache *)taskQueue {
    if (!_taskQueue) {
        _taskQueue = [[NSCache alloc]init];
        _taskQueue.countLimit = kHttpUtilitiesMaxConcurrentOperationCount * 2;
        _taskQueue.totalCostLimit = 1024 * kHttpUtilitiesMaxConcurrentOperationCount * 2;
    }
    return _taskQueue;
}

/**
 设置POST、GET超时时间

 @param timeoutInterval POST、GET超时时间
 */
- (void)setTimeoutInterval:(NSTimeInterval)timeoutInterval {
    _timeoutInterval = timeoutInterval;
    [ZAHttpUtilities sharedHttpUtilities].postAndGetSessionManager.requestSerializer.timeoutInterval = timeoutInterval;
}

- (void)setDebugEnable:(BOOL)debugEnable {
    _debugEnable = debugEnable;
    if (debugEnable) {
        self.timeoutInterval = kHttpUtilitiesDebugTimeoutInterval;
    } else {
        self.timeoutInterval = kHttpUtilitiesReleaseTimeoutInterval;
    }
}

@end
