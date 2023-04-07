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
static NSString *retVal;

@implementation Hook_objc


-(void)hook {
    IDFA = @"9ECC3D7C-6FF8-4B15-A3D6-05AEAA644388";
    if(IDFA) {
        Method origin_method = class_getInstanceMethod(NSClassFromString(@"ASIdentifierManager"), @selector(advertisingIdentifier));
        Method new_method = class_getInstanceMethod([self class], @selector(advertisingIdentifier));
        method_exchangeImplementations(origin_method, new_method);
    }
    
    deviceName = @"newName_hook";
    if(deviceName) {
        Method origin_method = class_getInstanceMethod(NSClassFromString(@"UIDevice"), @selector(name));
        Method new_method = class_getInstanceMethod([self class], @selector(name));
        method_exchangeImplementations(origin_method, new_method);
    }
    
    retVal = @"was hooked!";
    if(retVal) {
        Method origin_method = class_getInstanceMethod(NSClassFromString(@"AllFunction"), @selector(funcNSStringHandle:param2:param3:));
        Method new_method = class_getInstanceMethod([self class], @selector(funcNSStringHandle:param2:param3:));
        method_exchangeImplementations(origin_method, new_method);
    }
}


//-(NSString *)deviceInfoForKey:(NSString *)key {
//    printf("hook log-------> %s %s %d <-------\n",__FILE__,__FUNCTION__,__LINE__);
//    NSLog(@"key:%@",key);
//    return @"new name";
//}

// OC 层获取设备名称 调用的方法
-(NSString *)name {
    printf("hook log-------> %s %s %d <-------\n",__FILE__,__FUNCTION__,__LINE__);
    //    Hook_objc *obj = [Hook_objc new];
    //    NSString *origin_ret = [obj name];
    //    NSLog(@"return origin:%@, new:%@",origin_ret,deviceName);
    return deviceName;
}

// 获取 IDFA 调用的方法
-(NSUUID *)advertisingIdentifier {
    printf("hook log-------> %s %s %d <-------\n",__FILE__,__FUNCTION__,__LINE__);
    Hook_objc *obj = [Hook_objc new];
    NSUUID *origin_UUID = [obj advertisingIdentifier];
    NSString *origin_ret = [origin_UUID UUIDString];
    
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:IDFA];
    NSLog(@"return origin:%@, new:%@",origin_ret,IDFA);
    return uuid;
}

-(NSString *)funcNSStringHandle:(NSString *)param1 param2:(NSString *)param2 param3:(NSString *)param3 {
    printf("hook log-------> %s %s %d <-------\n",__FILE__,__FUNCTION__,__LINE__);
    // 获取原方法的返回值
    Hook_objc *obj = [Hook_objc new];
    NSString *origin_ret = [obj funcNSStringHandle:param1 param2:param2 param3:param3];
    
    NSString *new_ret = [NSString stringWithFormat:@"%@|%@",origin_ret,retVal];
    NSLog(@"return origin:%@, new:%@",origin_ret,new_ret);
    return new_ret;
}

@end
