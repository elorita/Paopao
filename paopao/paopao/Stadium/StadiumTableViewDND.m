//
//  StadiumTableViewCellDND.m
//  paopao
//
//  Created by TsaoLipeng on 15/1/28.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import "StadiumTableViewDND.h"
#import <AVOSCloud/AVOSCloud.h>
#import "ShareInstances.h"

#define COUNT_PER_LOADING 10

@interface StadiumTableViewDND() 

@end

@implementation StadiumTableViewDND {
    NSInteger _loadedCount;
}

#pragma mark - CustomTableViewDataSource
-(NSInteger)numberOfRowsInTableView:(UITableView *)aTableView InSection:(NSInteger)section FromView:(CustomTableView *)aView{
    return aView.tableInfoArray.count;
}

-(UITableViewCell *)cellForRowInTableView:(UITableView *)aTableView IndexPath:(NSIndexPath *)aIndexPath FromView:(CustomTableView *)aView{
    static NSString *vCellIdentify = @"resellCell";
    StadiumTableViewCell *vCell = [aTableView dequeueReusableCellWithIdentifier:vCellIdentify];
    if (vCell == nil) {
        //vCell = [[[NSBundle mainBundle] loadNibNamed:@"StadiumTableViewCell" owner:self options:nil] lastObject];
        vCell = [[StadiumTableViewCell alloc] init];
        vCell.selectionStyle = UITableViewCellSelectionStyleNone;
        //vCell.delegate = self;
    }
    
    Stadium *stadium = (Stadium *)[aView.tableInfoArray objectAtIndex: aIndexPath.row];
    [vCell setStadium:stadium];
    //[vCell initialize];
    
    return vCell;
}

#pragma mark CustomTableViewDelegate

-(float)heightForRowAthIndexPath:(UITableView *)aTableView IndexPath:(NSIndexPath *)aIndexPath FromView:(CustomTableView *)aView{
    if(aIndexPath.row < _loadedCount)
        return [StadiumTableViewCell StadiumCellHeight];
    else
        return 50;
}

-(void)didSelectedRowAthIndexPath:(UITableView *)aTableView IndexPath:(NSIndexPath *)aIndexPath FromView:(CustomTableView *)aView{
    Stadium *stadium = (Stadium *)[aView.tableInfoArray objectAtIndex: aIndexPath.row];
    if ([_delegate respondsToSelector:@selector(showStadium:)]) {
        [_delegate showStadium: stadium];
    }
}

//从AVCloud查询数据并刷新界面
- (void)QueryFromAVCloudAndFillView:(CustomTableView *)aView afterClearAll:(BOOL)isAfterClearAll withComplete:(void(^)())complete{
    AVQuery *query = [Stadium query];
    
    if (_filtratedStadiumTypeOid && ![_filtratedStadiumTypeOid isEqualToString:@""])
        [query whereKey:@"type" equalTo:[Stadium objectWithoutDataWithObjectId:_filtratedStadiumTypeOid]];
    if (_filtratedDistrictOid && ![_filtratedDistrictOid isEqualToString:@""])
        [query whereKey:@"district" equalTo:[District objectWithoutDataWithObjectId:_filtratedDistrictOid]];
    
    switch (_orderType) {
        case dotDefault:
            [query orderByDescending:@"updateAt"];
            break;
        case dotCanOrder:
            break;
        case dotNear:
            [query whereKey:@"location" nearGeoPoint:[ShareInstances getLastGeoPoint]];
            break;
        case dotCheap:
            break;
        case dotPopularity:
            break;
        case dotEvaluation:
            [query orderByDescending:@"professionalRating"];
        default:
            break;
    }
    
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
            
            for (Stadium *stadium in objects) {
                [aView.tableInfoArray addObject:stadium];
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

//#pragma ResellViewCellDelegate
//-(void)showSimuCertificate:(Resell *) resell{
//    if ([_delegate respondsToSelector:@selector(showCertificate:)]) {
//        [_delegate showCertificate: resell];
//    }
//}
//
//-(void)callOwner:(AVUser *)owner{
//    if ([_delegate respondsToSelector:@selector(callOwner:)]) {
//        [_delegate callOwner: owner];
//    }
//}



@end

