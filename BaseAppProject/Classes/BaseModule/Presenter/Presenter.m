//
//  Presenter.m
//  BaseAppProject
//
//  Created by 汤飞扬 on 2021/3/10.
//

#import "Presenter.h"

@interface Presenter ()

@end

@implementation Presenter

/**
 初始化函数
 */
- (instancetype)initWithView:(id)view{

    if (self = [super init]) {
        self.view = view;
    }
    return self;
}
/**
 * 绑定视图
 * @param view 要绑定的视图
 */
- (void) attachView:(id)view {
    self.view = view;
}


/**
 解绑视图
 */
- (void)detachView{
    self.view = nil;
}

@end
