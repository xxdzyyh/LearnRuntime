//
//  ObjcMsgSendVC.m
//  LearnRunTime
//
//  Created by xiaoniu on 2018/7/12.
//  Copyright © 2018年 com.learn. All rights reserved.
//

#import "ObjcMsgSendVC.h"
#import <objc/message.h>
#import <objc/runtime.h>

@interface ObjcMsgSendVC ()

@end

@implementation ObjcMsgSendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.dataSources = @[@{@"type" : @"callMethod",@"className":@"noReturnNoParams",@"desc":@"无参数无返回"},
                         @{@"type" : @"callMethod",@"className":@"hasReturnNoParams",@"desc":@"无参数有返回"},
                         @{@"type" : @"callMethod",@"className":@"noReturnHasParams",@"desc":@"有参数无返回"},
                         @{@"type" : @"callMethod",@"className":@"hasReturnHasParams",@"desc":@"有参数有返回"},
                         @{@"type" : @"callMethod",@"className":@"apple demo",@"desc":@"apple demo"},
                         @{@"type" : @"callMethod",@"className":@"testForwarding",@"desc":@"方法转发"}];
    
}

- (void)noReturnNoParams {
    NSLog(@"noReturnNoParams");
}

- (NSString *)hasReturnNoParams {
    NSLog(@"hasReturnNoParams");
    return @"hasReturnNoParams";
}

- (void)noReturnHasParams:(NSString *)params {
    NSLog(@"noReturnHasParams:%@",params);
}

- (NSString *)hasReturnHasParams:(NSString *)params {
    NSLog(@"hasReturnHasParams:%@",params);
    
    return params;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = self.dataSources[indexPath.row];
    NSString *type = dict[@"type"];
    
    if ([type isEqualToString:@"callMethod"]) {
        
        switch (indexPath.row) {
            case 0:{
                ((void(*)(id,SEL))objc_msgSend)(self,@selector(noReturnNoParams));
            }
                break;
            case 1:{
                ((NSString*(*)(id,SEL))objc_msgSend)(self,@selector(hasReturnNoParams));
            }
                break;
            case 2:{
                ((void(*)(id,SEL,NSString *))objc_msgSend)(self,@selector(noReturnHasParams:),@"this is param");
            }
                break;
            case 3:{
                ((NSString *(*)(id,SEL,NSString *))objc_msgSend)(self,@selector(hasReturnHasParams:),@"this is param");
            }
                break;
            case 4:{
                [self appleDemo];
            }
                break;
            case 5: {
                [self testForwarding];
            }
                break;
            default:
                break;
        }
        
    }
}

- (void)appleDemo {
    id view0 = [ObjcMsgSendVC new];
    id view1 = [ObjcMsgSendVC new];
    id view2 = [ObjcMsgSendVC new];
    
    NSArray *views = @[view0, view1, view2];
    
    void (*setter)(id,SEL,BOOL);
    int i;
    
    // 获取到方法实现地址后，就可以直接调用方法
    setter = (void(*)(id, SEL, BOOL))[view1 methodForSelector:@selector(showWithAnimated:)];
    
    for (i=0;i<views.count;i++) {
        setter(views[i], @selector(showWithAnimated:), YES);
    }
}

- (void)showWithAnimated:(BOOL)animated {
    NSLog(@"showWithAnimated:");
}

#pragma mark - 消息转发

/*
 1. 进行动态解析，如果动态解析添加了方法，就不会进入下一步
 2. 进行快速解析
 */

- (void)testForwarding {
    [self performSelector:@selector(nofunction)];
}

#pragma mark - 消息转发 > 动态方法解析

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    NSLog(@"resolveInstanceMethod");
    
    if (sel == @selector(nofunction)) {
        
//        IMP imp = imp_implementationWithBlock(^{
//            NSLog(@"既然没有实现，那就动态添加方法");
//        });
//
//        class_addMethod([ObjcMsgSendVC class], sel, imp, "v@:");

        return YES;
    }
    
    return [super resolveInstanceMethod:sel];
}

+ (BOOL)resolveClassMethod:(SEL)sel {
    return [super resolveClassMethod:sel];
}

#pragma mark - 消息转发 > 快速转发

- (id)forwardingTargetForSelector:(SEL)aSelector {
    NSLog(@"forwardingTargetForSelector:");
    
    if (aSelector == @selector(nofunction)) {
        // 这里可以返回其他的对象
        return self;
    } else {
        return [super forwardingTargetForSelector:aSelector];
    }
}

#pragma mark - 消息转发 > 正常转发

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSLog(@"methodSignatureForSelector:");
    
    if (aSelector == @selector(nofunction)) {
        // return nil;就不会调用下一步forwardInvocation:
        return [self methodSignatureForSelector:@selector(noReturnNoParams)];
    } else {
        return [super methodSignatureForSelector:aSelector];
    }
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    NSLog(@"forwardInvocation:");
    
    if (anInvocation.selector == @selector(nofunction)) {
        NSLog(@"anInvocation.selector == @selector(nofunction)");
        
        [self showWithAnimated:YES];
        
    } else {
        [super forwardInvocation:anInvocation];
    }
}


@end
