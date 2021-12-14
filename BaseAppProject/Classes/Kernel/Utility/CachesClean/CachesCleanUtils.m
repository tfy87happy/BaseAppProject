//
//  CachesCleanUtils.m
//  BaseAppProject
//
//  Created by 汤飞扬 on 2021/3/10.
//

#import "CachesCleanUtils.h"

@implementation CachesCleanUtils

+ (CGFloat)sizeWithFilePath:(NSString *)path{
    // 1.获得文件夹管理者
    NSFileManager *manger = [NSFileManager defaultManager];
    
    // 2.检测路径的合理性
    BOOL dir = NO;
    BOOL exits = [manger fileExistsAtPath:path isDirectory:&dir];
    if (!exits) return 0;
    
    // 3.判断是否为文件夹
    if (dir) { // 文件夹, 遍历文件夹里面的所有文件
        // 这个方法能获得这个文件夹下面的所有子路径(直接\间接子路径)
        NSArray *subpaths = [manger subpathsAtPath:path];
        NSInteger totalSize = 0;
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

+ (NSArray *)getAllFileNames:(NSString *)dirPath{
    NSArray *files = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:dirPath error:nil];
    return files;
}

+ (BOOL)clearCachesWithFilePath:(NSString *)path{
    NSFileManager *mgr = [NSFileManager defaultManager];
    return [mgr removeItemAtPath:path error:nil];
}

+ (void)clearCachesFromDirectoryPath:(NSString *)dirPath completionHandler:(void(^)())completionHandler {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //获得全部文件数组
        NSArray *fileAry =  [self getAllFileNames:dirPath];
        //遍历数组
        for (NSString *fileName in fileAry) {
            BOOL flag = NO;
            NSString *filePath = [dirPath stringByAppendingPathComponent:fileName];
            flag = [self clearCachesWithFilePath:filePath];
            
            if (!flag) {
                NSLog(@"删除文件失败：文件名%@",fileName);
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completionHandler) {
                completionHandler();
            }
        });
    });
}
@end
