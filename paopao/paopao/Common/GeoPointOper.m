//
//  GeoPointOper.m
//  paopao
//
//  Created by TsaoLipeng on 15/2/3.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import "GeoPointOper.h"
#import "ShareInstances.h"

@implementation GeoPointOper

+ (CLLocationDistance)getDistanceFromOrigin:(CLLocation *)origin toDest:(CLLocation *)dest {
    return [origin distanceFromLocation:dest] / 1000;
}

+ (CLLocationDistance)getDIstanceFromHereToAVDest:(AVGeoPoint *)dest {
    CLLocation *origin = [ShareInstances getLastLocation];
    CLLocation *cdest = [[CLLocation alloc] initWithLatitude:dest.latitude longitude:dest.longitude];
    return [self getDistanceFromOrigin:origin toDest:cdest];
}

@end
