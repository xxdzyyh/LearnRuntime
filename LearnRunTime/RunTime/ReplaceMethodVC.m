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
    // Do any additional setup after loading the view.
    
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
    
//    Method method = class_getInstanceMethod([ReplaceMethodVC class], @selector(swizzle));
//
//    class_replaceMethod([ReplaceMethodVC class], @selector(origin), method_getImplementation(method), method_getTypeEncoding(method));
    
    Method method = class_getInstanceMethod([ReplaceMethodVC class], @selector(origin));
    
    IMP imp = imp_implementationWithBlock(^{
        NSLog(@"这是新的方法实现");
    });
    
    class_replaceMethod([ReplaceMethodVC class], @selector(origin), imp, method_getTypeEncoding(method));
}

- (void)origin {
    NSLog(@"originMethod");
}

- (void)swizzle {
    NSLog(@"这是Swizzle方法实现");
}

@end
