//
//  AppDelegate.h
//  CodeHelloWorld
//
//  Created by wu bei on 12-10-7.
//  Copyright (c) 2012年 wu bei. All rights reserved.
//

#import <UIKit/UIKit.h>
// 引入添加的MainViewController.h
#import "MainViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MainViewController *mainView;

@end
