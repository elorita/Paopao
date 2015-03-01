//
//  MyCell.h
//  表格
//
//  Created by zzy on 14-5-6.
//  Copyright (c) 2014年 zzy. All rights reserved.
//
#define kMyCellWidthMargin 1
#define kMyCellHeightMargin 1
#import <UIKit/UIKit.h>

@class MyCell,HeadView,MeetModel;

@protocol MyCellDelegate <NSObject>

-(void)selectingIsChanged:(BOOL)selected withTime:(NSInteger)time withSportField:(NSInteger)sportFieldIndex;

@end

@interface MyCell : UITableViewCell
@property (nonatomic,assign) id<MyCellDelegate> delegate;
@property (nonatomic,assign) int index;

- (void)reloadDataWithReservatedSession:(NSArray *)sessions;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withSportFieldsCount:(NSInteger)spCount;// withSportFields:(NSArray *)sportFields withDate:(NSDate *)date withTime:(NSInteger)time;
- (void)reloadPriceWithSportFields:(NSArray *)sportFields withDate:(NSDate *)date withTime:(NSInteger)time;
@end
