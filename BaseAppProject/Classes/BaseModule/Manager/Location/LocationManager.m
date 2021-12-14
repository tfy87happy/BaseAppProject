//
//  LocationManager.m
//  BaseAppProject
//
//  Created by 汤飞扬 on 2021/3/10.
//

#import "LocationManager.h"
#import <CoreLocation/CoreLocation.h>
#import "JZLocationConverter.h"

@interface LocationManager ()<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager* cllocation;

@property (nonatomic, copy) void(^locationBlock)(BOOL enable);

@property (nonatomic, assign,readwrite) double latitude;

@property (nonatomic, assign,readwrite) double longitude;

@end

@implementation LocationManager

+ (instancetype)sharedInstance {
    static LocationManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[LocationManager alloc]init];
    });
    return manager;
}

#pragma mark - Setter && Getter
- (CLLocationManager *)cllocation {
    if (!_cllocation) {
        _cllocation = [[CLLocationManager alloc] init];
        _cllocation.delegate = self;
    }
    return _cllocation;
}

#pragma mark - Public
- (BOOL)needUseLocationPermissions:(void(^)(BOOL enabel))locationBlock {
    self.locationBlock = locationBlock;
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        
        //用户拒绝使用位置服务
        dispatch_async(dispatch_get_main_queue(), ^{
            // UI更新代码
            [self showAlert];
        });
    }
    
    [self.cllocation requestWhenInUseAuthorization];
    return [self locationEnabel];
}

- (BOOL)locationEnabel {
    if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways)) {
        [self.cllocation startUpdatingLocation];
        //定位功能可用
        return YES;
    }
    return NO;
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        case kCLAuthorizationStatusAuthorizedAlways:{
            [manager startUpdatingLocation];
            if (self.locationBlock){
                self.locationBlock(YES);
            }
//            [[NSNotificationCenter defaultCenter] postNotificationName:kAppLocationChangeNotificationName object:nil userInfo:nil];
        }
            
            break;
        case kCLAuthorizationStatusDenied:// 用户拒绝使用定位，可在此引导用户开启
        case kCLAuthorizationStatusRestricted:// 权限受限，可引导用户开启
        case kCLAuthorizationStatusNotDetermined:{// 未选择，在代理方法里，一般不会有这个状态，如果有m，再次发起申请
            if (self.locationBlock) {
                self.locationBlock(NO);
            }
        }
            break;
        default:
            break;
    }
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    if (locations.count) {
        CLLocation *location = locations.lastObject;
        //地理反编码
        CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
        CLLocationCoordinate2D coordinate = [JZLocationConverter wgs84ToGcj02:location.coordinate];
        self.latitude = coordinate.latitude;
        self.longitude = coordinate.longitude;

        [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            if (placemarks.count > 0) {
                CLPlacemark *placeMark = placemarks[0];
                NSString *district = placeMark.subLocality ? : @"";
                NSString *city = placeMark.locality ? : @"";
                NSString *province = placeMark.administrativeArea ? : @"";
                if (!province.length) {
                    province = city;//省为空一般是直辖市
                }
                if (self.updateLocationCompletion) {
                    self.updateLocationCompletion(coordinate.latitude,coordinate.longitude,province,city,district);
                }
            }
        }];
        [self.cllocation stopUpdatingLocation];
    }
}

#pragma mark - Private
- (void)showAlert {
    
}

@end
