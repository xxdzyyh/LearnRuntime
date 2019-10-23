//
//  ReplaceMethodVC.m
//  LearnRunTime
//
//  Created by xiaoniu on 2018/7/12.
//  Copyright © 2018年 com.learn. All rights reserved.
//

#import "ReplaceMethodVC.h"
#import <objc/runtime.h>
#import <objc/message.h>


@interface ReplaceMethodVC ()

@end

@implementation ReplaceMethodVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [button setTitle:@"点我" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    
    [self.view addSubview:button];
    
    [self replaceMethod];
}

- (void)buttonClicked {
    [self origin];
}

- (void)replaceMethod {
    Method method = class_getInstanceMethod([ReplaceMethodVC class], @selector(origin));

    IMP imp = imp_implementationWithBlock(^{
        NSLog(@"这是新的方法实现");
    });
    
    class_replaceMethod([ReplaceMethodVC class], @selector(origin), imp, method_getTypeEncoding(method));
}

/**
 * 使用类方法实现替换实例方法实现
 * 从消息角度而言，类方法和实例方法并没有太大的区别，只是消息的接受者不同而已
 * 从方法实现角度来看，类方法和实例方法没有任何区别
 */
- (void)replaceClassMethodWithInstanceMethod {
    Method method = class_getClassMethod([ReplaceMethodVC class], @selector(classMethod));
    
    IMP imp = method_getImplementation(method);

    class_replaceMethod([ReplaceMethodVC class], @selector(origin), imp, method_getTypeEncoding(method));
}

- (void)origin {
    NSLog(@"originMethod");
}

- (void)swizzle {
    NSLog(@"这是Swizzle方法实现");
}

+ (void)classMethod {
    NSLog(@"这是classMethod方法实现");
}

@end
