//
//  MacroDefinesHeader.h
//  BaseAppProject
//
//  Created by 汤飞扬 on 2021/2/26.
//

#ifndef MacroDefinesHeader_h
#define MacroDefinesHeader_h

#ifndef dispatch_main_async_safe
#define dispatch_main_async_safe(block)\
    if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(dispatch_get_main_queue())) == 0) {\
        block();\
    } else {\
        dispatch_async(dispatch_get_main_queue(), block);\
    }
#endif

#ifndef dispatch_async_global
#define dispatch_async_global(block)\
    dispatch_async(dispatch_get_global_queue(0, 0), block);
#endif

#define kRouterDomain @"BaseProject-Internal"


#endif /* MacroDefinesHeader_h */
