//
//  HeadView.m
//  表格
//
//  Created by zzy on 14-5-5.
//  Copyright (c) 2014年 zzy. All rights reserved.
//
#import "HeadView.h"

@interface HeadView()
@property (nonatomic,strong) UILabel *nameLabel;
@end

@implementation HeadView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height*0.5)];
        self.nameLabel.textAlignment=NSTextAlignmentCenter;
        self.nameLabel.center=CGPointMake(self.frame.size.width*0.5, self.frame.size.height*0.5);
        [self addSubview:self.nameLabel];
        
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView:)]];
    }
    return self;
}
-(void)tapView:(UITapGestureRecognizer *)tap
{
    CGPoint point=[tap locationInView:self];
    
    if([self.delegate respondsToSelector:@selector(headView:point:)]){
    
        [self.delegate headView:self point:point];
    }
    
}
-(void)setName:(NSString *)name
{
    _name=name;
    self.nameLabel.text=name;
}
@end
