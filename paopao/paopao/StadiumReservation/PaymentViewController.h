//
//  PaymentViewController.h
//  paopao
//
//  Created by TsaoLipeng on 15/2/27.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReservationOrder.h"

@interface PaymentViewController : UIViewController

- (instancetype)initWithReservationOrder:(ReservationOrder *)order;

@end
