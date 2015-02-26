//
//  MyCell.m
//  表格
//
//  Created by zzy on 14-5-6.
//  Copyright (c) 2014年 zzy. All rights reserved.
//


#import "MyCell.h"
#import "HeadView.h"
#import "SessionModel.h"
#import "Defines.h"
#import "ReservationSuborder.h"

#define kWidthMargin 1
#define kHeightMargin 1

@interface MyCell()<HeadViewDelegate>

@end

@implementation MyCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withSubCellCount:(NSInteger)subCellCount
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        for(int i=0; i<subCellCount; i++){
        
            HeadView *headView=[[HeadView alloc]initWithFrame:CGRectMake(i*kReservationCellWidth, 0, kReservationCellWidth-kWidthMargin, kReservationCellHeight-kHeightMargin)];
            headView.delegate=self;
            headView.sportFieldIndex = i;
            [self.contentView addSubview:headView];
        }
        [self setBackgroundColor:[UIColor redColor]];
    }
    return self;
}
-(void)headView:(HeadView *)headView isSelected:(BOOL)selected
{
    if([self.delegate respondsToSelector:@selector(selectingIsChanged:withTime:withSportField:)]){
        [self.delegate selectingIsChanged:selected withTime:_currentTime withSportField:headView.sportFieldIndex];
    }

}

- (void)reloadDataWithReservatedSession:(NSArray *)sessions{
    for (HeadView * headView in self.contentView.subviews) {
        headView.isReservationable = TRUE;
    }
    
    for (SessionModel *session in sessions) {
        if (session.sessionTime == _currentTime) {
            HeadView *headView = (HeadView *)self.contentView.subviews[session.sportFieldIndex];
            headView.isReservationable = FALSE;
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
