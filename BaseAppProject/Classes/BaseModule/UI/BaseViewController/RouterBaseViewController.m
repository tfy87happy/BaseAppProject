//
//  RouterBaseViewController.m
//  BaseAppProject
//
//  Created by 汤飞扬 on 2021/3/10.
//

#import "RouterBaseViewController.h"
#import "MacroDefinesHeader.h"


@interface RouterBaseViewController ()

@end

@implementation RouterBaseViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

+ (NSString *)schemeForRouter {
    NSLog(@"%s", __func__);
    return kRouterDomain;
}

+ (NSString *)hostForRouter {
    NSLog(@"%s", __func__);
    return NSStringFromClass([self class]);
}

+ (SHRouterTargetConfig *)targetConfigForRouter {
    NSLog(@"%s", __func__);
    //基类默认
    SHRouterTargetConfig *config = [[SHRouterTargetConfig alloc]init];
    config.className = NSStringFromClass([self class]);
    config.showType = SHRouterShowType_Push;
    return config;
}

@end
