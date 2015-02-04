//
//  StadiumTableViewCell.m
//  paopao
//
//  Created by TsaoLipeng on 15/1/28.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import "StadiumTableViewCell.h"
#import "UIView+XD.h"
#import "GeoPointOper.h"

static NSInteger cellHeight = 180;
static NSInteger titleBackgroundHeight = 54;
static NSInteger xSpace = 8;
static NSInteger ySpace = 5;
static NSInteger labelHeight = 21;
static NSInteger titleFontSize = 15;
static NSInteger summaryFontSize = 12;

@interface StadiumTableViewCell ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *summaryLabel;

@end

@implementation StadiumTableViewCell

@synthesize imageView, titleLabel, summaryLabel;

+ (NSInteger)StadiumCellHeight {
    return cellHeight;
}

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)init {
    self = [super init];
    self.height = cellHeight;
    [self initialize];
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initialize {
    imageView = [[UIImageView alloc] initWithFrame:self.frame];
    [self addSubview:imageView];
    
    UIView *titleBackground = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - titleBackgroundHeight, self.frame.size.width, titleBackgroundHeight)];
    [titleBackground setBackgroundColor:[UIColor blackColor]];
    [titleBackground setAlpha:0.5f];
    [self addSubview:titleBackground];
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(xSpace, titleBackground.frame.origin.y + ySpace, self.frame.size.width - xSpace * 2, labelHeight)];
    [titleLabel setFont:[UIFont systemFontOfSize:titleFontSize]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [self addSubview:titleLabel];
    
    summaryLabel = [[UILabel alloc] initWithFrame:CGRectMake(xSpace, titleLabel.frame.origin.y + titleLabel.frame.size.height + ySpace, 120, 21)];
    [summaryLabel setFont:[UIFont systemFontOfSize:summaryFontSize]];
    [summaryLabel setTextColor:[UIColor whiteColor]];
    [self addSubview:summaryLabel];
}

- (void) setStadium:(Stadium *)stadium {
    [titleLabel setText:stadium.name];
    double dist = [GeoPointOper getDIstanceFromHereToAVDest:stadium.location];
    [summaryLabel setText:[NSString stringWithFormat:@"%0.1fkm", dist]];
    [stadium.image getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            [imageView setImage:[UIImage imageWithData:data]];
        }
    }];
}

@end
