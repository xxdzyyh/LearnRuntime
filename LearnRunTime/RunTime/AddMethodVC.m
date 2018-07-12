//
//  AddMethodVC.m
//  LearnRunTime
//
//  Created by xiaoniu on 2018/7/11.
//  Copyright © 2018年 com.learn. All rights reserved.
//

#import "AddMethodVC.h"
#import <objc/runtime.h>
#import <objc/message.h>

@interface AddMethodVC ()

@end

@implementation AddMethodVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setTitle:@"吾问无为谓" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    
    [self.view addSubview:button];
    
    [self addMethodTest];
}

- (void)buttonClicked {
    [self performSelector:@selector(test)];
}

- (void)addMethodTest {
    SEL selector = @selector(test);
    
    IMP imp =imp_implementationWithBlock(^{
        NSLog(@"这是方法实现");
    });
    
    Method method = class_getInstanceMethod([AddMethodVC class], selector);
    
    class_addMethod([AddMethodVC class], selector, imp, method_getTypeEncoding(method));
}

@end
