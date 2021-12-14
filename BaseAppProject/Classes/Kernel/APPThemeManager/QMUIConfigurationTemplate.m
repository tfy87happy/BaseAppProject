//
//  QMUIConfigurationTemplate.m
//  SHUIKit
//
//  Created by 汤飞扬 on 2021/4/8.
//

#import "QMUIConfigurationTemplate.h"
#import "QMUIThemeManagerCenter.h"
#import "SHAppThemeColorDefine.h"
#import "SHAppThemeColorDefine.h"
#import "QMUIConfigurationMacros.h"
#import "UIImage+YYAdd.h"


@implementation QMUIConfigurationTemplate
- (void)applyConfigurationTemplate {
    
}

- (BOOL)shouldApplyTemplateAutomatically {
    [QMUIThemeManagerCenter.defaultThemeManager addThemeIdentifier:self.themeName theme:self];

    NSString *selectedThemeIdentifier = [[NSUserDefaults standardUserDefaults] stringForKey:QDSelectedThemeIdentifier];
    NSLog(@"selectedThemeIdentifier is %@",selectedThemeIdentifier);
    BOOL result = [selectedThemeIdentifier isEqualToString:self.themeName] || (!selectedThemeIdentifier && !QMUIThemeManagerCenter.defaultThemeManager.currentThemeIdentifier);
    if (result) {
        QMUIThemeManagerCenter.defaultThemeManager.currentTheme = self;
    }
    return result;
}

#pragma mark - <SHAPPThemeProtocol>

- (UIColor *)themeBackgroundColor {
    return [UIColor whiteColor];
}

- (NSString *)themeName {
    return QDThemeIdentifierDefault;
}

@end
