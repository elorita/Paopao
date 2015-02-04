//
//  GeoPointOper.h
//  paopao
//
//  Created by TsaoLipeng on 15/2/3.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <AVOSCloud/AVOSCloud.h>

@interface GeoPointOper : NSObject

+ (CLLocationDistance)getDistanceFromOrigin:(CLLocation *)origin toDest:(CLLocation *)dest;

+ (CLLocationDistance)getDIstanceFromHereToAVDest:(AVGeoPoint *)dest;

@end
