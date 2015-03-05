//
//  NewsTableViewDND.m
//  Bauma360
//
//  Created by TsaoLipeng on 14-10-17.
//  Copyright (c) 2014年 TsaoLipeng. All rights reserved.
//

#import "NewsTableViewDND.h"
#import "NewsViewCell.h"
#import <AVOSCloud/AVOSCloud.h>
#import "Article.h"

#define COUNT_PER_LOADING 20

@implementation NewsTableViewDND
{
    NSInteger _loadedCount;
    SGFocusImageFrame *_bannerView;
    NSMutableArray *_headLinesArray;
    NSMutableArray *_headImageItemArray;
}

#pragma mark 改变TableView上面滚动栏的内容
-(void)changeHeaderContentWithCustomTable:(CustomTableView *)aTableContent{
    AVQuery *query = [Article query];
    [query whereKeyExists:@"headerImageFile"];
    [query orderByDescending:@"date"];
    query.limit = 6;
    query.cachePolicy = kAVCachePolicyNetworkElseCache;
    query.maxCacheAge = 3600*24*7;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error && objects.count > 0) {
            NSMutableArray *tempArray = [NSMutableArray array];
            if (self->_headLinesArray == NULL)
                self->_headLinesArray = [NSMutableArray array];
            [self->_headLinesArray removeAllObjects];
            for (Article *article in objects) {
                [self->_headLinesArray addObject:article];
                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                                      article.title, @"title" ,
                                      article.headerImageFile, @"image",
                                      nil];
                [tempArray addObject:dict];
            }
            
            int length = (int)objects.count;
            
            self->_headImageItemArray = [NSMutableArray arrayWithCapacity:length+2];
            //添加最后一张图 用于循环
            if (length > 1)
            {
                NSDictionary *dict = [tempArray objectAtIndex:length-1];
                SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithDict:dict tag:-1];
                [self->_headImageItemArray addObject:item];
            }
            for (int i = 0; i < length; i++)
            {
                NSDictionary *dict = [tempArray objectAtIndex:i];
                SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithDict:dict tag:i];
                [self->_headImageItemArray addObject:item];
                
            }
            //添加第一张图 用于循环
            if (length >1)
            {
                NSDictionary *dict = [tempArray objectAtIndex:0];
                SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithDict:dict tag:length];
                [self->_headImageItemArray addObject:item];
            }
            
            [self->_bannerView changeImageViewsContent:self->_headImageItemArray];
        }
    }];
}

#pragma mark - CustomTableViewDataSource
-(NSInteger)numberOfRowsInTableView:(UITableView *)aTableView InSection:(NSInteger)section FromView:(CustomTableView *)aView{
    return aView.tableInfoArray.count;
}

-(UITableViewCell *)cellForRowInTableView:(UITableView *)aTableView IndexPath:(NSIndexPath *)aIndexPath FromView:(CustomTableView *)aView{
    static NSString *vCellIdentify = @"newsCell";
    NewsViewCell *vCell = [aTableView dequeueReusableCellWithIdentifier:vCellIdentify];
    if (vCell == nil) {
        vCell = [[[NSBundle mainBundle] loadNibNamed:@"NewsViewCell" owner:self options:nil] lastObject];
    }
    
    Article *article = (Article *)[aView.tableInfoArray objectAtIndex: aIndexPath.row];
    NSData *thumb = [article.listImageFile getData];
    vCell.headerImageView.image = [UIImage imageWithData:thumb];
    vCell.titleLabel.text = article.title;
    vCell.summaryLabel.text = article.summary;
    return vCell;
}

#pragma mark CustomTableViewDelegate
-(UIView *)loadHeaderView{
    return _bannerView;
}

-(float)heightForRowAthIndexPath:(UITableView *)aTableView IndexPath:(NSIndexPath *)aIndexPath FromView:(CustomTableView *)aView{
    NewsViewCell *vCell = [[[NSBundle mainBundle] loadNibNamed:@"NewsViewCell" owner:self options:nil] lastObject];
    return vCell.frame.size.height;
}

-(void)didSelectedRowAthIndexPath:(UITableView *)aTableView IndexPath:(NSIndexPath *)aIndexPath FromView:(CustomTableView *)aView{
    Article *article = (Article *)[aView.tableInfoArray objectAtIndex: aIndexPath.row];
    if ([_delegate respondsToSelector:@selector(showArticle:)]) {
        [_delegate showArticle:article];
    }
}

//从AVCloud查询数据并刷新界面
- (void)QueryFromAVCloudAndFillView:(CustomTableView *)aView afterClearAll:(BOOL)isAfterClearAll withComplete:(void(^)())complete{
    AVQuery *query = [Article query];
    [query whereKey:@"tag" containsAllObjectsInArray:@[@"news"]];
    [query orderByAscending:@"date"];
    query.limit = COUNT_PER_LOADING;
    query.cachePolicy = kPFCachePolicyNetworkElseCache;
    query.maxCacheAge = 3600*24*7;//缓存一周时间
    if (!isAfterClearAll)
        query.skip = self->_loadedCount;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error)
        {
            if (isAfterClearAll){
                self->_loadedCount = objects.count;
                [aView.tableInfoArray removeAllObjects];
            }else{
                self->_loadedCount += objects.count;
            }
            
            for (Article *article in objects) {
                [aView.tableInfoArray addObject:article];
            }
            
            if (complete) {
                complete(objects.count);
            }
        }
    }];
}

-(void)loadData:(void(^)(int aAddedRowCount))complete FromView:(CustomTableView *)aView{
    [self QueryFromAVCloudAndFillView:aView afterClearAll:false withComplete:complete];
}

-(void)refreshData:(void(^)(int aAddedRowCount))complete FromView:(CustomTableView *)aView{
    if (_bannerView == NULL)//初次刷新数据时，初始化UITableView.tableHeaderView
    {
        SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithDict:[_headImageItemArray objectAtIndex:0] tag:-1];
        _bannerView = [[SGFocusImageFrame alloc] initWithFrame:CGRectMake(0, -105, 320, 185) delegate:self imageItems:@[item] isAuto:YES];
    }
    
    [self QueryFromAVCloudAndFillView:aView afterClearAll:true withComplete:complete];
    [self changeHeaderContentWithCustomTable:aView];
}

- (BOOL)tableViewEgoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view FromView:(CustomTableView *)aView{
    return  aView.reloading;
}

#pragma mark SGFocusImageFrameDelegate
- (void)foucusImageFrame:(SGFocusImageFrame *)imageFrame didSelectItem:(SGFocusImageItem *)item
{
    //NSLog(@"%s \n click===>%d",__FUNCTION__,item.tag);
    Article *article = (Article *)[_headLinesArray objectAtIndex:item.tag];
    if ([_delegate respondsToSelector:@selector(showArticle:)]) {
        [_delegate showArticle:article];
    }
}
- (void)foucusImageFrame:(SGFocusImageFrame *)imageFrame currentItem:(int)index;
{
    //    NSLog(@"%s \n scrollToIndex===>%d",__FUNCTION__,index);
}
@end
