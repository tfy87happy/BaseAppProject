//
//  ZARequestUtilities.m
//  ZANetworking
//
//  Created by Jason Ruan on 2017/8/24.
//  Copyright © 2017年 ZhenAiWang. All rights reserved.
//

#import "ZARequestUtilities.h"
#import "ZAHttpUtilities.h"
#import "ZAMD5Utils.h"

NSString *const ZANetwokingDomain = @"zhenai.com";
NSString *const ZANetwokingBusinessErrorDomain = @"ZANetwokingBusinessErrorDomain";
NSString *const ZAOtherDeviceLoginNotificationName = @"ZAOtherDeviceLoginNotificationName";
NSString *const ZAUserLoginSuccessedTokenOverdueNotificationName = @"ZAUserLoginSuccessedTokenOverdueNotificationName";
NSString *const ZANetwokingAnalyzeErrorDomain = @"ZANetwokingAnalyzeErrorDomain";
NSInteger ZAErrorCodeAnalyze = -100;
NSString *const ZANetwokingURLErrorDomain = @"ZANetwokingURLErrorDomain";
static NSInteger ZAErrorCodeOtherDeviceLogin = -15;
NSInteger ZATokenOverdueErrorCode = -4;
NSString *const ZAUserNotLoggedInNotificationName = @"ZAUserNotLoggedInNotificationName";
NSInteger ZAUserNotLoggedInErrorCode = -3;
NSInteger const ZASystemErrorCode = -1;
NSInteger const ZAParametersErrorCode = -2;
NSInteger ZARequestIllegalErrorCode = -18;
NSString *const ZATokenDefaultValue = @"^CE%JUm#r3w&)";

static NSString *const kRequestUtilitiesAnalyzeJsonErrorLocalizedDescription = @"数据解析错误";

@interface ZARequestUtilities ()

@property (nonatomic, copy) void(^errorInfoBlock)(NSURL *URL, NSError *error, NSInteger httpStatusCode, ZARequestSurveillanceLogicType logicType, NSInteger timeCost);///< 网络错误回调
@property (nonatomic, strong) NSURL *diskCacheURL;///< 缓存路径

@end

@implementation ZARequestUtilities

#pragma mark - 私有类方法
/// @name 私有类方法

/// 底层网络请求单例
+ (ZARequestUtilities *)sharedRequestUtilities {
    static ZARequestUtilities *sharedInstance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance =  [[self alloc] init];
        sharedInstance.diskCacheURL = [[[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil]URLByAppendingPathComponent:ZANetwokingDomain];
        if (![[NSFileManager defaultManager] fileExistsAtPath:[sharedInstance.diskCacheURL path]]) {
            [[NSFileManager defaultManager] createDirectoryAtURL:sharedInstance.diskCacheURL withIntermediateDirectories:YES attributes:nil error:NULL];
        }
    });
    return sharedInstance;
}

/**
 解析Json并做网络业务逻辑
 
 @param JSON JSON数据
 @param networkingError 网络请求错误
 @param URL URL
 @param httpStatusCode HTTP状态码
 @param completionHandler 回调
 */
+ (void)analyzeJsonAndReportWithJSON:(id)JSON networkingError:(NSError *)networkingError URL:(NSURL *)URL httpStatusCode:(NSInteger)httpStatusCode timeCost:(NSInteger)timeCost completionHandler:(ZARequestDataCompletionBlock)completionHandler {
    
    if (!networkingError) {
        NSError *error = nil;
        id data = nil;
        
        @try {
            BOOL isError = [[JSON objectForKey:@"isError"] boolValue];
            //判断是否有业务逻辑错误
            if (isError) {
                //获取业务逻辑错误编号
                NSInteger errorCode = [[JSON objectForKey:@"errorCode"] integerValue];
                //获取业务逻辑错误信息
                NSString *errorMessage = [JSON objectForKey:@"errorMessage"];
                if (errorCode == ZAErrorCodeOtherDeviceLogin) {
                    //其他设备登陆
                    error = [NSError errorWithDomain:ZANetwokingBusinessErrorDomain code:errorCode userInfo:@{NSLocalizedFailureReasonErrorKey:errorMessage,NSLocalizedDescriptionKey:@""}];
                    [[NSNotificationCenter defaultCenter] postNotificationName:ZAOtherDeviceLoginNotificationName object:error];
                } else if (errorCode == ZATokenOverdueErrorCode) {
                    //Token过期
                    error = [NSError errorWithDomain:ZANetwokingBusinessErrorDomain code:errorCode userInfo:@{NSLocalizedFailureReasonErrorKey:errorMessage,NSLocalizedDescriptionKey:@""}];
                    [[NSNotificationCenter defaultCenter] postNotificationName:ZAUserLoginSuccessedTokenOverdueNotificationName object:error];
                } else if (errorCode == ZAUserNotLoggedInErrorCode) {
                    //用户未登录
                    error = [NSError errorWithDomain:ZANetwokingBusinessErrorDomain code:errorCode userInfo:@{NSLocalizedFailureReasonErrorKey:errorMessage,NSLocalizedDescriptionKey:@""}];
                    [[NSNotificationCenter defaultCenter] postNotificationName:ZAUserNotLoggedInNotificationName object:error];
                } else if (errorCode == ZARequestIllegalErrorCode) {
                    //无效请求
                    [self clearCookies];
                    error = [NSError errorWithDomain:ZANetwokingBusinessErrorDomain code:errorCode userInfo:@{NSLocalizedDescriptionKey:errorMessage}];
                } else {
                    //其他错误
                    error = [NSError errorWithDomain:ZANetwokingBusinessErrorDomain code:errorCode userInfo:@{NSLocalizedDescriptionKey:errorMessage}];
                }
                
                if (errorCode == ZASystemErrorCode || errorCode == ZAParametersErrorCode) {
                    
                    if ([ZARequestUtilities sharedRequestUtilities].errorInfoBlock) {
                        [ZARequestUtilities sharedRequestUtilities].errorInfoBlock(URL, error, httpStatusCode, ZARequestSurveillanceLogicType_NetworkError, timeCost);
                    }
                    
                } else {
                    
                    if ([ZARequestUtilities sharedRequestUtilities].errorInfoBlock) {
                        [ZARequestUtilities sharedRequestUtilities].errorInfoBlock(URL, error, httpStatusCode, ZARequestSurveillanceLogicType_BusinessError, timeCost);
                    }
                    
                }
                
                
            } else {
                
                data = [JSON objectForKey:@"data"];
                if ([data isKindOfClass:[NSNull class]]) {
                    data = nil;
                }
                
                if ([ZARequestUtilities sharedRequestUtilities].errorInfoBlock) {
                    [ZARequestUtilities sharedRequestUtilities].errorInfoBlock(URL, nil, httpStatusCode, ZARequestSurveillanceLogicType_Success, timeCost);
                }
                
            }
        }
        @catch (NSException *exception) {
            //数据解析错误，debug时返回解析错误给开发人员，非debug时返回"网络出问题了"给用户
            error = [NSError errorWithDomain:ZANetwokingAnalyzeErrorDomain code:ZAErrorCodeAnalyze userInfo:@{NSLocalizedDescriptionKey:self.debugEnable?kRequestUtilitiesAnalyzeJsonErrorLocalizedDescription:ZANetworkingErrorLocalizedDescription}];
            if ([ZARequestUtilities sharedRequestUtilities].errorInfoBlock) {
                
                error = [NSError errorWithDomain:ZANetwokingAnalyzeErrorDomain code:ZAErrorCodeAnalyze userInfo:@{NSLocalizedDescriptionKey:kRequestUtilitiesAnalyzeJsonErrorLocalizedDescription}];
                
                [ZARequestUtilities sharedRequestUtilities].errorInfoBlock(URL, error, httpStatusCode, ZARequestSurveillanceLogicType_BusinessError, timeCost);
            }
            
        }
        @finally {
            if (completionHandler) {
                if (error) {
                    completionHandler(nil,error);
                } else {
                    completionHandler(data,nil);
                }
            }
        }
        
    } else {
        //网络错误，debug时返回ZAHttpUtilities返回的错误给开发人员，非debug时返回"网络出问题了"给用户
        NSError *error = [NSError errorWithDomain:ZANetwokingURLErrorDomain code:networkingError.code userInfo:@{NSLocalizedDescriptionKey:self.debugEnable?networkingError.localizedDescription:ZANetworkingErrorLocalizedDescription}];
        if ([ZARequestUtilities sharedRequestUtilities].errorInfoBlock) {
            [ZARequestUtilities sharedRequestUtilities].errorInfoBlock(URL, error, httpStatusCode, ZARequestSurveillanceLogicType_NetworkError, timeCost);
        }
        
        if (completionHandler) {
            completionHandler(nil,error);
        }
    }
}

+ (void)setupWithHeaderInfoBlock:(NSDictionary *(^)(NSURL *URL))headerInfoBlock {
    [ZAHttpUtilities sharedHttpUtilities].headerInfoBlock = headerInfoBlock;
}

+ (void)setupTimeoutInterval:(NSTimeInterval)timeoutInterval {
    [ZAHttpUtilities sharedHttpUtilities].timeoutInterval = timeoutInterval;
}

+ (void)setupWithErrorInfoBlock:(void(^)(NSURL *URL, NSError *error, NSInteger httpStatusCode, ZARequestSurveillanceLogicType logicType, NSInteger timeCost))errorInfoBlock {
    [ZARequestUtilities sharedRequestUtilities].errorInfoBlock = errorInfoBlock;
}

+ (void)setupDebugEnable:(BOOL)debugEnable {
    [ZAHttpUtilities sharedHttpUtilities].debugEnable = debugEnable;
}

+ (void)setupDefaultDiskCacheURL:(NSURL *)diskCacheURL {
    [ZARequestUtilities sharedRequestUtilities].diskCacheURL = diskCacheURL;
    if (![[NSFileManager defaultManager] fileExistsAtPath:[[self sharedRequestUtilities].diskCacheURL path]]) {
        [[NSFileManager defaultManager] createDirectoryAtURL:[self sharedRequestUtilities].diskCacheURL withIntermediateDirectories:YES attributes:nil error:NULL];
    }
}

+ (void)requestRawPostWithURL:(NSURL *)URL
                   parameters:(NSDictionary *)para
            completionHandler:(ZARequestRawCompletionBlock)completionHandler {
    [[ZAHttpUtilities sharedHttpUtilities] requestPostWithURL:URL parameters:para completionHandler:^(id JSON, NSError *networkingError, NSInteger httpStatusCode) {
        if (completionHandler) {
            completionHandler(JSON,networkingError);
        }
    }];
}


+ (void)requestPostWithURL:(NSURL *)URL
                parameters:(NSDictionary *)para
         completionHandler:(ZARequestDataCompletionBlock)completionHandler {
    
    CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
    [[ZAHttpUtilities sharedHttpUtilities] requestPostWithURL:URL parameters:para completionHandler:^(id JSON, NSError *networkingError, NSInteger httpStatusCode) {
        NSInteger timeCost = (CFAbsoluteTimeGetCurrent() - start) * 1000;
        [self analyzeJsonAndReportWithJSON:JSON networkingError:networkingError URL:URL httpStatusCode:httpStatusCode timeCost:timeCost completionHandler:completionHandler];
    }];
    
}

+ (void)requestRawGetWithURL:(NSURL *)URL
                  parameters:(NSDictionary *)para
           completionHandler:(ZARequestRawCompletionBlock)completionHandler{
    
    [[ZAHttpUtilities sharedHttpUtilities] requestGetWithURL:URL parameters:para completionHandler:^(id JSON, NSError *networkingError, NSInteger httpStatusCode) {
        if (completionHandler) {
            completionHandler(JSON,networkingError);
        }
    }];
    
}

+ (void)requestGetWithURL:(NSURL *)URL
               parameters:(NSDictionary *)para
        completionHandler:(ZARequestDataCompletionBlock)completionHandler{
    CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
    [[ZAHttpUtilities sharedHttpUtilities] requestGetWithURL:URL parameters:para completionHandler:^(id JSON, NSError *networkingError, NSInteger httpStatusCode) {
        NSInteger timeCost = (CFAbsoluteTimeGetCurrent() - start) * 1000;
        [self analyzeJsonAndReportWithJSON:JSON networkingError:networkingError URL:URL httpStatusCode:httpStatusCode timeCost:timeCost completionHandler:completionHandler];
    }];
    
}


+ (NSString *)uploadDataWithURL:(NSURL *)URL
                     parameters:(NSDictionary *)para
                  fileFormDatas:(NSArray <ZAHttpFileFormData *> *)fileFormDatas
                       progress:(void(^)(float progress))progress
              completionHandler:(ZARequestDataCompletionBlock)completionHandler {
    CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
    return [[ZAHttpUtilities sharedHttpUtilities] uploadWithURL:URL parameters:para fileFormDatas:fileFormDatas progress:progress completionHandler:^(id JSON, NSError *networkingError, NSInteger httpStatusCode) {
        NSInteger timeCost = CFAbsoluteTimeGetCurrent() - start;
        [self analyzeJsonAndReportWithJSON:JSON networkingError:networkingError URL:URL httpStatusCode:httpStatusCode timeCost:timeCost completionHandler:completionHandler];
    }];
}

+ (NSString *)downloadDataWithURL:(NSURL *)URL
                       parameters:(NSDictionary *)para
                         progress:(void(^)(float progress))progress
                completionHandler:(ZADownloadDataCompletionBlock)completionHandler {
    //文件名
    NSString *filename = [[self __MD5WithURL:URL parameters:para] stringByAppendingString:[NSString stringWithFormat:@".%@",[[URL path] pathExtension]]];
    // 沙盒文件路径
    NSURL *tmpDirectoryURL = [NSURL fileURLWithPath:NSTemporaryDirectory() isDirectory:YES];
    NSURL *destinationPathURL = [tmpDirectoryURL URLByAppendingPathComponent:filename];
    return [[ZAHttpUtilities sharedHttpUtilities] downloadWithURL:URL parameters:para progress:progress destination:destinationPathURL completionHandler:^(NSURL *filePath, NSError *networkingError, NSInteger httpStatusCode) {
        if (!networkingError) {
            NSData *data = [NSData dataWithContentsOfURL:filePath];
            [[NSFileManager defaultManager] removeItemAtURL:filePath error:nil];
            if (completionHandler) {
                completionHandler(data,nil);
            }
        } else {
            NSError *requestError = [NSError errorWithDomain:ZANetwokingURLErrorDomain code:networkingError.code userInfo:@{NSLocalizedDescriptionKey:self.debugEnable?networkingError.localizedDescription:ZANetworkingErrorLocalizedDescription}];
            if (completionHandler) {
                completionHandler(nil,requestError);
            }
        }
    }];
}

+ (NSString *)loadDataWithURL:(NSURL *)URL
                   parameters:(NSDictionary *)para
                     progress:(void(^)(float progress))progress
            completionHandler:(ZALoadDataCompletionBlock)completionHandler {
    return [self loadDataWithURL:URL parameters:para progress:progress destination:[self sharedRequestUtilities].diskCacheURL completionHandler:completionHandler];
}

+ (NSString *)loadDataWithURL:(NSURL *)URL
                   parameters:(NSDictionary *)para
                     progress:(void(^)(float progress))progress
                  destination:(NSURL *)destination
            completionHandler:(ZALoadDataCompletionBlock)completionHandler {
    //文件名
    NSString *filename = [[self __MD5WithURL:URL parameters:para] stringByAppendingString:[NSString stringWithFormat:@".%@",[[URL path] pathExtension]]];
    
    NSURL *destinationPathURL = [destination URLByAppendingPathComponent:filename];
    //本地已下载好
    if ([[NSFileManager defaultManager]fileExistsAtPath:[destinationPathURL path]]) {
        if (completionHandler) {
            completionHandler(destinationPathURL,nil);
        }
        return nil;
    } else {
        return [[ZAHttpUtilities sharedHttpUtilities] downloadWithURL:URL parameters:para progress:progress destination:destinationPathURL completionHandler:^(NSURL *filePath, NSError *networkingError, NSInteger httpStatusCode) {
            if (!networkingError) {
                if (completionHandler) {
                    completionHandler(filePath,nil);
                }
            } else {
                NSError *requestError = [NSError errorWithDomain:ZANetwokingURLErrorDomain code:networkingError.code userInfo:@{NSLocalizedDescriptionKey:self.debugEnable?networkingError.localizedDescription:ZANetworkingErrorLocalizedDescription}];
                if (completionHandler) {
                    completionHandler(nil,requestError);
                }
            }
        }];
    }
}

+ (NSString *)loadResumeBrokenDataWithURL:(NSURL *)URL
                               parameters:(NSDictionary *)para
                                 progress:(void(^)(float progress))progress
                        completionHandler:(ZALoadDataCompletionBlock)completionHandler {
    return [self loadResumeBrokenDataWithURL:URL parameters:para progress:progress destination:[self sharedRequestUtilities].diskCacheURL completionHandler:completionHandler];
}

+ (NSString *)loadResumeBrokenDataWithURL:(NSURL *)URL
                               parameters:(NSDictionary *)para
                                 progress:(void(^)(float progress))progress
                              destination:(NSURL *)destination
                        completionHandler:(ZALoadDataCompletionBlock)completionHandler {
    //文件名
    NSString *filename = [[self __MD5WithURL:URL parameters:para] stringByAppendingString:[NSString stringWithFormat:@".%@",[[URL path] pathExtension]]];
    // 沙盒文件路径
    NSURL *tmpDirectoryURL = [NSURL fileURLWithPath:NSTemporaryDirectory() isDirectory:YES];
    NSURL *tmpPathURL = [tmpDirectoryURL URLByAppendingPathComponent:filename];
    NSURL *destinationPathURL = [destination URLByAppendingPathComponent:filename];
    
    //本地已下载好
    if ([[NSFileManager defaultManager]fileExistsAtPath:[destinationPathURL path]]) {
        if (completionHandler) {
            completionHandler(destinationPathURL,nil);
        }
        return nil;
    } else {
        return [[ZAHttpUtilities sharedHttpUtilities] resumeBrokenDownloadWithURL:URL parameters:para progress:progress destination:tmpPathURL completionHandler:^(NSURL *filePath, NSError *networkingError, NSInteger httpStatusCode) {
            if (!networkingError) {
                NSError *requestError = nil;
                [[NSFileManager defaultManager] moveItemAtURL:filePath toURL:destinationPathURL error:&requestError];
                if (!requestError) {
                    if (completionHandler) {
                        completionHandler(destinationPathURL,nil);
                    }
                } else {
                    if (completionHandler) {
                        completionHandler(nil,requestError);
                    }
                }
            } else {
                NSError *requestError = [NSError errorWithDomain:ZANetwokingURLErrorDomain code:networkingError.code userInfo:@{NSLocalizedDescriptionKey:self.debugEnable?networkingError.localizedDescription:ZANetworkingErrorLocalizedDescription}];
                if (completionHandler) {
                    completionHandler(nil,requestError);
                }
            }
        }];
    }
}

/**
 计算URL和参数的MD5值
 
 @param URL URL
 @param parameters 参数
 @return MD5值
 */
+ (NSString *)__MD5WithURL:(NSURL *)URL parameters:(NSDictionary *)parameters {
    NSString *mixString = [NSString stringWithFormat:@"%@%@",[ZAMD5Utils MD5WithURL:URL],[ZAMD5Utils MD5WithDictionary:parameters]];
    return [ZAMD5Utils MD5WithString:mixString];
}

+ (BOOL)fileExistsAtURL:(NSURL *)URL parameters:(NSDictionary *)parameters {
    //文件名
    NSString *filename = [[self __MD5WithURL:URL parameters:parameters] stringByAppendingString:[NSString stringWithFormat:@".%@",[[URL path] pathExtension]]];
    //沙盒文件路径
    NSURL *destinationPathURL = [[self sharedRequestUtilities].diskCacheURL URLByAppendingPathComponent:filename];
    //本地已下载好
    return [[NSFileManager defaultManager]fileExistsAtPath:[destinationPathURL path]];
}

+ (void)clearCachesWithCompletionHandler:(void(^)())completionHandler {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //获得全部文件数组
        NSArray *fileAry =  [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:[[self sharedRequestUtilities].diskCacheURL path] error:nil];
        //遍历数组
        for (NSString *fileName in fileAry) {
            NSURL *filePath = [[self sharedRequestUtilities].diskCacheURL URLByAppendingPathComponent:fileName];
            BOOL flag = [[NSFileManager defaultManager] removeItemAtURL:filePath error:nil];
            
            if (!flag) {
                ZAHttpDLog(@"删除文件失败：文件名%@",fileName);
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completionHandler) {
                completionHandler();
            }
        });
    });
}

+ (CGFloat)cachesSize {
    // 1.获得文件夹管理者
    NSFileManager *manger = [NSFileManager defaultManager];
    NSString *path = [[self sharedRequestUtilities].diskCacheURL path];
    // 2.检测路径的合理性
    BOOL dir = NO;
    BOOL exits = [manger fileExistsAtPath:path isDirectory:&dir];
    if (!exits) return 0;
    
    // 3.判断是否为文件夹
    if (dir) { // 文件夹, 遍历文件夹里面的所有文件
        // 这个方法能获得这个文件夹下面的所有子路径(直接\间接子路径)
        NSArray *subpaths = [manger subpathsAtPath:path];
        int totalSize = 0;
        for (NSString *subpath in subpaths) {
            NSString *fullsubpath = [path stringByAppendingPathComponent:subpath];
            
            BOOL dir = NO;
            [manger fileExistsAtPath:fullsubpath isDirectory:&dir];
            if (!dir) { // 子路径是个文件
                NSDictionary *attrs = [manger attributesOfItemAtPath:fullsubpath error:nil];
                totalSize += [attrs[NSFileSize] intValue];
            }
        }
        return totalSize / (1024 * 1024.0);
    } else { // 文件
        NSDictionary *attrs = [manger attributesOfItemAtPath:path error:nil];
        return [attrs[NSFileSize] intValue] / (1024.0 * 1024.0);
    }
}

+ (void)getCachesSizeWithCompletionHandler:(void(^)(CGFloat size))completionHandler {
    if (!completionHandler) {
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 1.获得文件夹管理者
        NSFileManager *manger = [NSFileManager defaultManager];
        NSString *path = [[self sharedRequestUtilities].diskCacheURL path];
        // 2.检测路径的合理性
        BOOL dir = NO;
        BOOL exits = [manger fileExistsAtPath:path isDirectory:&dir];
        if (!exits) return;
        
        // 3.判断是否为文件夹
        if (dir) { // 文件夹, 遍历文件夹里面的所有文件
            // 这个方法能获得这个文件夹下面的所有子路径(直接\间接子路径)
            NSArray *subpaths = [manger subpathsAtPath:path];
            int totalSize = 0;
            for (NSString *subpath in subpaths) {
                NSString *fullsubpath = [path stringByAppendingPathComponent:subpath];
                
                BOOL dir = NO;
                [manger fileExistsAtPath:fullsubpath isDirectory:&dir];
                if (!dir) { // 子路径是个文件
                    NSDictionary *attrs = [manger attributesOfItemAtPath:fullsubpath error:nil];
                    totalSize += [attrs[NSFileSize] intValue];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandler(totalSize / (1024 * 1024.0));
            });
        } else { // 文件
            NSDictionary *attrs = [manger attributesOfItemAtPath:path error:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandler([attrs[NSFileSize] intValue] / (1024.0 * 1024.0));
            });
        }
    });
}

+ (BOOL)cancelTaskWithTaskKey:(NSString *)taskKey; {
    return [[ZAHttpUtilities sharedHttpUtilities] cancelTaskWithTaskKey:taskKey];
}

+ (NSArray<NSHTTPCookie *> *)getCookiesForURL:(NSURL *)URL {
    return [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:URL];
}

+ (void)clearCookies {
    NSArray<NSHTTPCookie *> *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    [cookies enumerateObjectsUsingBlock:^(NSHTTPCookie * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:obj];
    }];
}

+ (BOOL)debugEnable {
    return [ZAHttpUtilities sharedHttpUtilities].debugEnable;
}

@end
