//
//  SexSelectionViewController.m
//  paopao
//
//  Created by TsaoLipeng on 15/3/31.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import "SexSelectionViewController.h"
#import "NormalNavigationBar.h"
#import "Defines.h"
#import "UIView+XD.h"

@interface SexSelectionViewController()<NormalNavigationDelegate>

@property (nonatomic, strong) NormalNavigationBar *navigationBar;
@property (nonatomic, strong) UILabel *maleLabel;
@property (nonatomic, strong) UILabel *femaleLabel;
@property (nonatomic, strong) UIView *maleView;
@property (nonatomic, strong) UIView *femaleView;
@property (nonatomic, strong) UIImageView *rightIcon;

@end

@implementation SexSelectionViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:NORMAL_BACKGROUND_COLOR];
    
    _navigationBar = [[NormalNavigationBar alloc] initWithTitle:@"选择性别"];
    self.navigationBar.delegate = self;
    [self.view addSubview:self.navigationBar];
    
    _maleView = [[UIView alloc] initWithFrame:CGRectMake(10, _navigationBar.bottom + 10, self.view.width - 20, 44)];
    [_maleView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_maleView];
    _femaleView = [[UIView alloc] initWithFrame:CGRectMake(10, _maleView.bottom + 0.5f, self.view.width - 20, 44)];
    [_femaleView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_femaleView];
    
    _maleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 50, 14)];
    [_maleLabel setFont:[UIFont systemFontOfSize:14]];
    [_maleLabel setTextColor:NORMAL_TEXT_COLOR];
    [_maleLabel setText:@"男"];
    [_maleLabel setTextAlignment:NSTextAlignmentCenter];
    [_maleView addSubview:_maleLabel];
    
    _femaleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 50, 14)];
    [_femaleLabel setFont:[UIFont systemFontOfSize:14]];
    [_femaleLabel setTextColor:NORMAL_TEXT_COLOR];
    [_femaleLabel setText:@"男"];
    [_femaleLabel setTextAlignment:NSTextAlignmentCenter];
    [_femaleView addSubview:_femaleLabel];
    
    //_rightIcon = [[UIImageView alloc] initWithFrame:(CGRect)]
}

#pragma mark NormalNavigationDelegate
- (void)doReturn {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
