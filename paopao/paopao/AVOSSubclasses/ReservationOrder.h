//
//  ReservationOrder.h
//  paopao
//
//  Created by TsaoLipeng on 15/2/22.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>
#import "Stadium.h"

@interface ReservationOrder : AVObject<AVSubclassing>

@property (nonatomic, strong) NSDate *generateDateTime;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, weak) Stadium *stadium;
@property (nonatomic, strong) NSString *pingppOrderID;
@property (nonatomic, strong) AVRelation *suborders;
@property (nonatomic, strong) NSDate *payDateTime;
@property (nonatomic, strong) NSNumber *paymentChannel;
@property (nonatomic, strong) NSNumber *amount;
@property (nonatomic, weak) AVUser *user;

@end
