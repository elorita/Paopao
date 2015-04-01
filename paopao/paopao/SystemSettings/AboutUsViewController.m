//
//  AboutUsViewController.m
//  paopao
//
//  Created by TsaoLipeng on 15/3/27.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import "AboutUsViewController.h"
#import "UIView+XD.h"
#import "NormalNavigationBar.h"
#import "Defines.h"
#import "ShareInstances.h"

#define lCopyRightTextSize 12
#define lProtocolTextSize 13
#define lMargin 10
#define lTableViewCellHeight 44

@interface AboutUsViewController()<NormalNavigationDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NormalNavigationBar *navigationBar;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:NORMAL_BACKGROUND_COLOR];
    
    self.navigationBar = [[NormalNavigationBar alloc] initWithTitle:@"关于我们"];
    self.navigationBar.delegate = self;
    [self.view addSubview:self.navigationBar];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, _navigationBar.bottom + lMargin * 2, self.view.width, 80)];
    imageView.contentMode = UIViewContentModeCenter;
    [imageView setImage:[UIImage imageNamed:@"logoRev.png"]];
    [self.view addSubview:imageView];
    
    UILabel *versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.bottom + lMargin, self.view.width, 18)];
    [versionLabel setFont:[UIFont systemFontOfSize:18]];
    [versionLabel setTextColor:LIGHT_TEXT_COLOR];
    [versionLabel setTextAlignment:NSTextAlignmentCenter];
    [versionLabel setText:@"当前版本：1.0.1"];
    [self.view addSubview:versionLabel];
    
    UIView *tableBGView = [[UIView alloc] initWithFrame:CGRectMake(0, versionLabel.bottom + lMargin * 2, self.view.width, lTableViewCellHeight * 4)];
    [ShareInstances addTopBottomBorderOnView:tableBGView];
    [self.view addSubview:tableBGView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0.5f, tableBGView.width, tableBGView.height - 1)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [tableBGView addSubview:_tableView];
    
    UILabel *copyRightLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.bottom - lCopyRightTextSize - lMargin, self.view.width, lCopyRightTextSize)];
    [copyRightLabel setFont:[UIFont systemFontOfSize:lCopyRightTextSize]];
    [copyRightLabel setTextColor:LIGHT_TEXT_COLOR];
    [copyRightLabel setTextAlignment:NSTextAlignmentCenter];
    [copyRightLabel setText:@"成都时代智云科技有限公司 版权所有"];
    [self.view addSubview:copyRightLabel];
    
    UILabel *protocolLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, copyRightLabel.y - lProtocolTextSize - lMargin, self.view.width, lProtocolTextSize)];
    [protocolLabel setFont:[UIFont systemFontOfSize:lProtocolTextSize]];
    [protocolLabel setTextColor:LINK_TEXT_COLOR];
    [protocolLabel setTextAlignment:NSTextAlignmentCenter];
    [protocolLabel setText:@"查看跑跑Running软件许可及服务协议"];
    [self.view addSubview:protocolLabel];
}

#pragma mark UITableViewDelegate and UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return lTableViewCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *vCellIdentify = @"AboutUsTableViewCell";
    UITableViewCell *vCell = [tableView dequeueReusableCellWithIdentifier:vCellIdentify];
    if (vCell == nil) {
        vCell = [[UITableViewCell alloc] init];
        vCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [vCell.textLabel setTextColor:NORMAL_TEXT_COLOR];
    }
    switch (indexPath.row) {
        case 0:
            [vCell.textLabel setText:@"去AppStore评价"];
            break;
        case 1:
            [vCell.textLabel setText:@"功能简介"];
            break;
        case 2:
            [vCell.textLabel setText:@"系统通知"];
            break;
        case 3:
            [vCell.textLabel setText:@"成都时代智云科技有限公司"];
            break;
        default:
            break;
    }
    
    return vCell;
}

- (void)doReturn {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
