//
//  SHAPPThemeProtocol.h
//  SHUIKit
//
//  Created by 汤飞扬 on 2021/4/8.
//

#import <Foundation/Foundation.h>
#import "QMUIConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SHAPPThemeProtocol <QMUIConfigurationTemplateProtocol>

- (NSString *)themeName;

/// 界面背景色
- (UIColor *)themeBackgroundColor;

@end

NS_ASSUME_NONNULL_END
