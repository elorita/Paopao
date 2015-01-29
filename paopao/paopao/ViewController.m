//
//  ViewController.m
//  paopao
//
//  Created by TsaoLipeng on 15/1/28.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import "ViewController.h"
#import "MenuView.h"
#import <AVOSCloud/AVOSCloud.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _sideSlipView = [[JKSideSlipView alloc]initWithSender:self];
    _sideSlipView.backgroundColor = [UIColor redColor];
    
    MenuView *menu = [MenuView menuView];
    [menu didSelectRowAtIndexPath:^(id cell, NSIndexPath *indexPath) {
        NSLog(@"click");
        [_sideSlipView hide];
        //NextViewController *next = [[NextViewController alloc]init];
        //[self.navigationController pushViewController:next animated:YES];
    }];
    menu.items = @[@{@"title":@"场馆",@"imagenormal":@"stadium_normal.png",@"imagehighlight":@"stadium_highlight.png"},
                   @{@"title":@"团队",@"imagenormal":@"team_normal.png",@"imagehighlight":@"team_highlight.png"},
                   @{@"title":@"教练",@"imagenormal":@"coach_normal.png",@"imagehighlight":@"coach_highlight.png"},
                   @{@"title":@"赛事",@"imagenormal":@"competition_normal.png",@"imagehighlight":@"competition_highlight.png"},
                   @{@"title":@"资讯",@"imagenormal":@"news_normal.png",@"imagehighlight":@"news_highlight.png"},
                   @{@"title":@"设置",@"imagenormal":@"setting_normal.png",@"imagehighlight":@"setting_highlight.png"}];
    [_sideSlipView setContentView:menu];
    [self.view addSubview:_sideSlipView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
