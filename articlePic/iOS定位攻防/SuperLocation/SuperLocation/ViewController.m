//
//  ViewController.m
//  SuperLocation
//
//  Created by 小学生 on 17/8/14.
//  Copyright © 2017年 小学生. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
CLLocationManager * _locationManager;
CLGeocoder * _geocoder;//初始化地理编码器

UITextField *lat;
UITextField *lon;
UITextField *cityName;
UITextField *high;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    lat = [[UITextField alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    lon = [[UITextField alloc]initWithFrame:CGRectMake(100, 150, 100, 100)];
    cityName = [[UITextField alloc]initWithFrame:CGRectMake(100, 200, 500, 100)];
    high = [[UITextField alloc]initWithFrame:CGRectMake(100, 250, 500, 100)];
    cityName.text = @"正在搜索...";
    NSLog(@"[i]init LocationService... \n");
    [self initializeLocationService];
    return self;
}

- (void)viewDidLoad {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 500, 500)];
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(50, 50, 200, 100)];
    UILabel *lable_lat = [[UILabel alloc]initWithFrame:CGRectMake(50, 100, 100, 100)];
    UILabel *lable_lon = [[UILabel alloc]initWithFrame:CGRectMake(50, 150, 100, 100)];
    UILabel *lable_city = [[UILabel alloc]initWithFrame:CGRectMake(50, 200, 100, 100)];
    UILabel *lable_high = [[UILabel alloc]initWithFrame:CGRectMake(50, 250, 100, 100)];

    
    [super viewDidLoad];
   
    lable_lat.text = @"经度:";
    lable_lon.text = @"纬度:";
    lable_city.text = @"街道:";
    lable_high.text =@"海拔:";
    
    
    lable.text = @"StarLocation...";
    lable.textColor = [UIColor redColor];
    [view addSubview:lable];
    
    
    view.backgroundColor = [UIColor whiteColor];
    [view addSubview:lat];
    [view addSubview:lon];
    [view addSubview:lable_lon];
    [view addSubview:lable_lat];
    [view addSubview:lable_city];
    [view addSubview:cityName];
    
    [view addSubview:lable_high];
    [view addSubview:high];
    
    self.view = view;
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)initializeLocationService {
    // 初始化定位管理器
    _locationManager = [[[SuperLocation alloc]init] sharedLocationManager];
    [_locationManager requestWhenInUseAuthorization];
//  [_locationManager requestAlwaysAuthorization];//iOS8必须，这两行必须有一行执行，否则无法获取位置信息，和定位
    // 设置代理
    _locationManager.delegate = self;
    // 设置定位精确度到米
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    // 设置过滤器为无
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    
    //初始化地理编码器
    _geocoder = [[CLGeocoder alloc] init];
    
    
    // 开始定位
    NSLog(@"[i] Start updateing location...\n");
    
    //获取动态库信息
//    [[SuperLocation alloc] getDylibInfo];
    
    //使用底层定位Api
//    [[[SuperLocation alloc]init] SuperStartLocation:[_locationManager performSelector:NSSelectorFromString(@"internalClient")] one:0x00000000ffffffff two:0];

    
    
    //正常获取定位
    [_locationManager startUpdatingLocation];


}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
//    NSLog(@"%lu",(unsigned long)locations.count);
    CLLocation * location = locations.lastObject;
    // 纬度
    CLLocationDegrees latitude = location.coordinate.latitude;
    lat.text = [NSString stringWithFormat:@"%f", latitude];
//    NSLog(@"[i] latitude = %f\n", latitude);
    // 经度
    CLLocationDegrees longitude = location.coordinate.longitude;
    lon.text = [NSString stringWithFormat:@"%f", longitude];
    NSLog(@"[i] longitude = %f\n", longitude);
    
    NSLog(@"%@",[NSString stringWithFormat:@"%lf", location.coordinate.longitude]);
    NSLog(@"经度：%f,纬度：%f,海拔：%f,航向：%f,行走速度：%f", location.coordinate.longitude, location.coordinate.latitude,location.altitude,location.course,location.speed);
    high.text = [NSString stringWithFormat:@"%f", location.altitude];
    [_geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count > 0) {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            NSLog(@"%@",placemark.name);
            //获取城市
            NSString *city = placemark.locality;
            if (!city) {
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                city = placemark.administrativeArea;
            }
            // 位置名
            NSLog(@"name,%@",placemark.name);
            // 街道
            NSLog(@"thoroughfare,%@",placemark.thoroughfare);
            // 子街道
            NSLog(@"subThoroughfare,%@",placemark.subThoroughfare);
            // 市
            NSLog(@"locality,%@",placemark.locality);
            cityName.text = [NSString stringWithFormat:@"%@-%@",placemark.locality,placemark.name];
            
            // 区
            NSLog(@"subLocality,%@",placemark.subLocality);
            // 国家
            NSLog(@"country,%@",placemark.country);
        }else if (error == nil && [placemarks count] == 0) {
            NSLog(@"No results were returned.");
        } else if (error != nil){
            NSLog(@"An error occurred = %@", error);
        }
    }];
    //不用的时候关闭更新位置服务
    
    [manager stopUpdatingLocation];
}

@end
