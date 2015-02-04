//
//  ShareInstances.m
//  Bauma360
//
//  Created by TsaoLipeng on 15/1/13.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import "ShareInstances.h"
#import <AVOSCloud/AVOSCloud.h>

static UIImage *currentUserHeadPortrait;
static UIImage *currentUserHeadPortraitThumbnail;

static CLLocation *lastLocation;

@implementation ShareInstances

+ (void)setCurrentUserHeadPortraitWithUserName:(NSString *)username {
    AVQuery *query = [AVUser query];
    [query whereKey:@"username" equalTo:username];
    query.cachePolicy = kPFCachePolicyCacheElseNetwork;
    query.maxCacheAge = 3600 * 24;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error && objects.count > 0) {
            AVUser *user = [objects objectAtIndex:0];
            AVFile *headPortraitFile = [user objectForKey:@"headPortrait"];
            [headPortraitFile getThumbnail:YES width:88 height:88 withBlock:^(UIImage *image, NSError *error) {
                if (!error) {
                    currentUserHeadPortraitThumbnail = image;
                }
            }];
            [headPortraitFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                if (!error) {
                    currentUserHeadPortrait = [UIImage imageWithData:data];
                }
            }];
        }
    }];
}

+ (void)setCurrentUserHeadPortrait:(UIImage *)headPortrait {
    currentUserHeadPortrait = headPortrait;
    CGSize thumbnailSize = CGSizeMake(88, 88);
    currentUserHeadPortraitThumbnail = [self originImage:currentUserHeadPortrait scaleToSize:thumbnailSize];
}

+ (UIImage *)getCurrentUserHeadPortrait {
    return currentUserHeadPortrait;
}

+ (void)setCurrentUserHeadPortraitThumbnail:(UIImage *)headPortrait {
    currentUserHeadPortraitThumbnail = headPortrait;
}

+ (UIImage *)getCurrentUserHeadPortraitThumbnail {
    return currentUserHeadPortraitThumbnail;
}

+(UIImage*) originImage:(UIImage *)image scaleToSize:(CGSize)size
{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

+ (void)setCurrentLocation:(CLLocation *)location {
    lastLocation = location;
}

+ (CLLocation *)getLastLocation {
    return lastLocation;
}

@end
