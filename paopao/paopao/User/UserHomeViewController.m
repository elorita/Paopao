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

@interface UserHomeViewController()<NormalNavigationDelegate>

@property (nonatomic, strong) NormalNavigationBar *navigationBar;

@end

@implementation UserHomeViewController

- (void)viewDidLoad {
    self.navigationBar = [[NormalNavigationBar alloc] initWithTitle:[[AVUser currentUser] objectForKey:@"nickname"]];
    self.navigationBar.delegate = self;
    [self.view addSubview:self.navigationBar];
    
    [super viewDidLoad];
    UIButton *LogOutButton = [[UIButton alloc] init];
    LogOutButton.width = 200;
    LogOutButton.height = 40;
    LogOutButton.centerX = self.view.frame.size.width * 0.5;
    LogOutButton.centerY = self.view.frame.size.height *0.5;
    [LogOutButton setBackgroundColor:[UIColor orangeColor]];
    [LogOutButton setTitle:@"登出账户" forState:UIControlStateNormal];
    [LogOutButton addTarget:self action:@selector(doLogout:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:LogOutButton];
}

- (void)doLogout:(id)sender {
    [SVProgressHUD showSuccessWithStatus:@"已退出当前账户" duration:2];
    [AVUser logOut];
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:self];
}

- (void)doReturn {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
