//
//  ViewController.m
//  Velocity Tracker
//
//  Created by Pietro Sacco on 17.11.15.
//  Copyright © 2015 Pietro Sacco. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@property (nonatomic) NSInteger currentVelocity;
@property (nonatomic) NSInteger topVelocity;
@property (nonatomic) CLLocationManager *locationManager;

@property (weak, nonatomic) IBOutlet UILabel *currentVelocityLabel;
@property (weak, nonatomic) IBOutlet UILabel *topVelocityLabel;

- (void)initialize;
- (void)updateLabels;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    // For testing purposes
//    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(fakeVelocity) userInfo:nil repeats:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initialize];
    [self updateLabels];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Private methods


- (void)initialize
{
    self.currentVelocity = 0;
    self.topVelocity = 0;
    
    if ( self.locationManager == nil ) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.activityType = CLActivityTypeOtherNavigation;
        [self.locationManager requestWhenInUseAuthorization];
    }
}

- (void)updateLabels
{
    self.currentVelocityLabel.text = [NSString stringWithFormat:@"%li", (long)self.currentVelocity];
    self.topVelocityLabel.text = [NSString stringWithFormat:@"%li", (long)self.topVelocity];
}


#pragma mark - Location manager delegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    NSLog(@"didChangeAuthorizationStatus: %i", status);
    switch ([CLLocationManager authorizationStatus]) {
        case kCLAuthorizationStatusNotDetermined:
            break;
        case kCLAuthorizationStatusDenied:
        case kCLAuthorizationStatusRestricted:
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Location Services Unavailable" message:@"Please activate location services for this app in Settings > Privacy > Location Services." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
            break;
        default:
            [self.locationManager startUpdatingLocation];
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    NSLog(@"%@", locations.description);
    CLLocation *location = locations.lastObject;
    self.currentVelocity = location.speed * 3.6;
    if (self.topVelocity < self.currentVelocity) self.topVelocity = self.currentVelocity;
    [self updateLabels];
}

@end
