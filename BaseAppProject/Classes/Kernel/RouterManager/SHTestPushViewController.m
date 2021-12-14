//
//  SHTestPushViewController.m
//  SHRouterManager
//
//  Created by 汤浩博 on 2020/6/26.
//  Copyright © 2020 feiyang.tang. All rights reserved.
//

#import "SHTestPushViewController.h"
#import "SHRouterProtocol.h"

@interface SHTestPushViewController ()<SHRouterProtocol>

@end

@implementation SHTestPushViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"SHTestPushViewController";
}

/// 获取目标控制器所属模块的协议名称
+ (NSString *)schemeForRouter{
    return @"SHProject-Internal";
}

/// 获取目标控制器配置
+ (SHRouterTargetConfig *)targetConfigForRouter{
    SHRouterTargetConfig *config = [[SHRouterTargetConfig alloc]init];
    config.className = NSStringFromClass([self class]);
    config.showType = SHRouterShowType_Push;
    return config;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
