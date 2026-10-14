//
//  ViewController.m
//  sos
//
//  Created by Eastern on 10/7/15.
//  Copyright © 2015 Nguyen Hoang. All rights reserved.
//

#import "ViewController.h"
#import <AudioToolbox/AudioServices.h>
#import "ContactViewController.h"

@interface ViewController ()

@end
float torchLevel;
BOOL waitForSend;
@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *filePath = [mainBundle pathForResource:@"sos" ofType:@"mp3"];
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithData:fileData error:nil];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive: YES error: nil];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    self.audioPlayer.numberOfLoops = -1;
    self.isPlaying = NO;
    waitForSend = NO;
    
    _mapView.delegate = self;
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    if(IS_OS_8_OR_LATER) {
        [self.locationManager requestWhenInUseAuthorization];
    }

    [self.locationManager startUpdatingLocation];
    
    _mapView.showsUserLocation = YES;
    [_mapView setMapType:MKMapTypeStandard];
    [_mapView setZoomEnabled:YES];
    [_mapView setScrollEnabled:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];

    
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    //NSLog(@"%@", [self deviceLocation]);
    
    //View Area
    MKCoordinateRegion region = { { 0.0, 0.0 }, { 0.0, 0.0 } };
    region.center.latitude = self.locationManager.location.coordinate.latitude;
    region.center.longitude = self.locationManager.location.coordinate.longitude;
    region.span.longitudeDelta = 0.005f;
    region.span.longitudeDelta = 0.005f;
    [_mapView setRegion:region animated:YES];
    //torchLevel = 0.0;
//    [NSTimer scheduledTimerWithTimeInterval:0.5
//                                     target:self
//                                   selector:@selector(setTorchToLevel)
//                                   userInfo:nil
//                                    repeats:YES];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(setting:)];
    [self.send addGestureRecognizer:longPress];
    
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    
    CLGeocoder *ceo = [[CLGeocoder alloc]init];
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:region.center.latitude longitude:region.center.longitude];
    [ceo reverseGeocodeLocation: loc completionHandler:
     ^(NSArray *placemarks, NSError *error) {
         CLPlacemark *placemark = [placemarks objectAtIndex:0];
         NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
         self.address.text = locatedAt;
         self.lat.text = [NSString stringWithFormat:@"%f",region.center.latitude];
         self.lng.text = [NSString stringWithFormat:@"%f",region.center.longitude];
         [self.loading stopAnimating];
         if (waitForSend) {
             [self send:nil];
             waitForSend = NO;
         }
     }];
}

- (NSString *)deviceLocation {
    return [NSString stringWithFormat:@"latitude: %f longitude: %f", self.locationManager.location.coordinate.latitude, self.locationManager.location.coordinate.longitude];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)play:(id)sender {
    if (self.isPlaying) {
        [self.audioPlayer pause];
    }else{
        [self.audioPlayer play];
    }
    self.isPlaying = !self.isPlaying;
}

- (IBAction)send:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];

    if (![self.lat.text isEqualToString:@"00.000000"]) {
        MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
        
        NSUserDefaults *user = [[NSUserDefaults alloc] init];
        NSString *msg = [user stringForKey:@"MSG"];
        
        if([MFMessageComposeViewController canSendText])
        {
            if (self.address.text) {
                controller.body = [NSString stringWithFormat:@"%@\n\n%@\nView map : http://maps.google.com/?q=%@,%@\n\nInviato dall' APP SOS by emmeBiweb",msg, self.address.text, self.lat.text, self.lng.text];
            }else{
                controller.body = [NSString stringWithFormat:@"%@\n\nView map : http://maps.google.com/?q=%@,%@\n\nInviato dall' APP SOS by emmeBiweb",msg, self.lat.text, self.lng.text];
            }
            NSUserDefaults *user = [[NSUserDefaults alloc] init];
            if ([user arrayForKey:@"CONTACT"]) {
                
                NSArray *data = [user arrayForKey:@"CONTACT"];
                NSMutableArray *recipients = [[NSMutableArray alloc] init];
                
                for (int i =0; i < [data count]; i++) {
                    
                    NSArray *foo = [data[i] componentsSeparatedByString: @" - "];
                    if ([foo count] > 0) {
                        NSString *phone = [foo objectAtIndex:foo.count - 1];
                        [recipients addObject:phone];
                    }
                }
                controller.recipients = recipients;
            }
            
            controller.messageComposeDelegate = self;
            [self presentViewController:controller animated:YES completion:nil];
        }
    }else{
        waitForSend = YES;
    }
    
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    if (result) {
        UIAlertView *v = [[UIAlertView alloc] initWithTitle:@"Attenzione" message:@"Invio messaggio riuscito!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [v show];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setTorchToLevel
{
    
    if (self.isPlaying) {
        if (torchLevel==0.0) {
            torchLevel = 1.0;
        }else
            torchLevel = 0.0;
        
    }else{
        torchLevel = 0.0;
    }
    
    NSLog(@"%f",torchLevel);
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch]) {
        [device lockForConfiguration:nil];
        if (torchLevel <= 0.0) {
            [device setTorchMode:AVCaptureTorchModeOff];
        }
        else {
            if (torchLevel >= 1.0)
                torchLevel = AVCaptureMaxAvailableTorchLevel;
            [device setTorchModeOnWithLevel:torchLevel   error:nil];
        }
        [device unlockForConfiguration];
    }
}

-(void) setting:(UILongPressGestureRecognizer*)gesture {
    if ( gesture.state == UIGestureRecognizerStateBegan ) {
        [self vibratePhone];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UINavigationController *contact = [storyboard instantiateViewControllerWithIdentifier:@"ContactNavigationController"];
        [self presentViewController:contact animated:YES completion:nil];
        
    }
}

- (void)vibratePhone;
{
    if([[UIDevice currentDevice].model isEqualToString:@"iPhone"])
    {
        AudioServicesPlaySystemSound (1352); //works ALWAYS as of this post
    }
    else
    {
        // Not an iPhone, so doesn't have vibrate
        // play the less annoying tick noise or one of your own
        AudioServicesPlayAlertSound (1105);
    }
}
@end
