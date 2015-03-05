//
//  ResellViewCell.m
//  Bauma360
//
//  Created by TsaoLipeng on 14/12/1.
//  Copyright (c) 2014年 TsaoLipeng. All rights reserved.
//

#import "ResellViewCell.h"
#import "PPImageScrollingCellView.h"

#define kScrollingViewHieght 72
#define kStartPointY 0
#define kButtonIconWidthNHeight 10

@implementation ResellViewCell
{
    Resell *_myResell;
    AVUser *_curUser;
    BOOL _isWatchedByCurUser;
    PPImageScrollingCellView *_imageScrollingView;
}

@synthesize titleLabel, summaryLabel, priceLabel, effectiveLabel, btnChat, btnCollection, btnShare;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        //[self initialize];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    //[self initialize];
}

- (void)initialize{
    [self setButtonsIcon];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setButtonsIcon {
    [self setWatchButton];
    
    UIImage *shareImage = [UIImage imageNamed:@"share.png"];
    btnShare.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [btnShare setImage:shareImage forState:UIControlStateNormal];
    
    UIImage *chatImage = [UIImage imageNamed:@"chat.png"];
    btnChat.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [btnChat setImage:chatImage forState:UIControlStateNormal];
}

- (void)setWatchButton {
    if (_curUser != nil) {
        AVQuery *query = [AVRelation reverseQuery:_curUser.className relationKey:@"watchedResell" childObject:_myResell];
        [query whereKey:@"objectId" equalTo:_curUser.objectId];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error)
            {
                UIImage *watchImage = nil;
                if (objects.count > 0)
                {
                    self->_isWatchedByCurUser = TRUE;
                    watchImage = [UIImage imageNamed:@"watched.png"];
                }
                else
                {
                    self->_isWatchedByCurUser = FALSE;
                    watchImage = [UIImage imageNamed:@"star_line.png"];
                }
                
                self.btnCollection.imageView.contentMode = UIViewContentModeScaleAspectFit;
                [self.btnCollection setImage:watchImage forState:UIControlStateNormal];
            }
        }];
    } else {
        [self.btnCollection setImage:[UIImage imageNamed:@"star_line.png"] forState:UIControlStateNormal];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setResell:(Resell *) value showGalleryDelegate:(id)delegate {
    _myResell = value;
    _curUser = [AVUser currentUser];
    titleLabel.text = value.title;
    summaryLabel.text = value.summary;
    priceLabel.text = [NSString stringWithFormat:@"¥ %ld", (long)value.price];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yy-MM-dd HH:mm"];
    effectiveLabel.text = [dateFormatter stringFromDate: value.effectiveDate];
    
    AVQuery *query = [value.images query];
    [query orderByAscending:@"order"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error){
            if ([objects count] > 0){
                //[self->_imageScrollingView clearImageList];
                [self->_imageScrollingView removeFromSuperview];
                self->_imageScrollingView = [[PPImageScrollingCellView alloc] initWithFrame:CGRectMake(0, kStartPointY, 320, kScrollingViewHieght)];
                self->_imageScrollingView.delegate = delegate;
                self->_imageScrollingView.backgroundColor = [UIColor clearColor];
                [self.imageScrollContentView addSubview:self->_imageScrollingView];
            }
            
            for (ResellImage *imageFile in objects) {
                //todo:最初根据images的count先创建滚动视图，随后每返回一个thumb，则向滚动视图刷新一个图片
                [imageFile.image getThumbnail:YES width:144 height:144 withBlock:^(UIImage *image, NSError *error) {
                    if (!error){
                        [self->_imageScrollingView addThumbnail:image withAVFile:imageFile.image];
                    }
                }];
            }
        }
    }];
}

-(IBAction)simuCertifiedClick:(id)sender{
    if ([_delegate respondsToSelector:@selector(showSimuCertificate:)]) {
        [_delegate showSimuCertificate: _myResell];
    }
}

-(IBAction)callClick:(id)sender
{
    if (_curUser != nil) {
        if ([_delegate respondsToSelector:@selector(callOwner:)]) {
            [_myResell.owner fetchIfNeededInBackgroundWithBlock:^(AVObject *object, NSError *error) {
                AVUser *user = (AVUser *)object;
                [self->_delegate callOwner: user];
            }];
        }
    } else {
        TTAlertNoTitle(@"您尚未登录，无法与卖家联系");
    }
}

-(IBAction)watchClick:(id)sender {
    if (_curUser != nil) {
        AVRelation *relation = [_curUser relationforKey:@"watchedResell"];
        if (!_isWatchedByCurUser)
            [relation addObject:_myResell];
        else
            [relation removeObject:_myResell];
        [_curUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [self setWatchButton];
            }
        }];
    }
    else {
        TTAlertNoTitle(@"您尚未登录，无法收藏机源");
    }
}

@end
