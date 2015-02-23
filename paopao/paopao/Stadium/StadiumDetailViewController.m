//
//  StadiumDetailViewController.m
//  paopao
//
//  Created by TsaoLipeng on 15/2/20.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import "StadiumDetailViewController.h"
#import "NormalNavigationBar.h"
#import "UIView+XD.h"
#import "Defines.h"
#import "MenuHrizontal.h"

#define SubViewSpace 1
#define MENUHEIHT 40

@interface StadiumDetailViewController () <NormalNavigationDelegate, MenuHrizontalDelegate> {
    MenuHrizontal *mMenuHriZontal;
}

@property (nonatomic, strong) NormalNavigationBar *navigationBar;
@property (nonatomic, strong) Stadium *curStadium;

@end

@implementation StadiumDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initializeWithStadium:(Stadium *)stadium {
    _curStadium = stadium;
    [self.view setBackgroundColor:MAIN_COLOR];
    
    self.navigationBar = [[NormalNavigationBar alloc] initWithTitle:@"场馆详情"];
    self.navigationBar.delegate = self;
    [self.view addSubview:self.navigationBar];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, _navigationBar.height, self.view.width, 180)];
    [self.view addSubview:imageView];
    [stadium.image getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            [imageView setImage:[UIImage imageWithData:data]];
        }
    }];
    
    UIView *titleBackground = [[UIView alloc] initWithFrame:CGRectMake(0, imageView.frame.origin.y + imageView.frame.size.height - 32, imageView.frame.size.width, 32)];
    [titleBackground setBackgroundColor:[UIColor blackColor]];
    [titleBackground setAlpha:0.3f];
    [self.view addSubview:titleBackground];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, titleBackground.frame.origin.y + 6, titleBackground.width - 20, 20)];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setText:stadium.name];
    [self.view addSubview:titleLabel];
    
    UIView *addressView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, imageView.frame.origin.y + imageView.height, self.view.width, 44)];
    addressView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:addressView];
    
    UIImageView *addressIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [addressIcon setImage:[UIImage imageNamed:@"location_green.png"]];
    [addressIcon setContentMode:UIViewContentModeCenter];
    [addressView addSubview:addressIcon];
    
    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(44, 14, addressView.width - 44 - 44, 16)];
    [addressLabel setFont:[UIFont systemFontOfSize:15]];
    [addressLabel setTextColor:[UIColor darkTextColor]];
    [addressLabel setText:stadium.address];
    [addressView addSubview:addressLabel];
    
    UIImageView *showMapIcon = [[UIImageView alloc] initWithFrame:CGRectMake(addressView.width - 44, 0, 44, 44)];
    [showMapIcon setImage:[UIImage imageNamed:@"go_normal.png"]];
    [showMapIcon setContentMode:UIViewContentModeCenter];
    [addressView addSubview:showMapIcon];
    
    UIView *telNoView = [[UIView alloc] initWithFrame:CGRectMake(addressView.frame.origin.x, addressView.frame.origin.y + addressView.height + SubViewSpace, addressView.width, 44)];
    [telNoView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:telNoView];
    
    UILabel *telNoLabel = [[UILabel alloc] initWithFrame:CGRectMake(44, 14, telNoView.width - 44 - 44, 16)];
    [telNoLabel setFont:[UIFont systemFontOfSize:15]];
    [telNoLabel setTextColor:[UIColor darkTextColor]];
    [telNoView addSubview:telNoLabel];
    
    if (stadium.telNo && ![stadium.telNo isEqual: @""]) {
        [telNoLabel setText:stadium.telNo];
        
        UIImageView *callIcon = [[UIImageView alloc] initWithFrame:CGRectMake(addressView.width - 44, 0, 44, 44)];
        [callIcon setImage:[UIImage imageNamed:@"go_normal.png"]];
        [callIcon setContentMode:UIViewContentModeCenter];
        [telNoView addSubview:callIcon];
        
        //todo:增加view点击时间
    } else {
        [telNoLabel setText:@"暂无电话"];
    }
    
    UIView *orderView = [[UIView alloc] initWithFrame:CGRectMake(telNoView.frame.origin.x, telNoView.frame.origin.y + telNoView.height + SubViewSpace, telNoView.width, 90)];
    [orderView setBackgroundColor:MAIN_COLOR];
    [self.view addSubview:orderView];
    [self initReservationViewWithContainer:orderView];
}

#pragma mark UI初始化
-(void)initReservationViewWithContainer:(UIView *)container{

    if (mMenuHriZontal == nil) {
        mMenuHriZontal = [[MenuHrizontal alloc] initWithFrame:CGRectMake(0, 0, container.width, MENUHEIHT) withStadium:_curStadium withDate:[NSDate date]];
        mMenuHriZontal.delegate = self;
    }
//    //初始化滑动列表
//    if (mScrollPageView == nil) {
//        mScrollPageView = [[ScrollPageView alloc] initWithFrame:CGRectMake(0, MENUHEIHT, self.frame.size.width, self.frame.size.height - MENUHEIHT)];
//        mScrollPageView.delegate = self;
//        mScrollPageView.homeViewController = self.homeViewController;
//    }
//    [mScrollPageView setContentOfTables:vButtonItemArray.count];
    //默认选中第一个button
    [mMenuHriZontal clickButtonAtIndex:0];
    //-------
//    [self addSubview:mScrollPageView];
    [container addSubview:mMenuHriZontal];
}

#pragma mark - 其他辅助功能
#pragma mark MenuHrizontalDelegate
-(void)didMenuHrizontalClickedButtonAtIndex:(NSInteger)aIndex{
    NSLog(@"第%d个Button点击了",aIndex);
    //[mScrollPageView moveScrollowViewAthIndex:aIndex];
}

#pragma mark ScrollPageViewDelegate
-(void)didScrollPageViewChangedPage:(NSInteger)aPage{
    NSLog(@"CurrentPage:%d",aPage);
    [mMenuHriZontal changeButtonStateAtIndex:aPage];
    //    if (aPage == 3) {
    //刷新当页数据
    //[mScrollPageView freshContentTableAtIndex:aPage];
    //    }
}

- (void)doReturn {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
