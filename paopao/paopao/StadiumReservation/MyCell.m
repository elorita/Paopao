//
//  MyCell.m
//  表格
//
//  Created by zzy on 14-5-6.
//  Copyright (c) 2014年 zzy. All rights reserved.
//


#import "MyCell.h"
#import "SubCell.h"
#import "SessionModel.h"
#import "Defines.h"
#import "ReservationSuborder.h"
#import "sportField.h"
#import "DateTimeHelper.h"

#define kWidthMargin 1
#define kHeightMargin 1

@interface MyCell()<SubCellDelegate>

@property (nonatomic) NSInteger currentTime;
@property (nonatomic, strong) NSDate *selectedDate;

@end

@implementation MyCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withSportFieldsCount:(NSInteger)spCount //withSportFields:(NSArray *)sportFields withDate:(NSDate *)date withTime:(NSInteger)time;
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        for(int i=0; i<spCount; i++){
        
            SubCell *subCell=[[SubCell alloc]initWithFrame:CGRectMake(i*kReservationCellWidth, 0, kReservationCellWidth-kMyCellWidthMargin, kReservationCellHeight-kMyCellHeightMargin) isHeadCell:NO];
            subCell.delegate=self;
            subCell.sportFieldIndex = i;
            [self.contentView addSubview:subCell];
        }
        [self setBackgroundColor:[UIColor redColor]];
    }
    return self;
}
-(void)subCell:(SubCell *)subCell isSelected:(BOOL)selected
{
    if([self.delegate respondsToSelector:@selector(selectingIsChanged:withTime:withSportField:)]){
        [self.delegate selectingIsChanged:selected withTime:_currentTime withSportField:subCell.sportFieldIndex];
    }

}
- (void)reloadPriceWithSportFields:(NSArray *)sportFields withDate:(NSDate *)date withTime:(NSInteger)time{
    _currentTime = time;
    _selectedDate = date;
    for(int i=0; i<sportFields.count; i++){
        SubCell *subCell=[self findSubCellWithSprotFieldIndex:i];//(SubCell *)self.contentView.subviews[i];
        NSInteger price = 0;
        if (time < 24) {//有效cell的最大小时数肯定只能为24
            SportField *sp = [sportFields objectAtIndex:i];
            if ([DateTimeHelper isWorkingDay:date])
                price = [[sp.normalPrices objectAtIndex:_currentTime] integerValue];
            else
                price = [[sp.holidayPrices objectAtIndex:_currentTime] integerValue];
            subCell.name = [NSString stringWithFormat:@"￥%ld", price];
        }
        [self.contentView addSubview:subCell];
    }
}
- (void)reloadDataWithReservatedSession:(NSArray *)sessions{
    NSDate *today = [NSDate date];
    NSInteger hour = [[DateTimeHelper getDateComponents:today] hour];
    if ([DateTimeHelper date:today isEqualOtherDate:_selectedDate] &&
        _currentTime < hour + 2) {//提前两小时停止订场 todo:把提前值写进Stadium设置中
        for (SubCell * subCell in self.contentView.subviews) {
            subCell.isReservationable = FALSE;
        }
    } else {
        for (SubCell * subCell in self.contentView.subviews) {
            subCell.isReservationable = TRUE;
        }
    }
    
    for (SessionModel *session in sessions) {
        if (session.sessionTime == _currentTime) {
            SubCell *subCell = (SubCell *)self.contentView.subviews[session.sportFieldIndex];
            subCell.isReservationable = FALSE;
            //headView.name = [NSString stringWithFormat:@"￥%ld元", session.price];
        }
    }
}
- (SubCell *)findSubCellWithSprotFieldIndex:(NSInteger)spIndex {
    for (SubCell *cell in self.contentView.subviews) {
        if (cell.sportFieldIndex == spIndex)
            return cell;
    }
    return nil;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
