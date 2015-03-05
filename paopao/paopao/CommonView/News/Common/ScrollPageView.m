//
//  ScrollPageView.m
//  ShowProduct
//
//  Created by lin on 14-5-23.
//  Copyright (c) 2014年 @"". All rights reserved.
//

#import "ScrollPageView.h"
#import "NewsViewCell.h"
#import "NewsTableViewDND.h"
#import "ResellViewCell.h"
#import "ResellTableViewDND.h"

@implementation ScrollPageView
{
    NewsTableViewDND *newsDND;
    ResellTableViewDND *resellDND;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        mNeedUseDelegate = YES;
        [self commInit];
    }
    return self;
}

-(void)initData{
    [self freshContentTableAtIndex:0];
}


-(void)commInit{
    if (_contentItems == nil) {
        _contentItems = [[NSMutableArray alloc] init];
    }
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        NSLog(@"ScrollViewFrame:(%f,%f)",self.frame.size.width,self.frame.size.height);
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
    }
    [self addSubview:_scrollView];
}

#pragma mark - 其他辅助功能
#pragma mark 添加ScrollowViewd的ContentView
-(void)setContentOfTables:(NSInteger)aNumerOfTables{
    for (int i = 0; i < aNumerOfTables; i++) {
        CustomTableView *vCustomTableView = [[CustomTableView alloc] initWithFrame:CGRectMake(320 * i, 0, 320, self.frame.size.height)];
        if (i == 0)
        {
            resellDND = [[ResellTableViewDND alloc] init];
            resellDND.delegate = self.homeViewController;
            vCustomTableView.delegate = resellDND;
            vCustomTableView.dataSource = resellDND;
        }else if (i == 1){
            newsDND = [[NewsTableViewDND alloc] init];
            newsDND.delegate = self.homeViewController;
            vCustomTableView.delegate = newsDND;
            vCustomTableView.dataSource = newsDND;
        }else
        {
            //vCustomTableView.delegate = self;
            //vCustomTableView.dataSource = self;
        }
        
        //为table添加嵌套HeadderView
        [self addLoopScrollowView:vCustomTableView];
        [_scrollView addSubview:vCustomTableView];
        [_contentItems addObject:vCustomTableView];
    }
    [_scrollView setContentSize:CGSizeMake(320 * aNumerOfTables, self.frame.size.height)];
}

#pragma mark 移动ScrollView到某个页面
-(void)moveScrollowViewAthIndex:(NSInteger)aIndex{
    mNeedUseDelegate = NO;
    CGRect vMoveRect = CGRectMake(self.frame.size.width * aIndex, 0, self.frame.size.width, self.frame.size.width);
    [_scrollView scrollRectToVisible:vMoveRect animated:YES];
    mCurrentPage= aIndex;
    if ([_delegate respondsToSelector:@selector(didScrollPageViewChangedPage:)]) {
        [_delegate didScrollPageViewChangedPage:mCurrentPage];
    }
}

#pragma mark 刷新某个页面
-(void)freshContentTableAtIndex:(NSInteger)aIndex{
    if (_contentItems.count < aIndex) {
        return;
    }
    CustomTableView *vTableContentView =(CustomTableView *)[_contentItems objectAtIndex:aIndex];
    [vTableContentView forceToFreshData];
}

#pragma mark 添加HeaderView
-(void)addLoopScrollowView:(CustomTableView *)aTableView {
    //添加一张默认图片
//    SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithDict:@{@"image": [NSString stringWithFormat:@"ad%d",1]} tag:-1];
//    SGFocusImageFrame *bannerView = [[SGFocusImageFrame alloc] initWithFrame:CGRectMake(0, -105, 320, 185) delegate:aTableView imageItems:@[item] isAuto:YES];
//    aTableView.homeTableView.tableHeaderView = bannerView;
}

#pragma mark 改变TableView上面滚动栏的内容
-(void)changeHeaderContentWithCustomTable:(CustomTableView *)aTableContent{
    int length = 4;
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i = 0 ; i < length; i++)
    {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSString stringWithFormat:@"title%d",i],@"title" ,
                              [NSString stringWithFormat:@"ad%d",(i + 1)],@"image",
                              nil];
        [tempArray addObject:dict];
    }
    
    NSMutableArray *itemArray = [NSMutableArray arrayWithCapacity:length+2];
    //添加最后一张图 用于循环
    if (length > 1)
    {
        NSDictionary *dict = [tempArray objectAtIndex:length-1];
        SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithDict:dict tag:-1];
        [itemArray addObject:item];
    }
    for (int i = 0; i < length; i++)
    {
        NSDictionary *dict = [tempArray objectAtIndex:i];
        SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithDict:dict tag:i];
        [itemArray addObject:item];
        
    }
    //添加第一张图 用于循环
    if (length >1)
    {
        NSDictionary *dict = [tempArray objectAtIndex:0];
        SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithDict:dict tag:length];
        [itemArray addObject:item];
    }
    
    SGFocusImageFrame *vFocusFrame = (SGFocusImageFrame *)aTableContent.homeTableView.tableHeaderView;
    [vFocusFrame changeImageViewsContent:itemArray];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    mNeedUseDelegate = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int page = (_scrollView.contentOffset.x+320/2.0) / 320;
    if (mCurrentPage == page) {
        return;
    }
    mCurrentPage= page;
    if ([_delegate respondsToSelector:@selector(didScrollPageViewChangedPage:)] && mNeedUseDelegate) {
        [_delegate didScrollPageViewChangedPage:mCurrentPage];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
//        CGFloat targetX = _scrollView.contentOffset.x + _scrollView.frame.size.width;
//        targetX = (int)(targetX/ITEM_WIDTH) * ITEM_WIDTH;
//        [self moveToTargetPosition:targetX];
    }
  

}

@end
