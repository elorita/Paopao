//
//  Stadium.h
//  paopao
//
//  Created by TsaoLipeng on 15/1/28.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>
#import "StadiumType.h"

@interface Stadium : AVObject<AVSubclassing>

@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) AVFile *portrait;
@property (nonatomic, weak) StadiumType *type;
@property (nonatomic, strong) NSString *telNo;
@property (nonatomic, strong) AVFile *image;
@property (nonatomic, strong) AVGeoPoint *location;

@end
