//
//  ViewController.m
//  paopao
//
//  Created by TsaoLipeng on 15/1/28.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import "RootViewController.h"
#import "MenuView.h"
#import <AVOSCloud/AVOSCloud.h>
#import "CommonMainMenu.h"
#import "Defines.h"

@interface RootViewController () <CommonMainMenuDelegate> {
    CommonMenu *mainMenu;
    UIView *navigationBar;
    UIScrollView *scrollView;
    UILabel *titleLabel;
}

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initNavigationBar];
    
    if (scrollView == nil) {
        CGRect scrollViewFrame = CGRectMake(0, NAVIGATION_BAR_HEIGHT + STATU_BAR_HEIGHT, self.view.frame.size.width, self.view.frame.size.height);
        scrollView = [[UIScrollView alloc] initWithFrame:scrollViewFrame];
        [self.view addSubview:scrollView];
    }
    
    if (mainMenu == nil) {
        mainMenu = [[CommonMenu alloc] initWithRootController:self];
        mainMenu.delegate = self;
        [self.view addSubview:mainMenu.sideSlipView];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initNavigationBar {
    if (navigationBar == nil) {
        CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, STATU_BAR_HEIGHT + NAVIGATION_BAR_HEIGHT);
        navigationBar = [[UIView alloc] initWithFrame:frame];
        [self.view addSubview:navigationBar];
        
        UIButton *showMenuButton = [[UIButton alloc] initWithFrame:CGRectMake(0, STATU_BAR_HEIGHT, NAVIGATION_BUTTON_RESPONSE_WIDTH, NAVIGATION_BUTTON_HEIGHT)];
        [showMenuButton setImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
        [showMenuButton setImageEdgeInsets:UIEdgeInsetsMake(0, NAVIGATION_LBUTTON_MARGIN_LEFT, 0, NAVIGATION_BUTTON_RESPONSE_WIDTH-NAVIGATION_LBUTTON_MARGIN_LEFT-NAVIGATION_BUTTON_WIDTH)];
        [showMenuButton addTarget:self action:@selector(doPopMainMenu:) forControlEvents:UIControlEventTouchUpInside];
        [showMenuButton setContentMode:UIViewContentModeLeft];
        [self->navigationBar addSubview:showMenuButton];
        
        UIButton *searchButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.origin.x + self.view.frame.size.width - NAVIGATION_BUTTON_RESPONSE_WIDTH, STATU_BAR_HEIGHT,NAVIGATION_BUTTON_RESPONSE_WIDTH, NAVIGATION_BUTTON_HEIGHT)];
        [searchButton setImage:[UIImage imageNamed:@"search.png"] forState:UIControlStateNormal];
        [searchButton setImageEdgeInsets:UIEdgeInsetsMake(0, NAVIGATION_BUTTON_RESPONSE_WIDTH-NAVIGATION_RBUTTON_MARGIN_RIGHT-NAVIGATION_BUTTON_WIDTH, 0, NAVIGATION_RBUTTON_MARGIN_RIGHT)];
        [searchButton addTarget:self action:@selector(doPopMainMenu:) forControlEvents:UIControlEventTouchUpInside];
        [self->navigationBar addSubview:searchButton];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.origin.x + (self.view.frame.size.width - NAVIGATION_TITLE_WIDTH) / 2, STATU_BAR_HEIGHT, NAVIGATION_TITLE_WIDTH, NAVIGATION_TITLE_HEIGHT)];
        [titleLabel setTextColor:[UIColor darkTextColor]];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [self->navigationBar addSubview:titleLabel];
    }
}

- (void)doPopMainMenu:(id)sender {
    [self->mainMenu.sideSlipView show];
}

#pragma mark CommonMainMenuDelegate
-(void)ShowView:(UIView *)newView withTitle:(NSString *)title withRemoveLastView:(UIView *)lastView {
    [scrollView addSubview:newView];
    [lastView removeFromSuperview];
    
    [self->titleLabel setText:title];
}

@end
