//
//  SHRouterTargetVCFactory.h
//  SHRouterManager
//
//  Created by 汤浩博 on 2020/6/26.
//  Copyright © 2020 feiyang.tang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SHRouterTargetConfig.h"


NS_ASSUME_NONNULL_BEGIN

@interface SHRouterTargetVCFactory : NSObject

+ (UIViewController *)createTargetVCWithTargetConfig:(SHRouterTargetConfig *)targetConfig;

@end

NS_ASSUME_NONNULL_END
