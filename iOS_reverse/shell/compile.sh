#!/bin/sh

#  compile.sh
#  iOS_reverse
#
#  Created by Dio Brand on 2023/4/7.
#  

# 架构
arch=arm64
# -isysroot指定系统SDK路径
SDK_path=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk

# 源文件
dylib_oc_source=${SRCROOT}/iOS_reverse/hook/*.m
dylib_c_source=${SRCROOT}/iOS_reverse/hook/*.c
injectdylib=libDarwinKernelCore.dylib

clang -fobjc-arc -fmodules -arch ${arch} -isysroot ${SDK_path} ${dylib_oc_source} ${dylib_c_source} -shared -o ${SRCROOT}/iOS_reverse/hook/${injectdylib}
