//
//  ReservationOrder.m
//  paopao
//
//  Created by TsaoLipeng on 15/2/22.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import "ReservationOrder.h"

@implementation ReservationOrder

@synthesize generateDateTime, date, stadium, payDateTime, suborders, paymentChannel, pingppOrderID, user;

+ (NSString *)parseClassName {
    return @"reservationOrder";
}

@end
