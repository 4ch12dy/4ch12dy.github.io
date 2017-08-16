//
//  SuperLocation.m
//  SuperLocation
//
//  Created by 小学生 on 17/8/15.
//  Copyright © 2017年 小学生. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SuperLocation.h"




@interface SuperLocation()

@end

@implementation SuperLocation

- (void)SuperStartLocation:(CLClient *)cl one:(uint64_t)arg1 two:(uint64_t)arg2{
    
    //定义函数类型
    typedef  void (*CLClientStartLocationUpdatesWithDynamicAccuracyReduction) (CLClient* client, uint64_t arg1, uint64_t arg2);
    
    //获取动态库句柄
    void * CoreLocation = dlopen("/System/Library/Framework/CoreLocation.framework/CoreLocation", RTLD_LAZY);
    
    //获取函数地址
    CLClientStartLocationUpdatesWithDynamicAccuracyReduction _CLClientStartLocationUpdatesWithDynamicAccuracyReduction = dlsym(CoreLocation, "CLClientStartLocationUpdatesWithDynamicAccuracyReduction");
    
    
    
    //提示信息，并打印函数地址
    NSLog(@"\n[i] Start call my locationFunction...\nCLClientStartLocationUpdatesWithDynamicAccuracyReduction_addr=0x%llx\n",(uint64_t)_CLClientStartLocationUpdatesWithDynamicAccuracyReduction);

    
    //调用底层定位Api函数
    _CLClientStartLocationUpdatesWithDynamicAccuracyReduction(cl,arg1,arg2);
    
    
}


- (BOOL)starLocation{
    
    CLLocationManager *locMG = [self sharedLocationManager];
    
    [locMG startUpdatingLocation];
    
    return YES;
}


//返回实例
- (CLLocationManager *)sharedLocationManager{
    if (!self.locationManager) {
        return self.locationManager = [[CLLocationManager alloc]init];
    }
    return self.locationManager;
}










//获取动态库信息
- (void)getDylibInfo{
    NSLog(@"*****Created by 4ch12dy*****\nDyld image count is: %d.\n", _dyld_image_count());
    for (int i = 0; i < _dyld_image_count(); i++) {
        NSString *name = [[NSString alloc] initWithUTF8String:_dyld_get_image_name(i)];
        if ([name containsString:@"ocation"]) {
            
            const struct mach_header *mh = _dyld_get_image_header(i);
            intptr_t vmaddr_slide = _dyld_get_image_vmaddr_slide(i);
        
            NSLog(@"Image name %@ at address 0x%llx and ASLR slide 0x%lx.\n",
                  name, (mach_vm_address_t)mh, vmaddr_slide);
        }
    }
}


@end
