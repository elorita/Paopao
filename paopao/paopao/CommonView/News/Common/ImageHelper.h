//
//  ImageHelper.h
//  Bauma360
//
//  Created by TsaoLipeng on 14/12/6.
//  Copyright (c) 2014年 TsaoLipeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageHelper : NSObject

+ (UIImage *)generateSquareThumbnail:(UIImage *)image withLength:(CGFloat)length;

@end
