//
//  NormalNavigationBar.m
//  paopao
//
//  Created by TsaoLipeng on 15/1/30.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import "NormalNavigationBar.h"
#import "Defines.h"

@implementation NormalNavigationBar

- (instancetype)initWithTitle:(NSString *)title {
    self = [super init];
    CGRect bounds = [[UIScreen mainScreen] bounds];
    [self setFrame:CGRectMake(0, 0, bounds.size.width, STATU_BAR_HEIGHT + NAVIGATION_BAR_HEIGHT)];
    
    UIImageView *background = [[UIImageView alloc] initWithFrame:self.frame];
    [background setImage:[UIImage imageNamed:@"navigationBackground.png"]];
    [self addSubview:background];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, STATU_BAR_HEIGHT, NAVIGATION_BUTTON_RESPONSE_WIDTH, NAVIGATION_BUTTON_HEIGHT)];
    [backButton setImage:[UIImage imageNamed:@"back_normal.png"] forState:UIControlStateNormal];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, NAVIGATION_LBUTTON_MARGIN_LEFT, 0, NAVIGATION_BUTTON_RESPONSE_WIDTH-NAVIGATION_LBUTTON_MARGIN_LEFT-NAVIGATION_BUTTON_WIDTH)];
    [backButton addTarget:self action:@selector(doBack:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setContentMode:UIViewContentModeLeft];
    [self addSubview:backButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.origin.x + (self.frame.size.width - NAVIGATION_TITLE_WIDTH) / 2, STATU_BAR_HEIGHT, NAVIGATION_TITLE_WIDTH, NAVIGATION_TITLE_HEIGHT)];
    [titleLabel setText:title];
    [titleLabel setTextColor:[UIColor darkTextColor]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:titleLabel];
    
    return self;
}

- (void)doBack:(id)sender {
    if ([_delegate respondsToSelector:@selector(doReturn)]) {
        [_delegate doReturn];
    }
}

@end
