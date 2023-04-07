//
//  Hook.m
//  iOS_reverse
//
//  Created by Dio Brand on 2023/4/7.
//

#import "Hook_objc.h"
#import <objc/message.h>

static NSString *deviceName;
static NSString *IDFA;

@implementation Hook_objc


-(void)hook {
    IDFA = @"9ECC3D7C-6FF8-4B15-A3D6-05AEAA644388";
    Method origin_advertisingIdentifier = class_getInstanceMethod(NSClassFromString(@"ASIdentifierManager"), @selector(advertisingIdentifier));
    Method new_advertisingIdentifier = class_getInstanceMethod([self class], @selector(advertisingIdentifier));
    method_exchangeImplementations(origin_advertisingIdentifier, new_advertisingIdentifier);
    NSLog(@"IDFA was hooked! new value:%@",IDFA);
    
    deviceName = @"newName_hook";
    Method origin_name = class_getInstanceMethod(NSClassFromString(@"UIDevice"), @selector(name));
    Method new_name = class_getInstanceMethod([self class], @selector(name));
    method_exchangeImplementations(origin_name, new_name);
    NSLog(@"deviceName was hooked! new value:%@",deviceName);
}

// OC 层获取设备名称 调用的方法
-(NSString *)name {
    return deviceName;
}

// 获取 IDFA 调用的方法
-(NSUUID *)advertisingIdentifier {
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:IDFA];
    return uuid;
}


@end
