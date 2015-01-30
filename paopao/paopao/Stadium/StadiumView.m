//
//  StadiumViewController.m
//  paopao
//
//  Created by TsaoLipeng on 15/1/29.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import "StadiumView.h"
#import "CustomTableView.h"
#import "StadiumTableViewDND.h"
#import "Defines.h"

@interface StadiumView () {
    CustomTableView *stadiumTableView;
    StadiumTableViewDND *stadiumTableViewDND;
    UIView *navigationBar;
    UIScrollView *scrollView;
}

@end

@implementation StadiumView

- (id)initWithFrame:(CGRect)frame withController:(UIViewController *)controller {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.homeViewController = controller;
        [self initialize];
    }
    return self;
}

- (void)initialize {
    if (scrollView == nil) {
        CGRect scrollViewFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        scrollView = [[UIScrollView alloc] initWithFrame:scrollViewFrame];
        [self addSubview:scrollView];
    }
    if (stadiumTableViewDND == nil)
        stadiumTableViewDND = [[StadiumTableViewDND alloc] init];
    if (stadiumTableView == nil)
        stadiumTableView = [[CustomTableView alloc] initWithFrame:self->scrollView.frame];
    
    stadiumTableView.delegate = stadiumTableViewDND;
    stadiumTableView.dataSource = stadiumTableViewDND;
    stadiumTableView.backgroundColor = [UIColor redColor];
    [self->scrollView addSubview:stadiumTableView];
    
    [stadiumTableView forceToFreshData];
}

@end
