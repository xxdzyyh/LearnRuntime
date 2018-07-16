//
//  FindOriginFuncVC.m
//  LearnRunTime
//
//  Created by xiaoniu on 2018/7/16.
//  Copyright © 2018年 com.learn. All rights reserved.
//

#import "FindOriginFuncVC.h"

#import "MyClass.h"
#import "MyClass+Ext.h"
#import <objc/runtime.h>
#import <objc/message.h>

@interface FindOriginFuncVC ()

@end
@implementation FindOriginFuncVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self findOriginMethod];
}

- (void)findOriginMethod {
    MyClass *myClass = [MyClass new];
    
    /**
     * category 中实现的test方法，会覆盖原类中的方法，但是原来的方法还存在于methodList当中，
     * 只是在调用的时候，从前往后找，找到了就不在继续查找，category的方法在前面，所以每次都是调用category中的方法。
     * 可以通过继续查找的methodList中方法，找到原来方法，然后进行调用
     */
    [myClass test];
    
    unsigned int methodCount;
    
    Method *methodList = class_copyMethodList(myClass.class, &methodCount);
    
    IMP lastImp = NULL;
    SEL lastSel = NULL;
    
    typedef void(*fn)(id,SEL);
    
    for (NSInteger i =0; i<methodCount; i++) {
        Method method = methodList[i];
        
        NSString *methodName = [NSString stringWithCString:sel_getName(method_getName(method)) encoding:NSUTF8StringEncoding];
        
        if ([methodName isEqualToString:@"test"]) {
            NSLog(@"i=%zd",i);
            lastImp = method_getImplementation(method);
            lastSel = method_getName(method);
            
            if (lastImp != NULL) {
                fn f = (fn)lastImp;
                f(myClass,lastSel);
            }
        }
    }

    free(methodList);
}

@end
