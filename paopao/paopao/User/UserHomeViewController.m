//
//  UserHomeViewController.m
//  paopao
//
//  Created by TsaoLipeng on 15/2/2.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import "UserHomeViewController.h"
#import "UIView+XD.h"
#import <AVOSCloud/AVOSCloud.h>
#import "NormalNavigationBar.h"
#import "Defines.h"
#import "SVProgressHUD.h"
#import "UIView+XD.h"
#import "ShareInstances.h"



#import "MyOrderViewController.h"
#import "CustomSettingViewController.h"
#import "WatchedStadiumViewController.h"

#define lMargin 10
#define lNormalTextSize 13.0f

@interface UserHomeViewController()<NormalNavigationDelegate>

@property (nonatomic, strong) NormalNavigationBar *navigationBar;
@property (nonatomic, strong) UIImageView *portraitImageView;

@end

@implementation UserHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = NORMAL_BACKGROUND_COLOR;
    
    self.navigationBar = [[NormalNavigationBar alloc] initWithTitle:[[AVUser currentUser] objectForKey:@"nickname"]];
    self.navigationBar.delegate = self;
    [self.view addSubview:self.navigationBar];
    
    UIView *accountView = [[UIView alloc] initWithFrame:CGRectMake(0, _navigationBar.bottom, self.view.width, 74)];
    accountView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:accountView];
    //头像图片视图
    _portraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(lMargin, 5, 64, 64)];
    [_portraitImageView.layer setCornerRadius:(_portraitImageView.frame.size.height/2)];
    [_portraitImageView.layer setMasksToBounds:YES];
    [_portraitImageView setContentMode:UIViewContentModeScaleAspectFill];
    [_portraitImageView setClipsToBounds:YES];
    _portraitImageView.layer.shadowColor = [UIColor blackColor].CGColor;
    _portraitImageView.layer.shadowOffset = CGSizeMake(4, 4);
    _portraitImageView.layer.shadowOpacity = 0.5;
    _portraitImageView.layer.shadowRadius = 2.0;
//    _portraitImageView.layer.borderColor = [MAIN_COLOR CGColor];
//    _portraitImageView.layer.borderWidth = 0.5f;
    _portraitImageView.userInteractionEnabled = YES;
    _portraitImageView.backgroundColor = [UIColor clearColor];
//    UITapGestureRecognizer *portraitTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editPortrait)];
//    [_portraitImageView addGestureRecognizer:portraitTap];
    [accountView addSubview:_portraitImageView];
    [ShareInstances loadPortraitOnView:_portraitImageView withDefaultImageName:DEFAULT_PORTRAIT];
    //昵称标签视图
    AVUser *curUser = [AVUser currentUser];
    NSString *nickname = [curUser objectForKey:@"nickname"];
    UILabel *nicknameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_portraitImageView.right + lMargin, 15, 17 * [nickname length], 17)];
    [nicknameLabel setFont:[UIFont systemFontOfSize:17]];
    [nicknameLabel setTextColor:NORMAL_TEXT_COLOR];
    [nicknameLabel setText:nickname];
    [accountView addSubview:nicknameLabel];
    //显示性别和年龄的背景视图
    UIView *sexNAgeView = [[UIView alloc] initWithFrame:CGRectMake(nicknameLabel.right + lMargin, nicknameLabel.y + 2, 60, 13)];
    [sexNAgeView setBackgroundColor:MAIN_COLOR];
    [accountView addSubview:sexNAgeView];
    //性别图片视图
    UIImageView *sexImageView = [[UIImageView alloc] initWithFrame:CGRectMake(1, 1, sexNAgeView.height - 2, sexNAgeView.height - 2)];
    NSInteger sex = [(NSNumber *)[curUser objectForKey:@"sex"] integerValue];
    switch (sex) {
        case 1://男
            [sexImageView setImage:[UIImage imageNamed:@"male.png"]];
            break;
        case 2://女
            [sexImageView setImage:[UIImage imageNamed:@"female.png"]];
        default:
            break;
    }
    [sexImageView setContentMode:UIViewContentModeScaleAspectFill];
    [sexNAgeView addSubview:sexImageView];
    //年龄标签
    UILabel *ageLabel = [[UILabel alloc] initWithFrame:CGRectMake(sexImageView.right + 5, 0, 15, sexNAgeView.height)];
    [ageLabel setFont:[UIFont systemFontOfSize:13]];
    [ageLabel setTextColor:[UIColor whiteColor]];
    NSDate *birthday = [curUser objectForKey:@"birthday"];
    NSInteger age = [[NSDate date] timeIntervalSinceDate:birthday] / (3600 * 24 * 365.25);
    [ageLabel setText:[NSString stringWithFormat:@"%ld", age]];
    [sexNAgeView addSubview:ageLabel];
    [sexNAgeView setWidth:ageLabel.right];
    //签名标签
    UILabel *signatureLabel = [[UILabel alloc] initWithFrame:CGRectMake(_portraitImageView.right + lMargin, _portraitImageView.bottom - lMargin - 12, self.view.width - _portraitImageView.right - 44 - lMargin, 12)];
    [signatureLabel setFont:[UIFont systemFontOfSize:12]];
    [signatureLabel setTextColor:MAIN_COLOR];
    [signatureLabel setText:[curUser objectForKey:@"signature"]];
    [accountView addSubview:signatureLabel];
    
    [ShareInstances addRightArrowOnView:accountView];
    
    //重要操作视图，在用户信息视图正下方
    UIView *importantOperView = [[UIView alloc] initWithFrame:CGRectMake(0, accountView.bottom, self.view.width, 60)];
    [importantOperView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:importantOperView];
    
    //我的场次
    UIView *mySessionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, importantOperView.width / 3 - 0.5, importantOperView.height)];
    UIImageView *calendarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, lMargin, mySessionView.width, 24)];
    [calendarImageView setImage:[UIImage imageNamed:@"calendar.png"]];
    [calendarImageView setContentMode:UIViewContentModeCenter];
    [mySessionView addSubview:calendarImageView];
    UILabel *mySessionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, calendarImageView.bottom + 5, mySessionView.width, lNormalTextSize)];
    [mySessionLabel setFont:[UIFont systemFontOfSize:lNormalTextSize]];
    [mySessionLabel setTextColor:NORMAL_TEXT_COLOR];
    [mySessionLabel setTextAlignment:NSTextAlignmentCenter];
    [mySessionLabel setText:@"我的场次"];
    [mySessionView addSubview:mySessionLabel];
    [mySessionView setHeight:mySessionLabel.bottom + lMargin];
    [importantOperView setHeight:mySessionView.height];
    UITapGestureRecognizer *mySessionTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SettingsOnTouch)];
    [mySessionView addGestureRecognizer:mySessionTapGR];
    
    UIView *splitterView1 = [[UIView alloc] initWithFrame:CGRectMake(mySessionView.right, 5, 0.5, importantOperView.height - 10)];
    [splitterView1 setBackgroundColor:SPLITTER_COLOR];
    
    //我的关注
    UIView *myFavoriteView = [[UIView alloc] initWithFrame:CGRectMake(splitterView1.right, 0, importantOperView.width / 3, importantOperView.height)];
    [importantOperView addSubview:myFavoriteView];
    UIImageView *fevoriteImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, lMargin, myFavoriteView.width, 24)];
    [fevoriteImageView setImage:[UIImage imageNamed:@"favorite.png"]];
    [fevoriteImageView setContentMode:UIViewContentModeCenter];
    [myFavoriteView addSubview:fevoriteImageView];
    UILabel *myFavoriteLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, fevoriteImageView.bottom + 5, myFavoriteView.width, lNormalTextSize)];
    [myFavoriteLabel setFont:[UIFont systemFontOfSize:lNormalTextSize]];
    [myFavoriteLabel setTextColor:NORMAL_TEXT_COLOR];
    [myFavoriteLabel setTextAlignment:NSTextAlignmentCenter];
    [myFavoriteLabel setText:@"我的收藏"];
    [myFavoriteView addSubview:myFavoriteLabel];
    UITapGestureRecognizer *myFavoriteTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myFavoriteOnTouch)];
    [myFavoriteView addGestureRecognizer:myFavoriteTapGR];
    
    UIView *splitterView2 = [[UIView alloc] initWithFrame:CGRectMake(myFavoriteView.right, 5, 0.5, importantOperView.height - 10)];
    [splitterView2 setBackgroundColor:SPLITTER_COLOR];
    
    //我的订单
    UIView *myOrderView = [[UIView alloc] initWithFrame:CGRectMake(splitterView2.right, 0, importantOperView.width - splitterView2.right, importantOperView.height)];
    UIImageView *orderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, lMargin, myOrderView.width, 24)];
    [orderImageView setImage:[UIImage imageNamed:@"shoppingBag.png"]];
    [orderImageView setContentMode:UIViewContentModeCenter];
    [myOrderView addSubview:orderImageView];
    UILabel *myOrderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, orderImageView.bottom + 5, myOrderView.width, lNormalTextSize)];
    [myOrderLabel setFont:[UIFont systemFontOfSize:lNormalTextSize]];
    [myOrderLabel setTextColor:NORMAL_TEXT_COLOR];
    [myOrderLabel setTextAlignment:NSTextAlignmentCenter];
    [myOrderLabel setText:@"我的订单"];
    [myOrderView addSubview:myOrderLabel];
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myOrderOnTouch)];
    [myOrderView addGestureRecognizer:tapGR];
    
    [importantOperView addSubview:mySessionView];
    [importantOperView addSubview:splitterView1];
    [importantOperView addSubview:myFavoriteView];
    [importantOperView addSubview:splitterView2];
    [importantOperView addSubview:myOrderView];
    
    [ShareInstances addTopBottomBorderOnView:importantOperView];

    
    
    UIButton *LogOutButton = [[UIButton alloc] init];
    LogOutButton.width = 200;
    LogOutButton.height = 40;
    LogOutButton.centerX = self.view.frame.size.width * 0.5;
    LogOutButton.centerY = self.view.frame.size.height *0.5;
    [LogOutButton setBackgroundColor:[UIColor orangeColor]];
    [LogOutButton setTitle:@"登出账户" forState:UIControlStateNormal];
    [LogOutButton addTarget:self action:@selector(doLogout:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:LogOutButton];
    
    UIButton *clearFileCacheButton = [[UIButton alloc] init];
    clearFileCacheButton.width = 200;
    clearFileCacheButton.height = 40;
    clearFileCacheButton.x = LogOutButton.x;
    clearFileCacheButton.y = LogOutButton.bottom + 20;
    [clearFileCacheButton setBackgroundColor:[UIColor grayColor]];
    [clearFileCacheButton setTitle:@"清空缓存" forState:UIControlStateNormal];
    [clearFileCacheButton addTarget:self action:@selector(doClear:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:clearFileCacheButton];
}

- (void)doLogout:(id)sender {
    [SVProgressHUD showSuccessWithStatus:@"已退出当前账户" duration:2];
    [AVUser logOut];
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:self];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)doClear:(id)sender {
    [AVFile clearAllCachedFiles];
}

- (void)doReturn {
    [self.navigationController popViewControllerAnimated:YES];
}

//点击“我的收藏”
- (void)myFavoriteOnTouch {
    WatchedStadiumViewController *watchedStadiumVC = [[WatchedStadiumViewController alloc] init];
    [self.navigationController pushViewController:watchedStadiumVC animated:YES];
}

//点击“我的订单”
- (void)myOrderOnTouch {
    MyOrderViewController *myOrderVC = [[MyOrderViewController alloc] init];
    [self.navigationController pushViewController:myOrderVC animated:YES];
}

//点击“关于我们”
- (void)SettingsOnTouch {
    CustomSettingViewController *aboutUsVC = [[CustomSettingViewController alloc] init];
    [self.navigationController pushViewController:aboutUsVC animated:YES];
}


@end
