//
//  TimeView.h
//  表格
//
//  Created by zzy on 14-5-6.
//  Copyright (c) 2014年 zzy. All rights reserved.
//
#define kHeightMargin 3
#import <UIKit/UIKit.h>

@interface TimeView : UIView
@property (nonatomic,strong) UITableView *timeTableView;

- (id)initWithFrame:(CGRect)frame withBeginTime:(NSInteger)beginTime withEndTime:(NSInteger)endTime;
@end
