//
//  ViewController.m
//  paopao
//
//  Created by TsaoLipeng on 15/1/28.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import "RootViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import "SidebarViewController.h"
#import "Defines.h"
#import "SignInDelegate.h"
#import "LoginViewController.h"
#import "UserHomeViewController.h"
#import "StadiumView.h"

@interface RootViewController () <SignInDelegate, SidebarViewDelegate> { //<CommonMainMenuDelegate> {
    UIView *navigationBar;
    UIScrollView *scrollView;
    UILabel *titleLabel;
    UIView *currentActiveView;
}

@property (nonatomic, strong) SidebarViewController* sidebarVC;
@property (nonatomic, strong) StadiumView *stadiumView;

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
    
//    if (mainMenu == nil) {
//        mainMenu = [[CommonMenu alloc] initWithRootController:self];
//        mainMenu.delegate = self;
//        [self.view addSubview:mainMenu.sideSlipView];
//    }
    // 左侧边栏开始
    UIPanGestureRecognizer* panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panDetected:)];
    [panGesture delaysTouchesBegan];
    [self.view addGestureRecognizer:panGesture];
    
    self.sidebarVC = [[SidebarViewController alloc] init];
    [self.sidebarVC setBgRGB:0x000000];
    NSArray *items = @[@{@"title":@"场馆",@"imagenormal":@"stadium_normal.png",@"imagehighlight":@"stadium_highlight.png"},
                   @{@"title":@"团队",@"imagenormal":@"team_normal.png",@"imagehighlight":@"team_highlight.png"},
                   @{@"title":@"教练",@"imagenormal":@"coach_normal.png",@"imagehighlight":@"coach_highlight.png"},
                   @{@"title":@"赛事",@"imagenormal":@"competition_normal.png",@"imagehighlight":@"competition_highlight.png"},
                   @{@"title":@"资讯",@"imagenormal":@"news_normal.png",@"imagehighlight":@"news_highlight.png"},
                   @{@"title":@"设置",@"imagenormal":@"setting_normal.png",@"imagehighlight":@"setting_highlight.png"}];
    [self.sidebarVC setItems:items];
    self.sidebarVC.signInDelegate = self;
    self.sidebarVC.delegate = self;
    [self.view addSubview:self.sidebarVC.view];
    self.sidebarVC.view.frame  = self.view.bounds;
    // 左侧边栏结束
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)panDetected:(UIPanGestureRecognizer*)recoginzer
{
    [self.sidebarVC panDetected:recoginzer];
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
    [self.sidebarVC showHideSidebar];
}

#pragma mark CommonMainMenuDelegate
-(void)ShowView:(UIView *)newView withTitle:(NSString *)title withRemoveLastView:(UIView *)lastView {
    [scrollView addSubview:newView];
    [lastView removeFromSuperview];
    
    [self->titleLabel setText:title];
}

#pragma mark SidebarViewDelegate
- (void)menuItemSelectedOnIndex:(NSInteger)index {
    UIView *newView = nil;
    NSString *title = nil;
    switch (index) {
        case 0:
            if (_stadiumView == nil) {
                CGRect frame = [[UIScreen mainScreen] bounds];
                _stadiumView = [[StadiumView alloc] initWithFrame:frame withController:self];
            }
            newView = _stadiumView;
            title = @"找场馆";
            break;
            
        default:
            break;
    }

    if (currentActiveView != newView) {
        [self ShowView:newView withTitle:title withRemoveLastView:currentActiveView];
        //                [currentActiveView removeFromSuperview];
        //                [rootController.view addSubview:newView];
        //                [rootController.view sendSubviewToBack:newView];
        currentActiveView = newView;
    }
}

#pragma mark SignInDelegate
- (void)onLogin {
    LoginViewController *controller = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)onUserHome {
    UserHomeViewController *userHomeVC = [[UserHomeViewController alloc] init];
    [self.navigationController pushViewController:userHomeVC animated:YES];
}

@end
