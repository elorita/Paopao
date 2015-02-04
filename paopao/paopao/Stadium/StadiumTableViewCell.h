//
//  StadiumTableViewCell.h
//  paopao
//
//  Created by TsaoLipeng on 15/1/28.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Stadium.h"

@interface StadiumTableViewCell : UITableViewCell

+ (NSInteger)StadiumCellHeight;

- (void) setStadium:(Stadium *)stadium;

@end
