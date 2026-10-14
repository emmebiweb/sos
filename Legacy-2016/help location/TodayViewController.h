//
//  TodayViewController.h
//  help location
//
//  Created by Eastern on 10/27/15.
//  Copyright © 2015 Nguyen Hoang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface TodayViewController : UIViewController<CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UILabel *widgetTitle;
@property (weak, nonatomic) IBOutlet UILabel *lat;
@property (weak, nonatomic) IBOutlet UILabel *lng;
@property (strong, nonatomic) CLLocationManager *locationManager;
@end
