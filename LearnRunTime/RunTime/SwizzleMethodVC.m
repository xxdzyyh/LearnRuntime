//
//  SwizzleMethodVC.m
//  LearnRunTime
//
//  Created by xiaoniu on 2018/7/12.
//  Copyright © 2018年 com.learn. All rights reserved.
//

#import "SwizzleMethodVC.h"
#import <objc/runtime.h>
#import <objc/message.h>

@interface SwizzleMethodVC ()

@end

@implementation SwizzleMethodVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self swizzleMethod];
    [self origin];
}

- (void)origin {
    NSLog(@"originMethod");
}

- (void)swizzle {
    NSLog(@"这是Swizzle方法实现");
}

- (void)swizzleMethod {
    SEL originSel = @selector(origin);
    SEL swizzleSel = @selector(swizzle);
    
    Method originMethod = class_getInstanceMethod([SwizzleMethodVC class], originSel);
    Method swizzleMethod = class_getInstanceMethod([SwizzleMethodVC class], swizzleSel);
    
    // 确定方法存在就可以直接交换，否则可以考虑，如果方法不存在，可以先添加
    BOOL didAddMethod = class_addMethod([SwizzleMethodVC class], originSel, method_getImplementation(swizzleMethod), method_getTypeEncoding(swizzleMethod));
    
    if (didAddMethod) {
        class_replaceMethod([SwizzleMethodVC class], swizzleSel, method_getImplementation(originMethod), method_getTypeEncoding(originMethod));
    } else {
        method_exchangeImplementations(originMethod, swizzleMethod);
    }
}

@end
