//
//  NSURL+SHRouter.m
//  SHRouterManager
//
//  Created by 汤浩博 on 2020/6/26.
//  Copyright © 2020 feiyang.tang. All rights reserved.
//

#import "NSURL+SHRouter.h"

@implementation NSURL (SHRouter)

- (void)router_parseURLWithCallback:(void(^)(NSString *scheme, NSString *host, NSDictionary *params))block{
    if (block) {
        NSString *scheme = self.scheme;
        NSString *host = self.host;
        
        NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:self resolvingAgainstBaseURL:NO];
        NSMutableDictionary *queryItemDict = [NSMutableDictionary dictionary];
        NSArray *queryItems = urlComponents.queryItems;
        for (NSURLQueryItem *item in queryItems) {
            [queryItemDict setObject:item.value forKey:item.name];
        }
        block(scheme, host, queryItemDict);
    }
}
@end
