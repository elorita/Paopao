//
//  StadiumDetailViewController.m
//  paopao
//
//  Created by TsaoLipeng on 15/2/20.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import "StadiumDetailViewController.h"
#import "NormalNavigationBar.h"
#import "UIView+XD.h"
#import "Defines.h"
#import "ScheduleHorizontalMenu.h"
#import "ReservationViewController.h"
#import "SVProgressHUD.h"
#import "TelHelper.h"
#import "CustomLocationManager.h"
#import "Bulletin.h"
#import "SGFocusImageFrame.h"
#import "SGFocusImageItem.h"
#import "StadiumImage.h"
#import "ImgShowViewController.h"
#import "PreNavigationViewController.h"
#import "ShareInstances.h"

#define SubViewSpace 5
#define MENUHEIHT 40
#define lXMargin 10
#define lYMargin 10
#define lBannerHeight 180

@interface StadiumDetailViewController () <NormalNavigationDelegate, MenuHrizontalDelegate, SGFocusImageFrameDelegate> {
    ScheduleHorizontalMenu *mMenuHriZontal;
    SGFocusImageFrame *_bannerView;
    NSMutableArray *_headImageSGItemArray;
    NSMutableArray *_headImageArray;
}

@property (nonatomic, strong) NormalNavigationBar *navigationBar;
@property (nonatomic, strong) Stadium *curStadium;
@property (nonatomic, strong) UILabel *distanceLabel;

@end

@implementation StadiumDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    if (_curStadium != nil) {
        [mMenuHriZontal refreshCellsWithStadium:_curStadium withDate:[NSDate date]];
    }
}

- (void)initializeWithStadium:(Stadium *)stadium {
    _curStadium = stadium;
    [self.view setBackgroundColor:NORMAL_BACKGROUND_COLOR];
    
    self.navigationBar = [[NormalNavigationBar alloc] initWithTitle:@"场馆详情"];
    self.navigationBar.delegate = self;
    [self.view addSubview:self.navigationBar];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _navigationBar.bottom, self.view.width, self.view.height - _navigationBar.bottom)];
    [self.view addSubview:scrollView];
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 180)];
//    [scrollView addSubview:imageView];
//    [stadium.image getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
//        if (!error) {
//            [imageView setImage:[UIImage imageWithData:data]];
//        }
//    }];
    [SVProgressHUD showWithStatus:@"正在查询场馆概况"];
    _bannerView = [[SGFocusImageFrame alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 180) delegate:self imageItems:nil isAuto:NO];
    [scrollView addSubview:_bannerView];
    [self loadHeaderImages];
    
    UIView *titleBackground = [[UIView alloc] initWithFrame:CGRectMake(0, lBannerHeight - 32, _bannerView.width, 32)];
    [titleBackground setBackgroundColor:[UIColor blackColor]];
    [titleBackground setAlpha:0.3f];
    [scrollView addSubview:titleBackground];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, titleBackground.frame.origin.y + 6, titleBackground.width - 20, 20)];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setText:stadium.name];
    [scrollView addSubview:titleLabel];
    
    UIView *orderView = [[UIView alloc] initWithFrame:CGRectMake(self.view.x, lBannerHeight, self.view.width, 90)];
    [orderView setBackgroundColor:NORMAL_BACKGROUND_COLOR];
    [scrollView addSubview:orderView];
    [self initReservationViewWithContainer:orderView];
    
    //显示场馆评分、地址、电话等
    UIView *summaryView = [[UIView alloc] initWithFrame:CGRectMake(self.view.x, orderView.bottom, self.view.width, 90)];
    summaryView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:summaryView];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(lXMargin, lYMargin, summaryView.width - 80, 18)];
    [nameLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [nameLabel setTextColor:[UIColor darkGrayColor]];
    [nameLabel setText:stadium.name];
    [summaryView addSubview:nameLabel];
    
    NSInteger nextStarOriginX = lXMargin;
    for (int i = 0; i < _curStadium.professionalRating; i++) {
        UIImageView *starImageView = [[UIImageView alloc] initWithFrame:CGRectMake(nextStarOriginX, nameLabel.bottom + lYMargin, 20, 20)];
        [starImageView setImage:[UIImage imageNamed:@"star_bordered.png"]];
        starImageView.contentMode = UIViewContentModeCenter;
        [summaryView addSubview:starImageView];
        
        nextStarOriginX += 24;
    }
    
    _distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(summaryView.width - 44 * 2 - lXMargin - 80, nameLabel.bottom + lYMargin, 80, 20)];
    [_distanceLabel setFont:[UIFont systemFontOfSize:14]];
    [_distanceLabel setTextColor:NORMAL_TEXT_COLOR];
    [_distanceLabel setTextAlignment:NSTextAlignmentRight];
    [summaryView addSubview:_distanceLabel];
    
    UIView *verSplitterView = [[UIView alloc] initWithFrame:CGRectMake(_distanceLabel.right + lXMargin, lYMargin, 0.5, nameLabel.bottom + 20)];
    verSplitterView.backgroundColor = SPLITTER_COLOR;
    [summaryView addSubview:verSplitterView];
    
    UIButton *mapButton = [[UIButton alloc] initWithFrame:CGRectMake(summaryView.width - 44, 0, 44, 44)];
    [mapButton setImage:[UIImage imageNamed:@"map_normal.png"] forState:UIControlStateNormal];
    [mapButton setContentMode:UIViewContentModeCenter];
    [mapButton addTarget:self action:@selector(doShowMap) forControlEvents:UIControlEventTouchUpInside];
    [summaryView addSubview:mapButton];
    
    UIButton *telButton = [[UIButton alloc] initWithFrame:CGRectMake(mapButton.x - 44, 0, 44, 44)];
    [telButton setImage:[UIImage imageNamed:@"callout_normal.png"] forState:UIControlStateNormal];
    [telButton setContentMode:UIViewContentModeCenter];
    [telButton addTarget:self action:@selector(doCall) forControlEvents:UIControlEventTouchUpInside];
    [summaryView addSubview:telButton];
    
    UILabel *addressLabel = [[UILabel alloc] init];
    [addressLabel setFont:[UIFont systemFontOfSize:14]];
    [addressLabel setTextColor:NORMAL_TEXT_COLOR];
    [addressLabel setText:stadium.address];
    NSDictionary *attribute = @{NSFontAttributeName:addressLabel.font};
    CGSize boundingSize = CGSizeMake(summaryView.width - lXMargin * 2, 100);
    CGSize requiredSize = [addressLabel.text boundingRectWithSize:boundingSize options:NSStringDrawingTruncatesLastVisibleLine |
                           NSStringDrawingUsesLineFragmentOrigin |
                           NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    [addressLabel setFrame:CGRectMake(lXMargin, nameLabel.bottom + 32 + lYMargin, requiredSize.width, requiredSize.height)];
    addressLabel.numberOfLines = 0;
    [summaryView addSubview:addressLabel];
    
    [summaryView setHeight:addressLabel.bottom + lYMargin];
    [ShareInstances addTopBottomBorderOnView:summaryView];
    
    UIView *describeView = [[UIView alloc] init];//显示场馆简介
    describeView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:describeView];
    
    //UILabel *describeTitleLabel = [
    
    AVQuery *query = [Bulletin query];
    [query whereKey:@"stadium" equalTo:_curStadium];
    [query orderByDescending:@"timeInForce"];
    [query whereKey:@"timeToFailure" greaterThan:[NSDate date]];
    query.limit = 1;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error && objects.count > 0) {
            UIView *bulletinView = [[UIView alloc] init];
            bulletinView.backgroundColor = [UIColor whiteColor];
            [scrollView addSubview:bulletinView];
            
            UILabel *bulletinLabel = [[UILabel alloc] init];
            [bulletinLabel setFont:[UIFont systemFontOfSize:13]];
            [bulletinLabel setTextColor:NORMAL_TEXT_COLOR];
            [bulletinLabel setText:[NSString stringWithFormat:@"最新公告：%@", ((Bulletin *)[objects objectAtIndex:0]).content]];
            bulletinLabel.numberOfLines = 0;
            NSDictionary *attribute = @{NSFontAttributeName:bulletinLabel.font};
            CGSize boundingSize = CGSizeMake(scrollView.width - lXMargin * 2, 100);
            CGSize requiredSize = [bulletinLabel.text boundingRectWithSize:boundingSize options:NSStringDrawingTruncatesLastVisibleLine |
                                   NSStringDrawingUsesLineFragmentOrigin |
                                   NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
            [bulletinLabel setFrame:CGRectMake(lXMargin, lYMargin, requiredSize.width, requiredSize.height)];
            [bulletinView setFrame:CGRectMake(0, lBannerHeight, scrollView.width, bulletinLabel.height + lYMargin * 2)];
            [ShareInstances addTopBottomBorderOnView:bulletinView];
            [bulletinView addSubview:bulletinLabel];
            
            [orderView setY:orderView.y + bulletinView.height];
            [summaryView setY:summaryView.y + bulletinView.height];
        }
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLocationChanged:) name:KNOTIFICATION_LOCATIONUPDATED object:nil];
    [[CustomeLocationManager defaultManager] updateLocation];
}

#pragma mark UI初始化
-(void)initReservationViewWithContainer:(UIView *)container{

    if (mMenuHriZontal == nil) {
        mMenuHriZontal = [[ScheduleHorizontalMenu alloc] initWithFrame:CGRectMake(0, 0, container.width, MENUHEIHT) withStadium:_curStadium withDate:[NSDate date]];
        mMenuHriZontal.delegate = self;
    }
    [mMenuHriZontal clickButtonAtIndex:0];
    [container addSubview:mMenuHriZontal];
}

#pragma mark - 其他辅助功能
#pragma mark MenuHrizontalDelegate
-(void)didMenuHrizontalClickedButtonAtIndex:(NSInteger)aIndex{
    ReservationViewController *reservationVC = [[ReservationViewController alloc] initWithStadium:_curStadium];
    reservationVC.originSelectedDateIndex = aIndex;
    [self.navigationController pushViewController:reservationVC animated:YES];
}

#pragma mark ScrollPageViewDelegate
-(void)didScrollPageViewChangedPage:(NSInteger)aPage{
    [mMenuHriZontal changeButtonStateAtIndex:aPage];
    //    if (aPage == 3) {
    //刷新当页数据
    //[mScrollPageView freshContentTableAtIndex:aPage];
    //    }
}

- (void)doReturn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onLocationChanged:(NSNotification *)notification {
    double dist = [[CustomeLocationManager defaultManager] getDIstanceFromHereToAVDest:_curStadium.location];
    if (dist > 1)
        [_distanceLabel setText:[NSString stringWithFormat:@"%0.0f千米", dist / 1000]];
    else
        [_distanceLabel setText:[NSString stringWithFormat:@"%0.1f米", dist]];
}

- (void)doCall {
    if (![_curStadium.telNo isEqualToString:@""]) {
        [TelHelper callWithParentView:self.view phoneNo:_curStadium.telNo];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"该商家暂未登记电话" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

- (void)doShowMap {
    PreNavigationViewController *pnVC = [[PreNavigationViewController alloc] initWithLocation:_curStadium.location withTargetPortrait:_curStadium.portrait withTitle:_curStadium.name withSubTitle:[NSString stringWithFormat:@"电话号码:%@", _curStadium.telNo]];
    [self.navigationController pushViewController:pnVC animated:YES];
}

#pragma mark SGFocusImageFrameDelegate
- (void)loadHeaderImages {
    AVQuery *query = [StadiumImage query];
    [query whereKey:@"stadium" equalTo:_curStadium];
    [query orderByAscending:@"order"];
    query.limit = 6;
    query.cachePolicy = kAVCachePolicyNetworkElseCache;
    query.maxCacheAge = 3600 * 24 * 7;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects.count > 0) {
            self->_headImageSGItemArray = [NSMutableArray arrayWithCapacity:objects.count + 2];
            self->_headImageArray = [NSMutableArray arrayWithCapacity:objects.count];
            
            if (objects.count > 1) {//图片数大于1张时，获取最后一张图片，添加到图片列表的第一位，用于滚动
                StadiumImage *stadiumImage = (StadiumImage *)[objects objectAtIndex:objects.count - 1];
                SGFocusImageItem *firstItem = [[SGFocusImageItem alloc] initWithTitle:@"title" imageFile:stadiumImage.image tag:objects.count - 1];
                [self->_headImageSGItemArray addObject:firstItem];
            }
            
            for (int i = 0; i < objects.count; i++) {
                StadiumImage *stadiumImage = (StadiumImage *)[objects objectAtIndex:i];
                SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithTitle:@"title" imageFile:stadiumImage.image tag:i];
                [self->_headImageSGItemArray addObject:item];
                [self->_headImageArray addObject:stadiumImage.image];
            }
            
            if (objects.count > 1) {//图片数大于1张时，获取第一张图片，添加到图片列表的最后一位，用于滚动
                StadiumImage *stadiumImage = (StadiumImage *)[objects objectAtIndex:0];
                SGFocusImageItem *lastItem = [[SGFocusImageItem alloc] initWithTitle:@"title" imageFile:stadiumImage.image tag:0];
                [self->_headImageSGItemArray addObject:lastItem];
            }
            [_bannerView changeImageViewsContent:_headImageSGItemArray];
        }
    }];
}
- (void)foucusImageFrame:(SGFocusImageFrame *)imageFrame didSelectItem:(SGFocusImageItem *)item
{
    ImgShowViewController *imgShowVC = [[ImgShowViewController alloc] initWithSourceData:_headImageArray withIndex:item.tag];
    [self.navigationController pushViewController:imgShowVC animated:YES];
}
- (void)foucusImageFrame:(SGFocusImageFrame *)imageFrame currentItem:(int)index;
{
    //    NSLog(@"%s \n scrollToIndex===>%d",__FUNCTION__,index);
}

@end
