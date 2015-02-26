//
//  HeadView.h
//  表格
//
//  Created by zzy on 14-5-5.
//  Copyright (c) 2014年 zzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HeadView;

@protocol HeadViewDelegate <NSObject>

-(void)headView:(HeadView *)headView isSelected:(BOOL)selected;

@end

@interface HeadView : UIView {
    BOOL isReservationable;
}
@property (nonatomic,strong) NSString *name;
@property (nonatomic) NSInteger sportFieldIndex;
@property (nonatomic,assign) id <HeadViewDelegate> delegate;

- (void)setIsReservationable:(BOOL)value;

@end
