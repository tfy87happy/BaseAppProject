//
//  SHRouterTargerConfig.h
//  SHRouterManager
//
//  Created by 汤浩博 on 2020/6/26.
//  Copyright © 2020 feiyang.tang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SHRouterShowType) {
    SHRouterShowType_Push,
    SHRouterShowType_Present,
    SHRouterShowType_Custom
};

typedef NS_ENUM(NSInteger, SHRouterVCType) {
    SHRouterVCType_Class,
    SHRouterVCType_Xib,
    SHRouterVCType_Storyboard
};
NS_ASSUME_NONNULL_BEGIN

@interface SHRouterTargetConfig : NSObject

// 跳转类型
@property(nonatomic, assign) SHRouterShowType showType;

// 类创建类型
@property(nonatomic, assign) SHRouterVCType vcType;

// 目标类名称
@property(nonatomic, copy) NSString *className;

// xib或storyboard文件
@property(nonatomic, copy) NSString *fileName;

// xib或storyboard identifier
@property(nonatomic, copy) NSString *identifier;

// 目标控制器 xib或storyboard 的bundle
@property(nonatomic, copy) NSString *bundlePath;
@end

NS_ASSUME_NONNULL_END
