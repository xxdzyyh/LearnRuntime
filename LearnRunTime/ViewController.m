//
//  ViewController.m
//  LearnRunTime
//
//  Created by xiaoniu on 2018/7/11.
//  Copyright © 2018年 com.learn. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"Runtime";
    
    self.dataSources = @[@{@"type" : @"UIViewController",@"className":@"ObjcMsgSendVC",@"desc":@"消息发送"},
                         @{@"type" : @"UIViewController",@"className":@"AddMethodVC",@"desc":@"添加方法"},
                         @{@"type" : @"UIViewController",@"className":@"SwizzleMethodVC",@"desc":@"交换方法"},
                          @{@"type" : @"UIViewController",@"className":@"ReplaceMethodVC",@"desc":@"替换方法"},
                         ];

}

@end
