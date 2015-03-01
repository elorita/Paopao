//
//  HeadView.h
//  表格
//
//  Created by zzy on 14-5-5.
//  Copyright (c) 2014年 zzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SubCell;

@protocol SubCellDelegate <NSObject>

-(void)subCell:(SubCell *)subCell isSelected:(BOOL)selected;

@end

@interface SubCell : UIView {
    BOOL isReservationable;
}
@property (nonatomic,strong) NSString *name;
@property (nonatomic) NSInteger sportFieldIndex;
@property (nonatomic,assign) id <SubCellDelegate> delegate;

- (id)initWithFrame:(CGRect)frame isHeadCell:(BOOL)isHeadCell;
- (void)setIsReservationable:(BOOL)value;

@end
