//
//  ScheduleHorizontalMenuCell.m
//  paopao
//
//  Created by TsaoLipeng on 15/2/21.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import "ScheduleHorizontalMenuCell.h"
#import<QuartzCore/QuartzCore.h>
#import "UIView+XD.h"
#import "Stadium.h"
#import "ReservationSuborder.h"

@implementation ScheduleHorizontalMenuCell

- (instancetype)initWithOriginX:(CGFloat)x withOriginY:(CGFloat)y {
    self = [super initWithFrame:CGRectMake(x, y, kScheduleHorizontalMenuCellWidth, kScheduleHorizontalMenuCellHeight)];
    [self setBackgroundColor:[UIColor whiteColor]];
    //设置圆角边框
    self.layer.cornerRadius = 4;
    self.layer.masksToBounds = YES;
    //设置边框及边框颜色
    self.layer.borderWidth = 0;
    //self.layer.borderColor =[ [UIColor lightGrayColor] CGColor];
    return self;
}

- (void)initializeWithStadium:(Stadium *)stadium withDate:(NSDate *)date {
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 8, kScheduleHorizontalMenuCellWidth, 15)];
    [dateLabel setTextAlignment:NSTextAlignmentCenter];
    [dateLabel setTextColor:[UIColor grayColor]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if (![self date:[NSDate date] isEqualOtherDate:date]) {
        [dateFormatter setDateFormat:@"EEE/M.d"];
    } else {
        [dateFormatter setDateFormat:@"今天/M.d"];
    }
    [dateLabel setText:[dateFormatter stringFromDate:date]];
    [self addSubview:dateLabel];
    
    UILabel *remainCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, dateLabel.frame.origin.y + dateLabel.height + 4, kScheduleHorizontalMenuCellWidth, 15)];
    [remainCountLabel setTextColor:[UIColor lightGrayColor]];
    [remainCountLabel setFont:[UIFont systemFontOfSize:12]];
    [remainCountLabel setTextAlignment:NSTextAlignmentCenter];
    AVQuery *query = [ReservationSuborder query];
    [query whereKey:@"stadium" equalTo:stadium];
    [query whereKey:@"date" equalTo:date];
    [query countObjectsInBackgroundWithBlock:^(NSInteger number, NSError *error) {
        if (!error) {
            [remainCountLabel setText:[NSString stringWithFormat:@"空场 %ld/%ld", stadium.availableSessionCount - number, stadium.availableSessionCount]];
        }
    }];
    [self addSubview:remainCountLabel];
    
    UILabel *reservationButtonLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, remainCountLabel.frame.origin.y + remainCountLabel.height + 9, 78, 24)];
    [reservationButtonLabel setBackgroundColor:[UIColor orangeColor]];
    [reservationButtonLabel setTextColor:[UIColor whiteColor]];
    [reservationButtonLabel setFont:[UIFont systemFontOfSize:15]];
    [reservationButtonLabel setTextAlignment:NSTextAlignmentCenter];
    [reservationButtonLabel setText:@"预订"];
    reservationButtonLabel.layer.cornerRadius = 4;
    reservationButtonLabel.layer.masksToBounds = YES;
    [self addSubview:reservationButtonLabel];
}

- (BOOL)date:(NSDate *)date isEqualOtherDate:(NSDate *)aDate
{
    if (aDate == nil || date == nil) return NO;
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:(NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:date];
    NSDate *today = [cal dateFromComponents:components];
    components = [cal components:(NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:aDate];
    NSDate *otherDate = [cal dateFromComponents:components];
    if([today isEqualToDate:otherDate])
        return YES;
    
    return NO;
}

@end
