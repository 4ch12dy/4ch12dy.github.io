//
//  SuperLocation.h
//  SuperLocation
//
//  Created by 小学生 on 17/8/15.
//  Copyright © 2017年 小学生. All rights reserved.
//


#ifndef SuperLocation_h
#define SuperLocation_h

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <mach-o/dyld.h>
#import <dlfcn.h>

@interface CLClient : NSObject

@end

@interface SuperLocation : NSObject

@property(strong,nonatomic) CLLocationManager * locationManager;

- (void)getDylibInfo;

- (BOOL)starLocation;

- (void)SuperStartLocation:(CLClient *)cl one:(uint64_t)arg1 two:(uint64_t)arg2;

- (CLLocationManager *)sharedLocationManager;
@end


#endif /* SuperLocation_h */
