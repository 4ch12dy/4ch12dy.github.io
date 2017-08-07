//
//  MainViewController.m
//  CodeHelloWorld
//
//  Created by wu bei on 12-10-7.
//  Copyright (c) 2012年 wu bei. All rights reserved.
//

#import "MainViewController.h"
#import "JailbreakCheck.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)loadView
{
    // 声明一个UIView
    UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    // View的背景设置为白色
    view.backgroundColor = [UIColor whiteColor];
    
    self.view = view;
    [view release];
    
    CGRect rect = CGRectMake(100, 100, 300, 100);
//    CGRect rect2 = CGRectMake(0, 0, 500, 500);
    UILabel *textLabel = [[UILabel alloc] initWithFrame:rect];
//    UITextField *textfield = [[UITextField alloc] initWithFrame:rect2];
    
    //check is JB
    
    if([[JailbreakCheck alloc] jailbroken]){
       
        textLabel.text = @"jailbreak=yes";
    
    }else{
    
        textLabel.text = @"jailbreak=no";
    }
    
//    textfield.text = [[JailbreakCheck alloc] checkStatDylib];
    
    textLabel.textColor = [UIColor redColor];
//    [self.view addSubview:textfield];
    [self.view addSubview:textLabel];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
