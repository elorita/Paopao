//
//  ResellTableViewDND.h
//  Bauma360
//
//  Created by TsaoLipeng on 14/12/2.
//  Copyright (c) 2014年 TsaoLipeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomTableView.h"
#import "TableOuterProtocols.h"
#import "ResellViewCell.h"

@interface ResellTableViewDND : NSObject<CustomTableViewDataSource,CustomTableViewDelegate,ResellViewCellDelegate>

@property (nonatomic,assign) id<ResellOuterDelegate>  delegate;

@end
