//
//  StadiumViewController.m
//  paopao
//
//  Created by TsaoLipeng on 15/1/29.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import "StadiumView.h"
#import "CustomTableView.h"
#import "StadiumTableViewDND.h"
#import "Defines.h"
#import "UIView+XD.h"
#import "DOPDropDownMenu.h"
#import "District.h"

@interface StadiumView () <DOPDropDownMenuDataSource, DOPDropDownMenuDelegate> {
    CustomTableView *stadiumTableView;
    StadiumTableViewDND *stadiumTableViewDND;
    UIView *navigationBar;
    UIScrollView *scrollView;
    DOPDropDownMenu *dropDownMenu;
    
    NSMutableArray *stadiumTypeNameArray;
    NSMutableArray *stadiumTypeOidArray;
    NSMutableArray *districtNameArray;
    NSMutableArray *districtOidArray;
    NSMutableArray *distrctArray;
    NSArray *orderTypeArray;
}

@end

@implementation StadiumView

- (id)initWithFrame:(CGRect)frame withController:(UIViewController *)controller {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.homeViewController = controller;
        [self initialize];
    }
    return self;
}

- (void)initialize {
    if (scrollView == nil) {
        CGRect scrollViewFrame = CGRectMake(0, 40, self.frame.size.width, self.frame.size.height);
        scrollView = [[UIScrollView alloc] initWithFrame:scrollViewFrame];
        [self addSubview:scrollView];
    }
    
    orderTypeArray = [NSArray arrayWithObjects:@"默认排序", @"可预订", @"离我最近", @"价格最低", @"人气最高", @"评分最高", nil];
    [self initializeMenuItem];
    
    dropDownMenu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:40];
    dropDownMenu.dataSource = self;
    dropDownMenu.delegate = self;
    [self addSubview:dropDownMenu];
    
    if (stadiumTableViewDND == nil)
        stadiumTableViewDND = [[StadiumTableViewDND alloc] init];
    if (stadiumTableView == nil)
        stadiumTableView = [[CustomTableView alloc] initWithFrame:CGRectMake(0, 0, scrollView.width, scrollView.height - 40)];
    
    stadiumTableView.delegate = stadiumTableViewDND;
    stadiumTableView.dataSource = stadiumTableViewDND;
    stadiumTableView.backgroundColor = [UIColor redColor];
    [self->scrollView addSubview:stadiumTableView];
    
    [dropDownMenu selectFirstItemInAllMenu];//该调用会出发一次Menu0Item0的回调
}

- (void)initializeMenuItem {
    stadiumTypeNameArray = [[NSMutableArray alloc] init];
    stadiumTypeOidArray = [[NSMutableArray alloc] init];
    [stadiumTypeNameArray addObject:@"全部场馆"];
    [stadiumTypeOidArray addObject:@""];
    AVQuery *queryStadiumType = [StadiumType query];
    [queryStadiumType orderByAscending:@"order"];
    queryStadiumType.cachePolicy = kPFCachePolicyNetworkElseCache;
    queryStadiumType.maxCacheAge = 3600 * 24 * 7;
    [queryStadiumType findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (StadiumType *stadium in objects) {
                [stadiumTypeNameArray addObject:stadium.name];
                [stadiumTypeOidArray addObject:stadium.objectId];
            }
        }
    }];
    
    districtNameArray = [[NSMutableArray alloc] init];
    districtOidArray = [[NSMutableArray alloc] init];
    [districtNameArray addObject:@"全部区域"];
    [districtOidArray addObject:@""];
    AVQuery *queryDistrict = [District query];
    [queryDistrict orderByAscending:@"order"];
    queryDistrict.cachePolicy = kPFCachePolicyNetworkElseCache;
    queryDistrict.maxCacheAge = 3600 * 24 * 7;
    [queryDistrict findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (District *district in objects) {
                [districtNameArray addObject:district.name];
                [districtOidArray addObject:district.objectId];
            }
        }
    }];
}

- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu {
    return 3;
}

- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column {
    switch (column) {
        case 0:
            return [stadiumTypeNameArray count];
            break;
        case 1:
            return [districtNameArray count];
            break;
        case 2:
            return DataOrderTypeCount;
            break;
        default:
            return 0;
            break;
    }
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath {
    switch (indexPath.column) {
        case 0:
            return [stadiumTypeNameArray objectAtIndex:indexPath.row];
            break;
        case 1:
            return [districtNameArray objectAtIndex:indexPath.row];//self.genders[indexPath.row];
            break;
        case 2:
            return DataOrderTypeString(indexPath.row);
            break;
        default:
            return nil;
            break;
    }
}

- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath {
    NSLog(@"column:%li row:%li", (long)indexPath.column, (long)indexPath.row);
    NSLog(@"%@",[menu titleForRowAtIndexPath:indexPath]);
    //NSString *title = [menu titleForRowAtIndexPath:indexPath];
    
    switch (indexPath.column) {
        case 0:
            stadiumTableViewDND.filtratedStadiumTypeOid = [stadiumTypeOidArray objectAtIndex:indexPath.row];
            break;
        case 1:
            stadiumTableViewDND.filtratedDistrictOid = [districtOidArray objectAtIndex:indexPath.row];
            break;
        case 2:
            stadiumTableViewDND.orderType = indexPath.row;
            break;
        default:
            break;
    }
    [stadiumTableView forceToFreshData];
}


@end
