//
//  UIView+ZAProgressHUD.h
//  zhenaiwang
//
//  Created by Jason Ruan on 2017/6/9.
//  Copyright © 2017年 ZhenAiWang. All rights reserved.
//

#import <UIKit/UIKit.h>

//MBProgressHUDMode的映射，为了不将MBProgressHUD暴露到外面
typedef NS_ENUM(NSInteger,ZAProgressHUDMode) {
    /// UIActivityIndicatorView.
    ZAProgressHUDModeIndeterminate,
    /// A round, pie-chart like, progress view.
    ZAProgressHUDModeDeterminate,
    /// Horizontal progress bar.
    ZAProgressHUDModeDeterminateHorizontalBar,
    /// Ring-shaped progress view.
    ZAProgressHUDModeAnnularDeterminate,
    /// Shows a custom view.
    ZAProgressHUDModeCustomView,
    /// Shows only labels.
    ZAProgressHUDModeText
};

@interface UIView (ZAProgressHUD)

@property (nonatomic, assign) CGFloat hudProgress;

- (void)showProgressWithLabelText:(NSString *)labelText;
- (void)showProgressWithLabelText:(NSString *)labelText customView:(UIView *)customView;;
- (void)showProgressOnWindowWithLabelText:(NSString *)labelText;
- (void)showBarProgress;
- (void)changeProgressStateWithMode:(ZAProgressHUDMode)hudMode labelText:(NSString *)labelText customView:(UIView *)customView;

- (void)showProgress;
- (void)showWindowProgress;
- (void)hideProgress;
- (void)hideProgressAfterDelay:(NSTimeInterval)delay;

- (void)showToast:(NSString *)toast;
- (void)showToast:(NSString *)toast completion:(void(^)(void))completion;
- (void)showToast:(NSString *)toast hideAfterDelay:(NSTimeInterval)delay;
- (void)showToast:(NSString *)toast hideAfterDelay:(NSTimeInterval)delay completion:(void(^)(void))completion;
- (void)showToast:(NSString *)toast hideAfterDelay:(NSTimeInterval)delay withCustomView:(UIView *)customView;
- (void)showToast:(NSString *)toast hideAfterDelay:(NSTimeInterval)delay withCustomView:(UIView *)customView completion:(void(^)(void))completion;

- (void)showWindowToast:(NSString *)toast;
- (void)showWindowToast:(NSString *)toast completion:(void(^)(void))completion;
- (void)showWindowToast:(NSString *)toast hideAfterDelay:(NSTimeInterval)delay;
- (void)showWindowToast:(NSString *)toast hideAfterDelay:(NSTimeInterval)delay completion:(void(^)(void))completion;
- (void)showWindowToast:(NSString *)toast hideAfterDelay:(NSTimeInterval)delay withCustomView:(UIView *)customView;

@end
