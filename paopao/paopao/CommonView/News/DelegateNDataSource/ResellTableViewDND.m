//
//  ResellTableViewDND.m
//  Bauma360
//
//  Created by TsaoLipeng on 14/12/2.
//  Copyright (c) 2014年 TsaoLipeng. All rights reserved.
//

#import "ResellTableViewDND.h"
#import <AVOSCloud/AVOSCloud.h>
#import "Resell.h"

#define COUNT_PER_LOADING 10

@implementation ResellTableViewDND
{
    NSInteger _loadedCount;
}

#pragma mark - CustomTableViewDataSource
-(NSInteger)numberOfRowsInTableView:(UITableView *)aTableView InSection:(NSInteger)section FromView:(CustomTableView *)aView{
    return aView.tableInfoArray.count;
}

-(UITableViewCell *)cellForRowInTableView:(UITableView *)aTableView IndexPath:(NSIndexPath *)aIndexPath FromView:(CustomTableView *)aView{
    static NSString *vCellIdentify = @"resellCell";
    ResellViewCell *vCell = [aTableView dequeueReusableCellWithIdentifier:vCellIdentify];
    if (vCell == nil) {
        vCell = [[[NSBundle mainBundle] loadNibNamed:@"ResellViewCell" owner:self options:nil] lastObject];
        //vCell.selectionStyle = UITableViewCellSelectionStyleNone;
        vCell.delegate = self;
    }
    
    Resell *resell = (Resell *)[aView.tableInfoArray objectAtIndex: aIndexPath.row];
    [vCell setResell:resell showGalleryDelegate:_delegate];
    [vCell initialize];
    
    return vCell;
}

#pragma mark CustomTableViewDelegate

-(float)heightForRowAthIndexPath:(UITableView *)aTableView IndexPath:(NSIndexPath *)aIndexPath FromView:(CustomTableView *)aView{
    ResellViewCell *vCell = [[[NSBundle mainBundle] loadNibNamed:@"ResellViewCell" owner:self options:nil] lastObject];
    if(aIndexPath.row < _loadedCount)
        return vCell.frame.size.height;
    else
        return 75;
}

-(void)didSelectedRowAthIndexPath:(UITableView *)aTableView IndexPath:(NSIndexPath *)aIndexPath FromView:(CustomTableView *)aView{
    Resell *resell = (Resell *)[aView.tableInfoArray objectAtIndex: aIndexPath.row];
    if ([_delegate respondsToSelector:@selector(showResell:)]) {
        [_delegate showResell: resell];
    }
}

//从AVCloud查询数据并刷新界面
- (void)QueryFromAVCloudAndFillView:(CustomTableView *)aView afterClearAll:(BOOL)isAfterClearAll withComplete:(void(^)())complete{
    AVQuery *query = [Resell query];
    [query orderByDescending:@"effectiveDate"];
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
            
            for (Resell *resell in objects) {
                [aView.tableInfoArray addObject:resell];
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
    [self QueryFromAVCloudAndFillView:aView afterClearAll:true withComplete:complete];
}

- (BOOL)tableViewEgoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view FromView:(CustomTableView *)aView{
    return  aView.reloading;
}

#pragma ResellViewCellDelegate
-(void)showSimuCertificate:(Resell *) resell{
    if ([_delegate respondsToSelector:@selector(showCertificate:)]) {
        [_delegate showCertificate: resell];
    }
}

-(void)callOwner:(AVUser *)owner{
    if ([_delegate respondsToSelector:@selector(callOwner:)]) {
        [_delegate callOwner: owner];
    }
}


@end
