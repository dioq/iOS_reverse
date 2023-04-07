//
//  Hook_C.c
//  iOS_reverse
//
//  Created by Dio Brand on 2023/4/7.
//

#include "Hook_C.h"
#include <string.h>
#include "fishhook.h"
#import "sys/utsname.h"

static const char *deviceName = "newName_hook";

// 保存原来的 uname 函数
static int(*origin_uname)(struct utsname *,...);
// 获取 系统内核 信息时调用的方法
int new_uname(struct utsname *systemInfo) {
    printf("hook log-------> %s %s %d <-------\n",__FILE__,__FUNCTION__,__LINE__);
    int ret = origin_uname(systemInfo);//先调用原来的 uname 改变传入的结构体内容
    //接着再次更改传入的结构体内容
    //    const char *sysname = [sysname_new UTF8String];
    const char *nodename = deviceName;
    printf("origin value:%s new value:%s\n",systemInfo->nodename,nodename);
    //    const char *release = [release_new UTF8String];
    //    const char *version = [version_new UTF8String];
    //    const char *machine = [machine_new UTF8String];
    //    memcpy((*systemInfo).sysname, sysname, _SYS_NAMELEN);
    memcpy(systemInfo->nodename, nodename, _SYS_NAMELEN);
    //    memcpy((*systemInfo).release, release, _SYS_NAMELEN);
    //    memcpy((*systemInfo).version, version, _SYS_NAMELEN);
    //    memcpy((*systemInfo).machine, machine, _SYS_NAMELEN);
    return ret;
};

int hook(void) {
    // Darwin hook 手机名字
    if(deviceName) {
        struct rebinding darwin;
        darwin.name = "uname";
        darwin.replacement = new_uname;
        darwin.replaced = (void *)&origin_uname;
        struct rebinding rebs[1] = {darwin};
        rebind_symbols(rebs, 1);
    }
    return 0;
}
