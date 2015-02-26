//
//  MeetModel.h
//  表格
//
//  Created by zzy on 14-5-7.
//  Copyright (c) 2014年 zzy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sportField.h"

@interface SessionModel : NSObject
@property (nonatomic) NSInteger sportFieldIndex;
@property (nonatomic, strong) SportField *sportField;
@property (nonatomic) NSInteger sessionTime;
@property (nonatomic) NSInteger price;
@end
