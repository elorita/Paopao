//
//  ImageHelper.m
//  Bauma360
//
//  Created by TsaoLipeng on 14/12/6.
//  Copyright (c) 2014年 TsaoLipeng. All rights reserved.
//

#import "ImageHelper.h"

@implementation ImageHelper

+ (UIImage *)generateSquareThumbnail:(UIImage *)image withLength:(CGFloat)length {
    // Create a thumbnail version of the image for the event object.
    return image;
    CGSize size = image.size;
    CGSize croppedSize;
    CGFloat ratio = length;
    CGFloat offsetX = 0.0;
    CGFloat offsetY = 0.0;
    
    // check the size of the image, we want to make it
    // a square with sides the size of the smallest dimension
    if (size.width > size.height) {
        offsetX = (size.height - size.width) / 2;
        croppedSize = CGSizeMake(size.height, size.height);
    } else {
        offsetY = (size.width - size.height) / 2;
        croppedSize = CGSizeMake(size.width, size.width);
    }
    
    // Crop the image before resize
    CGRect clippedRect = CGRectMake(offsetX * -1, offsetY * -1, croppedSize.width, croppedSize.height);
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], clippedRect);
    // Done cropping
    
    // Resize the image
    CGRect rect = CGRectMake(0.0, 0.0, ratio, ratio);
    
    UIGraphicsBeginImageContext(rect.size);
    [[UIImage imageWithCGImage:imageRef] drawInRect:rect];
    UIImage *thumbnail = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    // Done Resizing
    
    return thumbnail;
}

@end
