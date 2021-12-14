//
//  SHThemeResourceUtils.m
//  SHUIKit
//
//  Created by 汤飞扬 on 2021/4/8.
//

#import "SHThemeResourceUtils.h"
#import "SHAppThemeColorDefine.h"
#import "UIColor+QMUI.h"
#import "UIColor+YYAdd.h"


static NSDictionary *themeTypeDictionary;

//*********json相关，具体格式见SHThemeResources_Dark.json*********
static NSString *const kSHModule = @"SHSmartHomeModule";//家居工程模块的key

static NSString *const kSHImageBundle = @"SmartHome.Image.bundle";//bundle的key

static NSString *const kSHDefaultThemeBundle = @"SmartHome.DefaultTheme.bundle";//bundle的key

static NSString *const kSHGoldenThemeBundle = @"SmartHome.GoldenTheme.bundle";//bundle的key


static NSString *const kSHImagesKey = @"images";//字典里区分image或是color的

static NSString *const kSHColorsKey = @"colors";//字典里区分image或是color的

static NSString *const kSHThemeJsonName = @"SHConfigTheme";


@interface SHThemeResourceUtils ()

@property (nonatomic, strong,readwrite) NSDictionary *resourceDictionary;//json文件资源内容

@property (nonatomic, copy) NSString *currentThemeIdentifier;//当前主题identifier

@property (nonatomic, strong,readwrite) NSDictionary *bundleDictionary;//json文件资源内容

@property (nonatomic, strong) NSCache *imageCaches;


@end

@implementation SHThemeResourceUtils

#pragma mark - Public
//Preset/ThemeJson/SHThemeResources_Dark.json
- (void)readResourceWithCurrentThemeIndetifier:(NSString *)currentThemeIdentifier completion:(void(^)(NSDictionary *resourceDictionary))completion{
    self.currentThemeIdentifier = currentThemeIdentifier;
    [self.imageCaches removeAllObjects];
    NSBundle *bundle = [self getBundleWithThemeIdentifier:currentThemeIdentifier];
    if (!bundle) {
        if (completion) {
            completion(nil);
        }
        return;
    }
    
    NSBundle *configBundle = bundle;
    NSString *jsonPath = [configBundle pathForResource:kSHThemeJsonName ofType:@"json"];
    if (!jsonPath.length) {
        if (completion) {
            completion(nil);
        }
        return;
    }
    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:jsonPath];
    if(!jsonData){
        if (completion) {
            completion(nil);
        }
        return;
    }
    NSDictionary *dicJson = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    if (!dicJson.allKeys.count) {
        if (completion) {
            completion(nil);
        }
        return;
    }
    
    self.resourceDictionary = dicJson;
    
    if (completion) {
        completion(self.resourceDictionary);
    }
}

- (NSString *)getImageNameWithIdentifier:(NSString *)identifier{
    NSLog(@"getImageNameWithIdentifier is %@",identifier);
    if (!self.resourceDictionary.allKeys.count || !identifier.length) {
        return identifier;
    }
    
    NSDictionary *imagesDictionary = self.resourceDictionary[@"images"];
    NSDictionary *singleDictionary = imagesDictionary[identifier];
    if (!singleDictionary.allKeys.count) {
        return identifier;
    }
    
    return singleDictionary[@"imageName"];
}

- (UIImage *)getImageWithName:(NSString *)name defaultImageNamed:(NSString *)defaultImageName themeIdentifier:(NSString *)themeIdentifier{
    NSString *imageName = [self getImageNameWithIdentifier:name];
    if (!imageName) {
        return [[UIImage alloc] init];
    }
    NSBundle *bundle = [self getBundleWithThemeIdentifier:themeIdentifier];
    UIImage *image = [UIImage imageNamed:imageName inBundle:bundle compatibleWithTraitCollection:nil];
    if (!image) {
        bundle = [self getBundleWithThemeIdentifier:QDThemeIdentifierDark];
        image = [UIImage imageNamed:imageName inBundle:bundle compatibleWithTraitCollection:nil];
    }
    if (image) {
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//        [self.imageCaches setObject:image forKey:name];
    }else{
        if (defaultImageName.length) {
            image = [UIImage imageNamed:defaultImageName inBundle:bundle compatibleWithTraitCollection:nil];
        }
    }
    return image;
}

- (UIColor *)getColorWithName:(NSString *)name{
    if (!self.resourceDictionary.allKeys.count || !name.length) {
        return [UIColor clearColor];
    }
    
    NSDictionary *colorsDictionary = self.resourceDictionary[kSHColorsKey];
    NSDictionary *singleColorDictionary = colorsDictionary[name];
    
    NSString *singleClorString = singleColorDictionary[@"color"];
    CGFloat alpha = [singleColorDictionary[@"alpha"] floatValue];
    
    if (!singleClorString.length || ![name isKindOfClass:[NSString class]]) {
        return [UIColor clearColor];
    }
    if (alpha >0) {
        return [[UIColor colorWithHexString:singleClorString] colorWithAlphaComponent:alpha];
    }
    return [UIColor colorWithHexString:singleClorString];
}

- (void)removeCaches{
    [self.imageCaches removeAllObjects];
}

- (UIImage *)getCacheImage:(NSString *)name{
    UIImage *cacheImage = [self.imageCaches objectForKey:name];
    return cacheImage;
}

#pragma mark - Private
- (NSBundle *)getBundleWithThemeIdentifier:(NSString *)themeIdentifier{
    if (!themeIdentifier.length) {
        return nil;
    }
    NSString *bundle = self.bundleDictionary[themeIdentifier];
    return bundle;
}

#pragma mark - Setter && Getter
- (NSDictionary *)bundleDictionary{
    if (!_bundleDictionary) {
        NSBundle* bundle = [NSBundle bundleForClass:[self class]];
        NSURL* bundleURL = [[bundle resourceURL] URLByAppendingPathComponent:kSHDefaultThemeBundle];
        NSBundle *defaultBundle = [NSBundle bundleWithURL:bundleURL];
        
        bundleURL = [[bundle resourceURL] URLByAppendingPathComponent:kSHGoldenThemeBundle];
        NSBundle *goldenBundle = [NSBundle bundleWithURL:bundleURL];
        _bundleDictionary = @{QDThemeIdentifierDefault:defaultBundle,
                              QDThemeIdentifierDark:defaultBundle,
                              QDThemeIdentifierGolden:goldenBundle,
                              
        };
    }
    return _bundleDictionary;
}

- (NSCache *)imageCaches{
    if (!_imageCaches) {
        _imageCaches = [[NSCache alloc] init];
    }
    return _imageCaches;
}

@end
