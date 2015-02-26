//
//  OrderConfirmViewController.h
//  paopao
//
//  Created by TsaoLipeng on 15/2/26.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Stadium.h"

@interface OrderConfirmViewController : UIViewController

- (instancetype)initWithStadium:(Stadium *)stadium withOrderDate:(NSDate *)date withOrderedSessions:(NSArray *)sessions;

@end
