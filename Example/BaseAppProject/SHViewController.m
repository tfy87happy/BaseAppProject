//
//  SHViewController.m
//  BaseAppProject
//
//  Created by thb87happy on 12/08/2021.
//  Copyright (c) 2021 thb87happy. All rights reserved.
//

#import "SHViewController.h"
#import "SHRouterProtocol.h"
#import "SHRouterManager.h"


@interface SHViewController ()<SHRouterProtocol>

@end

@implementation SHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.title = @"VC";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"跳转" forState:UIControlStateNormal];
    btn.frame = CGRectMake(100, 200, 100, 40);
    [btn setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(clickBtnEvent) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clickBtnEvent{
    SHRouterURLRequest *URLRequest = [[SHRouterURLRequest alloc] initWithURL:[NSURL URLWithString:@"SHProject-Internal://SHTestPushViewController"]];
    [[SHRouterManager sharedManager] openURLWithRouterRequest:URLRequest callback:^(NSURL *URL, NSError *error) {
        
    }];
}

+ (NSString *)schemeForRouter {
    NSLog(@"%s", __func__);
    return @"SHProject-Internal";
}

+ (SHRouterTargetConfig *)targetConfigForRouter {
    NSLog(@"%s", __func__);
    //基类默认
    SHRouterTargetConfig *config = [[SHRouterTargetConfig alloc]init];
    config.className = NSStringFromClass([self class]);
    config.showType = SHRouterShowType_Push;
    return config;
}

- (void)refresh{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
