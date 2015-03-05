//
//  HomeView.m
//  ShowProduct
//
//  Created by lin on 14-5-22.
//  Copyright (c) 2014年 @"". All rights reserved.
//

#import "HomeView.h"
#import "NewsViewCell.h"
#import "HomeVC.h"


#define MENUHEIHT 40

@interface HomeView()

@property(nonatomic,retain) HomeVC *homeViewController;

@end

@implementation HomeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self commInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame controller:(UIViewController *)controller{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.homeViewController = (HomeVC *)controller;
        [self commInit];
    }
    return self;
}

#pragma mark UI初始化
-(void)commInit{
    NSArray *vButtonItemArray = @[@{NOMALKEY: @"subTabbar_normal",
                                    HEIGHTKEY:@"subTabbar_highLight",
                                    TITLEKEY:@"二手",
                                    TITLEWIDTH:[NSNumber numberWithFloat:160]
                                    },
                                  @{NOMALKEY: @"subTabbar_normal",
                                    HEIGHTKEY:@"subTabbar_highLight",
                                    TITLEKEY:@"资讯",
                                    TITLEWIDTH:[NSNumber numberWithFloat:160]
                                    },
//                                  @{NOMALKEY: @"subTabbar_normal",
//                                    HEIGHTKEY:@"subTabbar_highLight",
//                                    TITLEKEY:@"商家",
//                                    TITLEWIDTH:[NSNumber numberWithFloat:80]
//                                    },
//                                  @{NOMALKEY: @"subTabbar_normal",
//                                    HEIGHTKEY:@"subTabbar_highLight",
//                                    TITLEKEY:@"圈子",
//                                    TITLEWIDTH:[NSNumber numberWithFloat:80]
//                                    },
                                  ];
    
    if (mMenuHriZontal == nil) {
        mMenuHriZontal = [[MenuHrizontal alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, MENUHEIHT) ButtonItems:vButtonItemArray];
        mMenuHriZontal.delegate = self;
    }
    //初始化滑动列表
    if (mScrollPageView == nil) {
        mScrollPageView = [[ScrollPageView alloc] initWithFrame:CGRectMake(0, MENUHEIHT, self.frame.size.width, self.frame.size.height - MENUHEIHT)];
        mScrollPageView.delegate = self;
        mScrollPageView.homeViewController = self.homeViewController;
    }
    [mScrollPageView setContentOfTables:vButtonItemArray.count];
    //默认选中第一个button
    [mMenuHriZontal clickButtonAtIndex:0];
    //-------
    [self addSubview:mScrollPageView];
    [self addSubview:mMenuHriZontal];
}

#pragma mark - 其他辅助功能
#pragma mark MenuHrizontalDelegate
-(void)didMenuHrizontalClickedButtonAtIndex:(NSInteger)aIndex{
    NSLog(@"第%ld个Button点击了",(long)aIndex);
    [mScrollPageView moveScrollowViewAthIndex:aIndex];
}

#pragma mark ScrollPageViewDelegate
-(void)didScrollPageViewChangedPage:(NSInteger)aPage{
    NSLog(@"CurrentPage:%ld",(long)aPage);
    [mMenuHriZontal changeButtonStateAtIndex:aPage];
//    if (aPage == 3) {
        //刷新当页数据
        [mScrollPageView freshContentTableAtIndex:aPage];
//    }
}


@end
