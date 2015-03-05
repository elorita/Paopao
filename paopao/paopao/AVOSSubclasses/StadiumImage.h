//
//  StadiumImage.h
//  paopao
//
//  Created by TsaoLipeng on 15/3/5.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>
#import "Stadium.h"

@interface StadiumImage : AVObject<AVSubclassing>

@property (nonatomic, strong) AVFile *image;
@property (nonatomic, weak) Stadium *stadium;
@property (nonatomic, strong) NSNumber *order;

@end
