//
//  CacheMetaDataModel.h
//  BaseAppProject
//
//  Created by 汤飞扬 on 2021/2/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CacheMetaDataModel : NSObject

@property (nonatomic, strong) NSDate *createDate;

@property (nonatomic, strong) NSDictionary *response;

@end

NS_ASSUME_NONNULL_END
