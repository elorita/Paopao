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

#import "MYBlurIntroductionView.h"
#import "MYCustomPanel.h"

@interface RootViewController () <SignInDelegate, SidebarViewDelegate, MYIntroductionDelegate> {
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
        CGRect scrollViewFrame = CGRectMake(0, NAVIGATION_BAR_HEIGHT + STATU_BAR_HEIGHT, self.view.frame.size.width, self.view.frame.size.height - NAVIGATION_BAR_HEIGHT - STATU_BAR_HEIGHT);
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
    NSArray *items = @[@{@"title":@"精选",@"imagenormal":@"featured_normal.png",@"imagehighlight":@"featured_highlight.png"},
                       @{@"title":@"场馆",@"imagenormal":@"stadium_normal.png",@"imagehighlight":@"stadium_highlight.png"},
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
    
    //显示引导页面
    [self buildIntro];
}

//-(void)viewDidAppear:(BOOL)animated{
//    //Calling this methods builds the intro and adds it to the screen. See below.
//    //[self buildIntro];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)buildIntro{
    //Create Stock Panel with header
    UIView *headerView = [[NSBundle mainBundle] loadNibNamed:@"TestHeader" owner:nil options:nil][0];
    MYIntroductionPanel *panel1 = [[MYIntroductionPanel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) title:@"为你私人定制的运动处方" description:@"运动处方的概念最早是美国生理学家卡波维奇在20世纪50年代提出的。20世纪60年代以来，随着康复医学的发展及对冠心病等的康复训练的开展，运动处方开始受到重视。1969年世界卫生组织开始使用运动处方术语，从而在国际上得到认可。" image:[UIImage imageNamed:@"HeaderImage.png"] header:headerView];
    
    //Create Stock Panel With Image
    MYIntroductionPanel *panel2 = [[MYIntroductionPanel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) title:@"分享你的运动乐趣" description:@"无论你是运动爱好者，专业教练，还是职业运动员。无论你爱好跑步、骑行、瑜伽、郑多燕、Insanity、滑板、潜水，都可以把你做过的、想做的、想了解的与爱运动的大家交流，一个纯粹运动爱好者聚集的社区，等着你来发现更多的运动乐趣!" image:[UIImage imageNamed:@"ForkImage.png"]];
    
    //Create Panel From Nib
    MYIntroductionPanel *panel3 = [[MYIntroductionPanel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) nibNamed:@"TestPanel3"];
    
    //Create custom panel with events
    MYCustomPanel *panel4 = [[MYCustomPanel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) nibNamed:@"MYCustomPanel"];
    
    //Add panels to an array
    NSArray *panels = @[panel1, panel2, panel3, panel4];
    
    //Create the introduction view and set its delegate
    MYBlurIntroductionView *introductionView = [[MYBlurIntroductionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    introductionView.delegate = self;
    introductionView.BackgroundImageView.image = [UIImage imageNamed:@"Toronto, ON.jpg"];
    //introductionView.LanguageDirection = MYLanguageDirectionRightToLeft;
    
    //Build the introduction with desired panels
    [introductionView buildIntroductionWithPanels:panels];
    
    //Add the introduction to your view
    [self.view addSubview:introductionView];
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
        
        UIImageView *background = [[UIImageView alloc] initWithFrame:navigationBar.frame];
        [background setImage:[UIImage imageNamed:@"navigationBackground.png"]];
        [navigationBar addSubview:background];
        
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

#pragma mark - MYIntroduction Delegate
-(void)introduction:(MYBlurIntroductionView *)introductionView didChangeToPanel:(MYIntroductionPanel *)panel withIndex:(NSInteger)panelIndex{
    NSLog(@"Introduction did change to panel %d", panelIndex);
    
    //You can edit introduction view properties right from the delegate method!
    //If it is the first panel, change the color to green!
    if (panelIndex == 0) {
        [introductionView setBackgroundColor:[UIColor colorWithRed:90.0f/255.0f green:175.0f/255.0f blue:113.0f/255.0f alpha:1]];
    }
    //If it is the second panel, change the color to blue!
    else if (panelIndex == 1){
        [introductionView setBackgroundColor:[UIColor colorWithRed:50.0f/255.0f green:79.0f/255.0f blue:133.0f/255.0f alpha:1]];
    }
    
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
        case 1:
            if (_stadiumView == nil) {
                CGRect frame = CGRectMake(0, 0, scrollView.frame.size.width, scrollView.frame.size.height);
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
