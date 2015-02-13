//
//  StadiumTableViewCellDND.h
//  paopao
//
//  Created by TsaoLipeng on 15/1/28.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomTableView.h"
#import "StadiumTableViewCell.h"
#import "Stadium.h"
#import "Defines.h"

@protocol StadiumOuterDelegate <NSObject>

@required
- (void)showStadium:(Stadium *)stadium;

@end

@interface StadiumTableViewDND : NSObject<CustomTableViewDataSource, CustomTableViewDelegate>

@property (nonatomic, strong) NSString *filtratedStadiumTypeOid;
@property (nonatomic, strong) NSString *filtratedDistrictOid;
@property (nonatomic) DataOrderType orderType;
@property (weak, nonatomic) id<StadiumOuterDelegate> delegate;

@end
