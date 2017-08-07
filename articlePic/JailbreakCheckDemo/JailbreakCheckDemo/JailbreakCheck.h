//
//  JailbreakCheck.h
//  CodeHelloWorld
//
//  Created by 小学生 on 17/8/7.
//  Copyright © 2017年 wu bei. All rights reserved.
//




#ifndef JailbreakCheck_h
#define JailbreakCheck_h

#include <string.h>
#import <mach-o/loader.h>
#import <mach-o/dyld.h>
#import <mach-o/arch.h>
#import <objc/runtime.h>
#include <dlfcn.h>
#import <Foundation/Foundation.h>
#import <sys/stat.h>




@interface JailbreakCheck : NSObject

- (BOOL)jailbroken;

- (BOOL)getJBPathByNSFM;

- (BOOL)getJBPathByStat;

- (BOOL)checkStatDylib;

- (BOOL)checkJBByEnv;

- (BOOL)checkDylib;

@end



#endif /* JailbreakCheck_h */
