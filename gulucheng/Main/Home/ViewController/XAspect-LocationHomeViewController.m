//
//  XAspect-LocationHomeViewController.m
//  GuluCheng
//
//  Created by xukz on 16/9/22.
//  Copyright © 2016年 许坤志. All rights reserved.
//

#import "HomeViewController.h"

#import "XAspect.h"

#define DefaultLocationTimeout 10
#define DefaultReGeocodeTimeout 5

#define AtAspect LocationHomeViewController

#define AtAspectOfClass HomeViewController
@classPatchField(HomeViewController)

AspectPatch(-, void, viewWillAppear:(BOOL)animated) {
    
    [self initCompleteBlock];
    [self configLocationManager];
    [self reGeocodeAction];
    
    return XAMessageForward(viewWillAppear:animated);
}

AspectPatch(-, void, viewWillDisappear:(BOOL)animated) {
    
    [self cleanUpAction];
    
    return XAMessageForward(viewWillDisappear:animated);
}

AspectPatch(-, void, viewDidLoad) {
    
    
    
    return XAMessageForward(viewDidLoad);
}

#pragma mark - Initialization

- (void)initCompleteBlock {
    WEAKSELF
    self.completionBlock = ^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        if (error) {
            
            if (error.code == AMapLocationErrorLocateFailed) {
                return;
            }
        }
        
        if (location) {
            if (regeocode) {
                
                weakSelf.latitude = location.coordinate.latitude;
                weakSelf.longitude = location.coordinate.longitude;

                // 判断直辖市或者省级市
                NSString *city = [NSString stringWithFormat:@"%@-%@", regeocode.province, regeocode.city];
                if (!regeocode.city || [regeocode.city length] == 0 || [regeocode.province isEqualToString:regeocode.city]) {
                    city = [NSString stringWithFormat:@"%@-%@", regeocode.province, regeocode.district]; // 直辖市时获取此字段
                }
                weakSelf.eventCity = city;
            }
            else {
                NSLog(@"lat:%f;lon:%f \n accuracy:%.2fm", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
                
                weakSelf.latitude = location.coordinate.latitude;
                weakSelf.longitude = location.coordinate.longitude;
            }
            
            GlobalData.userModel.latitude = location.coordinate.latitude;
            GlobalData.userModel.longitude = location.coordinate.longitude;
        }
    };
}

#pragma mark - Action Handle

- (void)configLocationManager {
    self.locationManager = [[AMapLocationManager alloc] init];
    
    [self.locationManager setDelegate:self];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    [self.locationManager setLocationTimeout:DefaultLocationTimeout];
    [self.locationManager setReGeocodeTimeout:DefaultReGeocodeTimeout];
}

- (void)cleanUpAction {
    [self.locationManager stopUpdatingLocation];
    
    [self.locationManager setDelegate:nil];
}

- (void)reGeocodeAction {
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:self.completionBlock];
}

- (void)locAction {
    [self.locationManager requestLocationWithReGeocode:NO completionBlock:self.completionBlock];
}

@end
#undef AtAspectOfClass
#undef AtAspect
