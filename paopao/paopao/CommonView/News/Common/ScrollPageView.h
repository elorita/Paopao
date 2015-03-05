//
//  ScrollPageView.h
//  所有的资讯、商家、二手等信息，都分别以独立的TableView包含在ScrollPageView中
//
//  Created by lin on 14-9-23.
//  Copyright (c) 2014年 @"思木科技". All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTableView.h"
#import "HomeVC.h"

@protocol ScrollPageViewDelegate <NSObject>
-(void)didScrollPageViewChangedPage:(NSInteger)aPage;
@end

@interface ScrollPageView : UIView<UIScrollViewDelegate>
{
    NSInteger mCurrentPage;
    BOOL mNeedUseDelegate;
}

@property(nonatomic,retain) HomeVC *homeViewController;

@property (nonatomic,retain) UIScrollView *scrollView;

@property (nonatomic,retain) NSMutableArray *contentItems;

@property (nonatomic,assign) id<ScrollPageViewDelegate> delegate;

#pragma mark 添加ScrollowViewd的ContentView
-(void)setContentOfTables:(NSInteger)aNumerOfTables;
#pragma mark 滑动到某个页面
-(void)moveScrollowViewAthIndex:(NSInteger)aIndex;
#pragma mark 刷新某个页面
-(void)freshContentTableAtIndex:(NSInteger)aIndex;
#pragma mark 改变TableView上面滚动栏的内容
-(void)changeHeaderContentWithCustomTable:(CustomTableView *)aTableContent;
@end
