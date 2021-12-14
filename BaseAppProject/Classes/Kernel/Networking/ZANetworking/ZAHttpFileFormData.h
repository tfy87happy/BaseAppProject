//
//  ZAHttpFileFormData.h
//  ZANetworking
//
//  Created by Jason Ruan on 2017/8/24.
//  Copyright © 2017年 ZhenAiWang. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 # 背景
 上传文件流文件需要提供：
 
 - data 流文件
 - name 服务器要求的key
 - fileName 文件名(服务器不一定会以此存储文件)
 - mimeType 文件类型([mimeType参考](https://www.sitepoint.com/web-foundations/mime-types-complete-list/))
 
 # 简介
 ZAHttpFileFormData就是为了简单封装这些属性
 */
@interface ZAHttpFileFormData : NSObject

/// 流文件
@property (nonatomic,strong,nonnull) NSData * data;

/// 服务器要求的key
@property (nonatomic,copy,nonnull) NSString *name;

/// 文件名
@property (nonatomic,copy,nonnull) NSString *fileName;

/// 文件类型
@property (nonatomic,copy,nonnull) NSString *mimeType;

@end
