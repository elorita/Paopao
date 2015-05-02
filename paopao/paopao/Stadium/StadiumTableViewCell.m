//
//  StadiumTableViewCell.m
//  paopao
//
//  Created by TsaoLipeng on 15/1/28.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import "StadiumTableViewCell.h"
#import "UIView+XD.h"
#import "CustomLocationManager.h"
#import "SVProgressHUD.h"
#import "Defines.h"
#import "ShareInstances.h"

static NSInteger cellHeight = 180;
static NSInteger titleBackgroundHeight = 44;
static NSInteger xSpace = 8;
static NSInteger ySpace = 3;
static NSInteger titleLabelHeight = 21;
static NSInteger summaryLabelHeight = 12;
static NSInteger titleFontSize = 17;
static NSInteger summaryFontSize = 12;

@interface StadiumTableViewCell ()

@property (nonatomic, strong) Stadium *stadium;

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *distanceLabel;
@property (nonatomic, strong) UIButton *watchButton;

@end

@implementation StadiumTableViewCell {
    BOOL isWatchedByCurrentUser;
}

@synthesize imageView, titleLabel, distanceLabel, watchButton;

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLocationChanged:) name:KNOTIFICATION_LOCATIONUPDATED object:nil];
    [[CustomeLocationManager defaultManager] updateLocation];
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initialize {
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self addSubview:imageView];
    
    UIView *titleBackground = [[UIView alloc] initWithFrame:CGRectMake(0, imageView.frame.origin.y + imageView.frame.size.height - titleBackgroundHeight, imageView.frame.size.width, titleBackgroundHeight)];
    [titleBackground setBackgroundColor:[UIColor blackColor]];
    [titleBackground setAlpha:0.3f];
    [self addSubview:titleBackground];
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(xSpace + 8, titleBackground.frame.origin.y + ySpace, self.frame.size.width - xSpace * 2, titleLabelHeight)];
    [titleLabel setFont:[UIFont systemFontOfSize:titleFontSize]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [self addSubview:titleLabel];
    
    UIImageView *locationIcon = [[UIImageView alloc] initWithFrame:CGRectMake(xSpace + 8, titleLabel.frame.origin.y + titleLabel.frame.size.height + ySpace, 12, summaryLabelHeight)];
    [locationIcon setImage:[UIImage imageNamed:@"location_small.png"]];
    locationIcon.contentMode = UIViewContentModeCenter;
    [self addSubview:locationIcon];
    
    distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(locationIcon.frame.origin.x + locationIcon.frame.size.width + 2, titleLabel.frame.origin.y + titleLabel.frame.size.height + ySpace, 60, summaryLabelHeight)];
    [distanceLabel setFont:[UIFont systemFontOfSize:summaryFontSize]];
    [distanceLabel setTextColor:[UIColor yellowColor]];
    [self addSubview:distanceLabel];
    
    UIImageView *watchImageView = [[UIImageView alloc] initWithFrame:CGRectMake(268, self.frame.origin.y + 8, 44, 44)];
    watchImageView.contentMode = UIViewContentModeCenter;
    [watchImageView setImage:[UIImage imageNamed:@"followbg.png"]];
    [watchImageView setAlpha:0.3f];
    [self addSubview:watchImageView];
    
    watchButton = [[UIButton alloc] initWithFrame:watchImageView.frame];
    [watchButton addTarget:self action:@selector(watchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:watchButton];
    
    [ShareInstances addBottomBorderOnView:self];
}

- (void)setStadium:(Stadium *)stadium {
    _stadium = stadium;
    [titleLabel setText:_stadium.name];
    [self initLevelRating];
    [self initWatchButton];
    [_stadium.image getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            [imageView setImage:[UIImage imageWithData:data]];
        }
    }];
}

- (void)initWatchButton {
    AVUser *curUser = [AVUser currentUser];
    if (curUser != nil) {
        AVQuery *query = [AVRelation reverseQuery:curUser.className relationKey:@"watchedStadium" childObject:_stadium];
        [query whereKey:@"objectId" equalTo:curUser.objectId];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error)
                self->isWatchedByCurrentUser = objects.count > 0;
            else
                self->isWatchedByCurrentUser = FALSE;
            [self setWatchButtonImage];
        }];
    }
}

- (void)setWatchButtonImage {
    UIImage *watchStatuImage = nil;
    if (isWatchedByCurrentUser)
        watchStatuImage = [UIImage imageNamed:@"heart_highlight.png"];
    else
        watchStatuImage = [UIImage imageNamed:@"heart_normal.png"];
    [watchButton setImage:watchStatuImage forState:UIControlStateNormal];
}

- (void)initLevelRating{
    UILabel *proRatingLabel = [[UILabel alloc] initWithFrame:CGRectMake(distanceLabel.frame.origin.x + distanceLabel.frame.size.width + xSpace, distanceLabel.frame.origin.y, 60, summaryLabelHeight)];
    [proRatingLabel setFont:[UIFont systemFontOfSize:summaryFontSize]];
    [proRatingLabel setTextColor:[UIColor whiteColor]];
    [proRatingLabel setText:@"环境指数："];
    [self addSubview:proRatingLabel];
    
    NSInteger nextStarOriginX = proRatingLabel.frame.origin.x + proRatingLabel.frame.size.width;
    for (int i = 0; i < _stadium.professionalRating; i++) {
        UIImageView *starImageView = [[UIImageView alloc] initWithFrame:CGRectMake(nextStarOriginX, proRatingLabel.frame.origin.y, 14, summaryLabelHeight)];
        [starImageView setImage:[UIImage imageNamed:@"star_small_yellow.png"]];
        starImageView.contentMode = UIViewContentModeCenter;
        [self addSubview:starImageView];
        
        nextStarOriginX += 14;
    }
}

- (void)onLocationChanged:(NSNotification *)notification {
    double dist = [[CustomeLocationManager defaultManager] getDIstanceFromHereToAVDest:_stadium.location];
    if (dist > 1)
        [distanceLabel setText:[NSString stringWithFormat:@"%0.0f千米", dist / 1000]];
    else
        [distanceLabel setText:[NSString stringWithFormat:@"%0.1f米", dist]];
}

- (void)watchButtonClick:(id)sender {
    AVUser *curUser = [AVUser currentUser];
    if (curUser != nil) {
        AVRelation *relation = [curUser relationforKey:@"watchedStadium"];
        if (!isWatchedByCurrentUser)
            [relation addObject:_stadium];
        else
            [relation removeObject:_stadium];
        
        [curUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                isWatchedByCurrentUser = !isWatchedByCurrentUser;
                if (isWatchedByCurrentUser)
                    [SVProgressHUD showSuccessWithStatus:@"已关注" duration:2];
                else
                    [SVProgressHUD showSuccessWithStatus:@"已取关" duration:2];
                [self setWatchButtonImage];
            }
        }];
    } else {
        [SVProgressHUD showErrorWithStatus:@"您尚未登录" duration:2];
    }
}

@end
