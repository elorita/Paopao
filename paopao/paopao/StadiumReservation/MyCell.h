//
//  MyCell.h
//  表格
//
//  Created by zzy on 14-5-6.
//  Copyright (c) 2014年 zzy. All rights reserved.
//
#define kWidthMargin 1
#define kHeightMargin 1
#import <UIKit/UIKit.h>

@class MyCell,HeadView,MeetModel;

@protocol MyCellDelegate <NSObject>

-(void)selectingIsChanged:(BOOL)selected withTime:(NSInteger)time withSportField:(NSInteger)sportFieldIndex;

@end

@interface MyCell : UITableViewCell
@property (nonatomic,assign) id<MyCellDelegate> delegate;
@property (nonatomic) NSInteger currentTime;
@property (nonatomic,assign) int index;

- (void)reloadDataWithReservatedSession:(NSArray *)sessions;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withSubCellCount:(NSInteger)subCellCount;
@end
