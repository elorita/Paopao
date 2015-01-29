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

@protocol StadiumOuterDelegate <NSObject>

@required
- (void)showStadium:(Stadium *)stadium;

@end

@interface StadiumTableViewCellDND : NSObject<CustomTableViewDataSource, CustomTableViewDelegate>

@property (weak, nonatomic) id<StadiumOuterDelegate> delegate;

@end
