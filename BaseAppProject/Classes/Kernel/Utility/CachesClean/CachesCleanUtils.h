//
//  CachesCleanUtils.h
//  BaseAppProject
//
//  Created by 汤飞扬 on 2021/3/10.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CachesCleanUtils : NSObject

// 根据路径返回目录或文件的大小
+ (CGFloat)sizeWithFilePath:(NSString *)path;

// 得到指定目录下的所有文件
+ (NSArray *)getAllFileNames:(NSString *)dirPath;

// 删除指定目录或文件
+ (BOOL)clearCachesWithFilePath:(NSString *)path;

// 清空指定目录下文件
+ (void)clearCachesFromDirectoryPath:(NSString *)dirPath completionHandler:(void(^)(void))completionHandler;

@end

NS_ASSUME_NONNULL_END
