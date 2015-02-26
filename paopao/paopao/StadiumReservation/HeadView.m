//
//  HeadView.m
//  表格
//
//  Created by zzy on 14-5-5.
//  Copyright (c) 2014年 zzy. All rights reserved.
//
#import "HeadView.h"
#import "Defines.h"

@interface HeadView() {
    BOOL isSelected;
}
@property (nonatomic,strong) UILabel *nameLabel;
@end

@implementation HeadView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        isSelected = NO;
        isReservationable = YES;
        [self resetBackground];
        
        self.nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height*0.5)];
        self.nameLabel.textAlignment=NSTextAlignmentCenter;
        self.nameLabel.textColor = [UIColor grayColor];
        self.nameLabel.font = [UIFont systemFontOfSize:13];
        self.nameLabel.center=CGPointMake(self.frame.size.width*0.5, self.frame.size.height*0.5);
        [self addSubview:self.nameLabel];
        
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView:)]];
    }
    return self;
}
-(void)tapView:(UITapGestureRecognizer *)tap
{
    if(isReservationable && [self.delegate respondsToSelector:@selector(headView:isSelected:)]){
        isSelected = !isSelected;
        if (isSelected)
            [self setBackgroundColor:[UIColor orangeColor]];
        else
            [self resetBackground];
        [self.delegate headView:self isSelected:isSelected];
    }
    
}
- (void)setIsReservationable:(BOOL)value{
    isReservationable = value;
    isSelected = NO;
    [self resetBackground];
}
- (void)resetBackground {
    if (isReservationable)
        [self setBackgroundColor:MAIN_COLOR];
    else
        [self setBackgroundColor:DARK_BACKGROUND_COLOR];
}
-(void)setName:(NSString *)name
{
    _name=name;
    self.nameLabel.text=name;
}
@end
