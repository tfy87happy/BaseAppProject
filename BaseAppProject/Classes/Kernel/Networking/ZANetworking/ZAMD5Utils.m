//
//  ZAMD5Utils.m
//  ZANetworking
//
//  Created by Jason Ruan on 2017/8/24.
//  Copyright © 2017年 ZhenAiWang. All rights reserved.
//

#import "ZAMD5Utils.h"
#import <CommonCrypto/CommonDigest.h>

@implementation ZAMD5Utils

+ (NSString *)MD5WithString:(NSString *)string {
    
    if(string == nil || [string length] == 0)
        return nil;
    
    const char *value = [string UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return outputString ;
}

+ (NSString *)MD5WithData:(NSData *)data {
    if (data) {
        unsigned char result[16];
        CC_MD5(data.bytes, (CC_LONG)data.length, result ); // This is the md5 call
        return [NSString stringWithFormat:
                @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                result[0], result[1], result[2], result[3],
                result[4], result[5], result[6], result[7],
                result[8], result[9], result[10], result[11],
                result[12], result[13], result[14], result[15]
                ];
    } else {
        return nil;
    }
}

+ (NSString *)MD5WithDictionary:(NSDictionary *)dictionary {
    if (dictionary) {
        NSData *data= [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
        return [self MD5WithData:data];
    } else {
        return nil;
    }
}

+ (NSString *)MD5WithURL:(NSURL *)URL {
    return [self MD5WithString:[URL absoluteString]];
}

@end
