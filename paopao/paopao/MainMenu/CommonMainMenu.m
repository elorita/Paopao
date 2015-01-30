//
//  CommonMenu.m
//  paopao
//
//  Created by TsaoLipeng on 15/1/29.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import "CommonMainMenu.h"
#import "MenuView.h"
#import "StadiumView.h"
#import "LoginViewController.h"

@interface CommonMenu()<MenuViewDelegate>

- (void)onLogin;

@end

@implementation CommonMenu{
    UIViewController *rootController;
    UIView *currentActiveView;
    StadiumView *stadiumView;
}

- (id)initWithRootController:(UIViewController *)controller {
    self = [super init];
    rootController = controller;
    [self createMainMenuWithSender:rootController];
    return self;
}

- (JKSideSlipView *)createMainMenuWithSender:(id)sender {
    _sideSlipView = [[JKSideSlipView alloc]initWithSender:sender];
    _sideSlipView.backgroundColor = [UIColor redColor];
    
    MenuView *menu = [MenuView menuView];
    menu.delegate = self;
    [menu didSelectRowAtIndexPath:^(id cell, NSIndexPath *indexPath) {
        //NSLog(@"click");
        [_sideSlipView hide];
        UITableViewCell *tableCell = (UITableViewCell *)cell;
        UIView *newView = nil;
        NSString *title = nil;
        if (tableCell.tag == 0) {
            if (stadiumView == nil) {
                CGRect frame = [[UIScreen mainScreen] bounds];
                stadiumView = [[StadiumView alloc] initWithFrame:frame withController:rootController];
                //[stadiumView ]
            }
            
            newView = stadiumView;
            title = @"找场馆";
        }
        if (currentActiveView != newView) {
            if ([_delegate respondsToSelector:@selector(ShowView:withTitle:withRemoveLastView:)]) {
                [_delegate ShowView:newView withTitle:title withRemoveLastView:currentActiveView];
//                [currentActiveView removeFromSuperview];
//                [rootController.view addSubview:newView];
//                [rootController.view sendSubviewToBack:newView];
                currentActiveView = newView;
            }
        }
    }];
    menu.items = @[@{@"title":@"场馆",@"imagenormal":@"stadium_normal.png",@"imagehighlight":@"stadium_highlight.png"},
                   @{@"title":@"团队",@"imagenormal":@"team_normal.png",@"imagehighlight":@"team_highlight.png"},
                   @{@"title":@"教练",@"imagenormal":@"coach_normal.png",@"imagehighlight":@"coach_highlight.png"},
                   @{@"title":@"赛事",@"imagenormal":@"competition_normal.png",@"imagehighlight":@"competition_highlight.png"},
                   @{@"title":@"资讯",@"imagenormal":@"news_normal.png",@"imagehighlight":@"news_highlight.png"},
                   @{@"title":@"设置",@"imagenormal":@"setting_normal.png",@"imagehighlight":@"setting_highlight.png"}];
    [_sideSlipView setContentView:menu];
    return _sideSlipView;
}

- (void)onLogin {
    [self.sideSlipView hide];
    LoginViewController *controller = [[LoginViewController alloc] init];
    [rootController.navigationController pushViewController:controller animated:NO];
}

@end
