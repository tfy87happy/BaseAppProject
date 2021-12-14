//
//  ZAMD5Utils.h
//  ZANetworking
//
//  Created by Jason Ruan on 2017/8/24.
//  Copyright © 2017年 ZhenAiWang. All rights reserved.
//

#import <Foundation/Foundation.h>

/// MD5工具类
@interface ZAMD5Utils : NSObject

/**
 计算字符串MD5值

 @param string 字符串
 @return MD5
 */
+ (NSString *)MD5WithString:(NSString *)string;

/**
 计算流数据MD5值

 @param data 流数据
 @return MD5值
 */
+ (NSString *)MD5WithData:(NSData *)data;

/**
 计算字典MD5值

 @param dictionary 字典
 @return MD5值
 */
+ (NSString *)MD5WithDictionary:(NSDictionary *)dictionary;

/**
 计算URL MD5值

 @param URL URL
 @return MD5值
 */
+ (NSString *)MD5WithURL:(NSURL *)URL;

@end
