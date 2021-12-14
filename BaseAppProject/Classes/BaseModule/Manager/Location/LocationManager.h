//
//  LocationManager.h
//  BaseAppProject
//
//  Created by 汤飞扬 on 2021/3/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LocationManager : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, copy) void(^updateLocationCompletion)(double latitude,double longitude,NSString *provinceName, NSString *cityName, NSString *district);

@property (nonatomic, assign,readonly) double latitude;

@property (nonatomic, assign,readonly) double longitude;

- (BOOL)needUseLocationPermissions:(void(^)(BOOL enabel))locationBlock;

- (BOOL)locationEnabel;

@end

NS_ASSUME_NONNULL_END
