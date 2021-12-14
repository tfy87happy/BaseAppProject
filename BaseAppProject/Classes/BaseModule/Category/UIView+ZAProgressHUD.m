//
//  UIView+ZAProgressHUD.m
//  zhenaiwang
//
//  Created by Jason Ruan on 2017/6/9.
//  Copyright © 2017年 ZhenAiWang. All rights reserved.
//

#import "UIView+ZAProgressHUD.h"
#import "MBProgressHUD.h"
#import <objc/runtime.h>

@interface UIView()

@property (nonatomic, strong) MBProgressHUD *progressHUD;
@property (nonatomic, strong) UIWindow *progressHUDWindow;

@end

@implementation UIView (ZAProgressHUD)

#pragma mark Public Function

- (void)showToast:(NSString *)toast {
    [self showToast:toast hideAfterDelay:2.];
}

- (void)showToast:(NSString *)toast completion:(void(^)(void))completion {
    [self showToast:toast hideAfterDelay:2. completion:completion];
}

- (void)showToast:(NSString *)toast hideAfterDelay:(NSTimeInterval)delay {
    [self showToast:toast hideAfterDelay:delay withCustomView:nil];
}
- (void)showToast:(NSString *)toast hideAfterDelay:(NSTimeInterval)delay completion:(void(^)(void))completion {
    [self showToast:toast hideAfterDelay:delay withCustomView:nil completion:completion];
}
- (void)showToast:(NSString *)toast hideAfterDelay:(NSTimeInterval)delay withCustomView:(UIView *)customView {
    [self showToast:toast hideAfterDelay:delay withCustomView:customView completion:nil];
}

- (void)showToast:(NSString *)toast hideAfterDelay:(NSTimeInterval)delay withCustomView:(UIView *)customView completion:(void(^)(void))completion {
    if (!toast||!toast.length) {
        [self hideProgress];
        if (completion) {
            completion();
        }
        return;
    }
    
    if (!self.progressHUD) {
        self.progressHUD = [MBProgressHUD showHUDAddedTo:self animated:YES];
        if (customView) {
            self.progressHUD.customView = customView;
            self.progressHUD.mode = ZAProgressHUDModeCustomView;
        } else {
            self.progressHUD.mode = ZAProgressHUDModeText;
        }
        self.progressHUD.bezelView.color = [UIColor colorWithWhite:0 alpha:0.5];
        self.progressHUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        self.progressHUD.detailsLabel.text = toast;
        self.progressHUD.detailsLabel.textColor = [UIColor whiteColor];
        self.progressHUD.bezelView.layer.zPosition = 100;
    } else {
        if (customView) {
            [self changeProgressStateWithMode:ZAProgressHUDModeCustomView labelText:toast customView:customView];
        } else {
            [self changeProgressStateWithMode:ZAProgressHUDModeText labelText:toast customView:customView];
        }
    }
    if (self.progressHUD.alpha == 0.0f) {
        [self.progressHUD showAnimated:YES];
    }
    [self hideProgressAfterDelay:delay];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (completion) {
            completion();
        }
    });
}

- (void)showWindowToast:(NSString *)toast {
    [self showWindowToast:toast hideAfterDelay:2.];
}

- (void)showWindowToast:(NSString *)toast completion:(void(^)(void))completion {
    [self showWindowToast:toast hideAfterDelay:2. completion:completion];
}

- (void)showWindowToast:(NSString *)toast hideAfterDelay:(NSTimeInterval)delay {
    [self showWindowToast:toast hideAfterDelay:delay withCustomView:nil];
}
- (void)showWindowToast:(NSString *)toast hideAfterDelay:(NSTimeInterval)delay completion:(void(^)(void))completion {
    [self showWindowToast:toast hideAfterDelay:delay withCustomView:nil completion:completion];
}
- (void)showWindowToast:(NSString *)toast hideAfterDelay:(NSTimeInterval)delay withCustomView:(UIView *)customView {
    [self showWindowToast:toast hideAfterDelay:delay withCustomView:customView completion:nil];
}

- (void)showWindowToast:(NSString *)toast hideAfterDelay:(NSTimeInterval)delay withCustomView:(UIView *)customView completion:(void(^)(void))completion {
    
    if (!toast||!toast.length) {
        [self hideProgress];
        return;
    }
    
    if (!self.progressHUD) {
        self.progressHUD = [MBProgressHUD showHUDAddedTo:self.progressHUDWindow animated:YES];
        if (customView) {
            self.progressHUD.customView = customView;
            self.progressHUD.mode = ZAProgressHUDModeCustomView;
        } else {
            self.progressHUD.mode = ZAProgressHUDModeText;
        }
        self.progressHUD.bezelView.color = [UIColor colorWithWhite:0 alpha:0.5];
        self.progressHUD.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        self.progressHUD.detailsLabel.text = toast;
        self.progressHUD.detailsLabel.textColor = [UIColor whiteColor];
    } else {
        if (customView) {
            [self changeProgressStateWithMode:ZAProgressHUDModeCustomView labelText:toast customView:customView];
        } else {
            [self changeProgressStateWithMode:ZAProgressHUDModeText labelText:toast customView:customView];
        }
    }
    if (self.progressHUD.alpha == 0.0f) {
        [self.progressHUD showAnimated:YES];
    }
    [self hideProgressAfterDelay:delay];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (completion) {
            completion();
        }
    });
}

- (void)changeProgressStateWithMode:(ZAProgressHUDMode)hudMode labelText:(NSString *)labelText customView:(UIView *)customView {
    self.progressHUD.customView = customView;
    self.progressHUD.mode = (MBProgressHUDMode)hudMode;
    self.progressHUD.detailsLabel.text = labelText;
    self.progressHUD.detailsLabel.textColor = [UIColor whiteColor];
    if (hudMode == ZAProgressHUDModeDeterminateHorizontalBar) {
        self.progressHUD.bezelView.color = [UIColor colorWithWhite:1 alpha:0.5];
    } else {
        self.progressHUD.bezelView.color = [UIColor colorWithWhite:0 alpha:0.5];
    }
    [self.progressHUD setNeedsLayout];
    [self.progressHUD setNeedsDisplay];
}

- (void)hideProgress {
    [self.progressHUD hideAnimated:YES];
    self.progressHUD = nil;
    self.progressHUDWindow.hidden = YES;
    self.progressHUDWindow = nil;
}

- (void)hideProgressAfterDelay:(NSTimeInterval)delay {
    [self.progressHUD hideAnimated:YES afterDelay:delay];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.progressHUD = nil;
        self.progressHUDWindow.hidden = YES;
        self.progressHUDWindow = nil;
    });
}

- (void)showWindowProgress {
    [self showProgressOnWindowWithLabelText:nil];
}

- (void)showProgressWithLabelText:(NSString *)labelText {
    if (!self.progressHUD) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
        hud.detailsLabel.text = labelText;
        hud.detailsLabel.textColor = [UIColor whiteColor];
        hud.bezelView.color = [UIColor colorWithWhite:0 alpha:0.5];
        hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.layer.zPosition = 100;
        self.progressHUD = hud;
    } else {
        [self changeProgressStateWithMode:ZAProgressHUDModeCustomView labelText:labelText customView:nil];
    }
    if (self.progressHUD.alpha == 0.0f) {
        [self.progressHUD showAnimated:YES];
    }
}

- (void)showProgressWithLabelText:(NSString *)labelText customView:(UIView *)customView {
    if (!self.progressHUD) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
        hud.bezelView.color = [UIColor colorWithWhite:0 alpha:0.5];
        hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.detailsLabel.text = labelText;
        hud.detailsLabel.textColor = [UIColor whiteColor];
        hud.customView = customView;
        hud.mode = ZAProgressHUDModeCustomView;
        self.progressHUD = hud;
    } else {
        [self changeProgressStateWithMode:ZAProgressHUDModeCustomView labelText:labelText customView:customView];
    }
    
    if (self.progressHUD.alpha == 0.0f) {
        [self.progressHUD showAnimated:YES];
    }
}

- (void)showProgress {
    [self showProgressWithLabelText:nil];
}

- (void)showProgressOnWindowWithLabelText:(NSString *)labelText {
    
    if (!self.progressHUD) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.progressHUDWindow animated:YES];
        hud.bezelView.color = [UIColor colorWithWhite:0 alpha:0.5];
        hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.detailsLabel.text = labelText;
        hud.detailsLabel.textColor = [UIColor whiteColor];
        self.progressHUD = hud;
    } else {
        [self changeProgressStateWithMode:ZAProgressHUDModeIndeterminate labelText:labelText customView:nil];
    }
    if (self.progressHUD.alpha == 0.0f) {
        [self.progressHUD showAnimated:YES];
    }
}

- (void)showBarProgress {
    if (!self.progressHUD) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
        hud.mode = ZAProgressHUDModeDeterminateHorizontalBar;
        self.progressHUD = hud;
    } else {
        [self changeProgressStateWithMode:ZAProgressHUDModeIndeterminate labelText:nil customView:nil];
    }
    if (self.progressHUD.alpha == 0.0f) {
        [self.progressHUD showAnimated:YES];
    }
}

#pragma mark Getter & Setter

- (MBProgressHUD *)progressHUD {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setProgressHUD:(MBProgressHUD *)progressHUD {
    objc_setAssociatedObject(self, @selector(progressHUD), progressHUD, OBJC_ASSOCIATION_RETAIN);
}

- (UIWindow *)progressHUDWindow {
    UIWindow *progressHUDWindow = objc_getAssociatedObject(self, _cmd);
    if (!progressHUDWindow) {
        UIWindow *alertLevelWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        alertLevelWindow.backgroundColor = [UIColor clearColor];
        alertLevelWindow.hidden = NO;
        self.progressHUDWindow = alertLevelWindow;
        progressHUDWindow = alertLevelWindow;
    }
    return progressHUDWindow;
}

- (void)setProgressHUDWindow:(UIWindow *)progressHUDWindow {
    objc_setAssociatedObject(self, @selector(progressHUDWindow), progressHUDWindow, OBJC_ASSOCIATION_RETAIN);
}

- (CGFloat)hudProgress {
    if (self.progressHUD && self.progressHUD.mode == ZAProgressHUDModeDeterminateHorizontalBar) {
        return self.progressHUD.progress;
    } else {
        return 0;
    }
}

- (void)setHudProgress:(CGFloat)hudProgress {
    if (self.progressHUD && self.progressHUD.mode == ZAProgressHUDModeDeterminateHorizontalBar) {
        self.progressHUD.progress = hudProgress;
    }
}

@end
