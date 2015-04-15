//
//  GIGGeolocation.m
//  ClubVips
//
//  Created by Sergio Baró on 18/03/14.
//  Copyright (c) 2014 gigigo. All rights reserved.
//

#import "GIGGeolocation.h"


@interface GIGGeolocation ()
<CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (copy, nonatomic) GIGGeolocationCompletion completion;

@end


@implementation GIGGeolocation

- (instancetype)init
{
	self = [super init];
	if (self != nil)
	{
		self.locationManager = [[CLLocationManager alloc] init];
		self.locationManager.delegate = self;
	}
	return self;
}

#pragma mark - Public

- (void)locateCompletion:(GIGGeolocationCompletion)completion
{
    self.completion = completion;
    [self start];
}

#pragma mark - Private

- (void)start
{
    if ([CLLocationManager locationServicesEnabled])
    {
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
        {
            [self.locationManager requestWhenInUseAuthorization];
        }
        
        [self.locationManager startUpdatingLocation];
    }
}

- (void)updateLocation:(CLLocation *)location
{
    if (self.completion)
    {
        self.completion(YES, YES, location, nil);
    }
    
    [self stop];
}

- (void)stop
{
    self.completion = nil;
    [self.locationManager stopUpdatingLocation];
}

#pragma mark - Private

- (BOOL)isAuthorizedStatus:(CLAuthorizationStatus)status
{
    return (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusAuthorized);
}

#pragma mark - CLLocationManager Delegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if ([self isAuthorizedStatus:status])
    {
        [self.locationManager startUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
	[self updateLocation:newLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
	[self updateLocation:[locations lastObject]];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if (self.completion)
    {
        BOOL authorized = [self isAuthorizedStatus:CLLocationManager.authorizationStatus];
        if (self.locationManager.location)
        {
            self.completion(YES, authorized, self.locationManager.location, error);
        }
        else
        {
            self.completion(NO, authorized, nil, error);
        }
    }
    
    [self stop];
}

@end
