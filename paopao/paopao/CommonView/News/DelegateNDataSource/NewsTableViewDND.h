//
//  NewsTableViewDND.h
//  Bauma360
//
//  Created by TsaoLipeng on 14-10-17.
//  Copyright (c) 2014年 TsaoLipeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomTableView.h"
#import "TableOuterProtocols.h"

@interface NewsTableViewDND : NSObject<CustomTableViewDataSource,CustomTableViewDelegate,SGFocusImageFrameDelegate>

@property (nonatomic,assign) id<CustomTableCellDelegate>  delegate;

@end
