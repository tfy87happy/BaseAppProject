//
//  Presenter.h
//  BaseAppProject
//
//  Created by 汤飞扬 on 2021/3/10.
//

#import <Foundation/Foundation.h>

typedef void(^PresenterSuccessCallback)(id _Nullable result);
typedef void(^PresenterFailureCallback)(NSError * _Nullable error);

NS_ASSUME_NONNULL_BEGIN

@interface Presenter <E>: NSObject

/// MVP中负责更新的视图
@property (nonatomic, weak) E view;

/**
 初始化函数

 @param view 要绑定的视图
 */
- (instancetype) initWithView:(E)view;

/**
 * 绑定视图
 * @param view 要绑定的视图
 */
- (void) attachView:(E)view ;

/**
 解绑视图
 */
- (void)detachView;
@end

NS_ASSUME_NONNULL_END
