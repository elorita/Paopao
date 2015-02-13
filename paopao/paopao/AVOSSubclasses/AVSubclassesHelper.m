//
//  AVSubclassesHelper.m
//  Bauma360
//
//  Created by TsaoLipeng on 14-10-17.
//  Copyright (c) 2014年 TsaoLipeng. All rights reserved.
//

#import "AVSubclassesHelper.h"
#import "Stadium.h"
#import "StadiumType.h"
#import "StadiumSpecification.h"

@implementation AVSubclassesHelper

+(void) RegisterSubclasses {
    [Stadium registerSubclass];
    [StadiumType registerSubclass];
    [StadiumSpecification registerSubclass];
    [District registerSubclass];
}

@end
