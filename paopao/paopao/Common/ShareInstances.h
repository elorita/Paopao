//
//  ShareInstances.h
//  Bauma360
//
//  Created by TsaoLipeng on 15/1/13.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ShareInstances : NSObject

+ (void)setCurrentUserHeadPortraitWithUserName:(NSString *)username;

+ (void)setCurrentUserHeadPortrait:(UIImage *)headPortrait;
+ (UIImage *)getCurrentUserHeadPortrait;

+ (void)setCurrentUserHeadPortraitThumbnail:(UIImage *)headPortrait;
+ (UIImage *)getCurrentUserHeadPortraitThumbnail;

@end