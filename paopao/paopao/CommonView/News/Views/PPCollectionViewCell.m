//
//  PPCollectionViewCell.m
//  PPImageScrollingTableViewControllerDemo
//
//  Created by popochess on 13/8/10.
//  Copyright (c) 2013年 popochess. All rights reserved.
//

#import "PPCollectionViewCell.h"

@interface PPCollectionViewCell ()

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UITextView *imageTitle;

@end

@implementation PPCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0., 0., frame.size.width, frame.size.height)];
    }
    return self;
}

-(void)setImage:(UIImage *)image
{
    self.imageView.image = image;
    if ([self.contentView subviews]){
        for (UILabel *subview in [self.contentView subviews]) {
            [subview removeFromSuperview];
        }
    }
    [self.contentView addSubview:self.imageView];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
