#import "Hook_objc.h"
#include "Hook_C.h"

__attribute__((constructor)) void dylibMain(void) {
    @autoreleasepool {
        NSLog(@"动态库注入成功!");
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [[Hook_objc new] hook];
            hook();
        });
    }
}
