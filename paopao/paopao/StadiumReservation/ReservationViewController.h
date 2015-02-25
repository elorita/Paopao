//
//  ViewController.h
//  表格
//
//  Created by zzy on 14-5-5.
//  Copyright (c) 2014年 zzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Stadium.h"

@interface ReservationViewController : UIViewController {
    NSInteger originSelectedDateIndex;
}

- (void)setOriginSelectedDateIndex:(NSInteger)index;

- (instancetype)initWithStadium:(Stadium *)stadium;

@end
