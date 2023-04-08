#!/bin/sh

# SRCROOT                       当前工程所在的目录
# PRODUCT_NAME                  产品名称
# BUILT_PRODUCTS_DIR            Xcode创建App时 xxx.app 的缓存目录 command + shift + c 可以清空这个目录
# EXPANDED_CODE_SIGN_IDENTITY   当前工程运行时所使用的签名证书
# PRODUCT_BUNDLE_IDENTIFIER     bundle identifier 是App的唯一标识

# 待调试 app #WeChat.app   TargetForCrack.app TargetObjCHook.app
TARGET_APP_NAME=TargetForCrack.app

# 自己编译的动态库,注入到目标应用
injectdylib=libDarwinKernelCore.dylib

# 需要复制的目标应用
TARGET_APP_PATH=${SRCROOT}/iOS_reverse/target_app/${TARGET_APP_NAME}
# Xcode 运行时会创建的 xxx.app
BUILD_APP_PATH=${BUILT_PRODUCTS_DIR}/"${PRODUCT_NAME}.app"


# 清空 Xcode 创建 App 的缓存目录
rm -rf ${BUILT_PRODUCTS_DIR}/*

# 复制待调试xxx.app到 Xcode缓存目录,并修改名字为当前工程可识别的名字.实现替换xxx.app的目的
cp -rf ${TARGET_APP_PATH} ${BUILD_APP_PATH}
# 删除不能用个人证书签名的插件 Watch PlugIns
rm -rf ${BUILD_APP_PATH}/Watch
rm -rf ${BUILD_APP_PATH}/PlugIns
# 修改使 bundle id 一致
/usr/libexec/PlistBuddy -c "Set :CFBundleIdentifier ${PRODUCT_BUNDLE_IDENTIFIER}" "${BUILD_APP_PATH}/Info.plist"

# 待注入动态库放在 Frameworks 里, 大部分 ipa 包里都有这个目录如果没有就创建一个
if [ ! -d "${BUILD_APP_PATH}/Frameworks" ]; then
    mkdir "${BUILD_APP_PATH}/Frameworks"
fi
# 自己编译的动态库放到 目标app里
mv ${SRCROOT}/iOS_reverse/hook/${injectdylib} ${BUILD_APP_PATH}/Frameworks/
# 在目标app的可执行文件里添加动态库依赖路径
optool install -c load -p "@executable_path/Frameworks/${injectdylib}" -t ${BUILD_APP_PATH}/${exe_bin}

# 签名
## 签名动态库
if [ -d "${BUILD_APP_PATH}/Frameworks" ]; then
    /usr/bin/codesign --force --sign "${EXPANDED_CODE_SIGN_IDENTITY}" ${BUILD_APP_PATH}/Frameworks/*.dylib
    /usr/bin/codesign --force --sign "${EXPANDED_CODE_SIGN_IDENTITY}" ${BUILD_APP_PATH}/Frameworks/*.framework
fi
if [ -d "${BUILD_APP_PATH}/PlugIns" ]; then
    /usr/bin/codesign --force --sign "${EXPANDED_CODE_SIGN_IDENTITY}" ${BUILD_APP_PATH}/PlugIns/*
fi
## Mach-O可执行文件名
exe_bin=$(/usr/libexec/PlistBuddy -c "Print :CFBundleExecutable" "${BUILD_APP_PATH}/Info.plist")
# 签名Mach-O可执行文件
/usr/bin/codesign --force --sign "${EXPANDED_CODE_SIGN_IDENTITY}" ${BUILD_APP_PATH}/${exe_bin}
