//
//  TodayViewController.m
//  help location
//
//  Created by Eastern on 10/27/15.
//  Copyright © 2015 Nguyen Hoang. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController () <NCWidgetProviding>

@end

float lng;
float lat;

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.button.clipsToBounds = YES;
    self.button.layer.cornerRadius = 8;
    [self.button addTarget:self action:@selector(sendHelp) forControlEvents:UIControlEventTouchUpInside];
    self.preferredContentSize = CGSizeMake(320, 117);
    
    //Set up location manager and start monitoring location
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        [_locationManager requestWhenInUseAuthorization];
    }
    
    [_locationManager startMonitoringSignificantLocationChanges];
    lng = _locationManager.location.coordinate.longitude;
    lat = _locationManager.location.coordinate.latitude;
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    lng = manager.location.coordinate.longitude;
    lat = manager.location.coordinate.latitude;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    self.preferredContentSize = CGSizeMake(320, 117);
    CLGeocoder *ceo = [[CLGeocoder alloc]init];
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:lat longitude:lng];
    self.lat.text = [NSString stringWithFormat:@"%f", lat];
    self.lng.text = [NSString stringWithFormat:@"%f", lng];
    
    [ceo reverseGeocodeLocation: loc completionHandler:
     ^(NSArray *placemarks, NSError *error) {
         CLPlacemark *placemark = [placemarks objectAtIndex:0];
         NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
         self.widgetTitle.text = locatedAt;
         
     }];
    completionHandler(NCUpdateResultNewData);
    self.button.hidden = NO;
}

-(void) sendHelp{
    NSURL *url = [NSURL URLWithString:@"soshelp://"];
    [self.extensionContext openURL:url completionHandler:nil];
}

@end
