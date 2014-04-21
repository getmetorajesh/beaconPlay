//
//  ViewController.m
//  Beacon
//
//  Created by RJ on 21/04/2014.
//  Copyright (c) 2014 Techiepandas. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>

#define BEACON_UUID @"1BE93D24-67F3-4552-A592-A6FD1F62865D"

@interface ViewController ()<CLLocationManagerDelegate>
@property(nonatomic,strong)CLLocationManager *locationManager;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate =self;
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:BEACON_UUID];
    CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:@"com.techiepandas.beacon"];
    region.notifyOnExit =YES;
    region.notifyOnEntry =YES;
    region.notifyEntryStateOnDisplay =YES;
    
    [self.locationManager startMonitoringForRegion:region];
    
    [self.locationManager requestStateForRegion:region];
}

#pragma mark - CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region{
    if(state== CLRegionStateInside){
        CLBeaconRegion *beaconRegion = (CLBeaconRegion *)region;
        [self.locationManager startRangingBeaconsInRegion:beaconRegion];
    }
 }

-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region{
    
    if([region isKindOfClass:[CLBeaconRegion class]]){
        CLBeaconRegion *beaconRegion =  (CLBeaconRegion *)region;
        if([beaconRegion.identifier isEqualToString:@"com.techiepandas.beacon"]){
            [self.locationManager startRangingBeaconsInRegion:beaconRegion];
        }
    }
}


-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region{
    
    if([region isKindOfClass:[CLBeaconRegion class]]){
        CLBeaconRegion *beaconRegion =  (CLBeaconRegion *)region;
        if([beaconRegion.identifier isEqualToString:@"com.techiepandas.beacon"]){
            [self.locationManager stopRangingBeaconsInRegion:beaconRegion];
        }
    }
}


-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region{

    for(CLBeacon *beacon in beacons){
        NSLog(@"ranging beacon: %@",beacon.proximityUUID);
        NSLog(@"Minor - major: %@- %@", beacon.major, beacon.minor);
        NSLog(@"[self stringForProximity:beacon.proximity]: %@",[self stringForProximity:beacon.proximity]);
        
        [self setColorForProximity:beacon.proximity];
    }
}

-(NSString *)stringForProximity:(CLProximity)proximity{
    switch(proximity){
        case CLProximityUnknown: return @"Unknown";
        case CLProximityFar: return @"far";
        case CLProximityImmediate: return @"Immediate";
        case CLProximityNear: return @"near";
    }
}


-(void)setColorForProximity:(CLProximity)proximity {
    switch(proximity){
        case CLProximityUnknown:
            self.view.backgroundColor = [UIColor whiteColor];
        case CLProximityNear:
            self.view.backgroundColor = [UIColor orangeColor];
        case CLProximityImmediate:
            self.view.backgroundColor = [UIColor yellowColor];
        case CLProximityFar:
            self.view.backgroundColor =[UIColor redColor];
        default:
            break;
    }
}


@end
