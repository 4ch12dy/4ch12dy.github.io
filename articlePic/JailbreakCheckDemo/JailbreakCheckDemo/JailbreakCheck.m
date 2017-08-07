//
//  JailbreakCheck.m
//  CodeHelloWorld
//
//  Created by 小学生 on 17/8/7.
//  Copyright © 2017年 wu bei. All rights reserved.
//


# import "JailbreakCheck.h"

@implementation JailbreakCheck

- (BOOL)getJBPathByNSFM{
    BOOL isJB = NO;
    NSString *cydiaPath = @"/Applications/MobileSafari.app";
    
    if([[NSFileManager defaultManager] fileExistsAtPath:cydiaPath]){
        isJB = YES;
    }
        
    return isJB;
}
- (BOOL)getJBPathByStat{
    struct stat stat_info;
    
//只有在真机上时才会执行，因为在模拟器中dylib_info.dli_fname包含的路径不一致
#ifndef SIMULATOR_TEST
    if (self.checkStatDylib) {
        return YES;
    }
#endif
    
    
    const char *cydiaPath = "/Applications/MobileSafari.app";
    if(0 == stat(cydiaPath, &stat_info)){
        return YES;
    }
    return NO;
    
}

- (BOOL)checkStatDylib{
    
    int ret;
    
    Dl_info dylib_info;
    
    int (*func_stat)(const char *,struct stat *) = stat;
    
    if ((ret = dladdr(func_stat, &dylib_info))) {
        if (strcmp(dylib_info.dli_fname,"/usr/lib/system/libsystem_kernel.dylib") != 0) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)checkJBByEnv{
    char * env = getenv("DYLD_INSERT_LIBRARIES");
    
    if(env){
        return YES;
    }
    return NO;
}

- (BOOL)checkDylib{
    
    uint32_t count = _dyld_image_count();
    for (uint32_t i = 0; i < count; i++) {
        NSString * name = [[NSString alloc] initWithUTF8String:_dyld_get_image_name(i)];
        if ([name containsString:@"Library/MobileSubstrate/MobileSubstrate.dylib"]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)jailbroken{
    
    BOOL condition =
    self.getJBPathByStat ||
    self.getJBPathByNSFM ||
    self.checkJBByEnv    ||
    self.checkDylib;
    
    
    if (condition) {
        return YES;
    }
    return NO;
}

@end
