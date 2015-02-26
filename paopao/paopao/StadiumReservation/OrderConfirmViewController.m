//
//  OrderConfirmViewController.m
//  paopao
//
//  Created by TsaoLipeng on 15/2/26.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import "OrderConfirmViewController.h"
#import "NormalNavigationBar.h"
#import "UIView+XD.h"
#import "Defines.h"
#import "SessionModel.h"
#import "DateTimeHelper.h"

#define kMargin 10
#define kSplitterHeight 1
#define kLabelHeight 30
#define kTitleLabelHeight 51

@interface OrderConfirmViewController() <NormalNavigationDelegate> {
    Stadium *orderStadium;
    NSDate *orderDate;
    NSArray *orderedSessions;
}

@property (nonatomic, strong) NormalNavigationBar *navigationBar;

@end

@implementation OrderConfirmViewController

- (instancetype)initWithStadium:(Stadium *)stadium withOrderDate:(NSDate *)date withOrderedSessions:(NSArray *)sessions {
    self = [super init];
    orderStadium = stadium;
    orderDate = date;
    orderedSessions = [NSArray arrayWithArray:sessions];
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.navigationBar = [[NormalNavigationBar alloc] initWithTitle:@"场馆预订"];
    self.navigationBar.delegate = self;
    [self.view addSubview:self.navigationBar];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT + STATU_BAR_HEIGHT, self.view.width, self.view.height - NAVIGATION_BAR_HEIGHT - STATU_BAR_HEIGHT)];
    [scrollView setBackgroundColor:DARK_BACKGROUND_COLOR];
    [self.view addSubview:scrollView];
    
    UIView *summaryView = [[UIView alloc] initWithFrame:CGRectMake(kMargin, kMargin, self.view.width - kMargin * 2, 300)];
    [summaryView setBackgroundColor:[UIColor whiteColor]];
    summaryView.layer.cornerRadius = 4;
    [scrollView addSubview:summaryView];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMargin, 5, summaryView.width - kMargin * 2, kLabelHeight)];
    [titleLabel setTextColor:[UIColor orangeColor]];
    [titleLabel setFont:[UIFont systemFontOfSize:18]];
    [titleLabel setText:@"订购详情，请核对"];
    [summaryView addSubview:titleLabel];
    UILabel *stadiumNameLabel = [self createLabelAndSetCommonPropWithFrame:CGRectMake(kMargin, titleLabel.bottom, titleLabel.width, kLabelHeight)];
    [stadiumNameLabel setText:[NSString stringWithFormat:@"场馆：%@", orderStadium.name]];
    [summaryView addSubview:stadiumNameLabel];
    UILabel *stadiumAddrLabel = [self createLabelAndSetCommonPropWithFrame:CGRectMake(kMargin, stadiumNameLabel.bottom, stadiumNameLabel.width, kLabelHeight)];
    [stadiumAddrLabel setText:[NSString stringWithFormat:@"地址：%@", orderStadium.address]];
    [summaryView addSubview:stadiumAddrLabel];
    UIView *spLine1 = [[UIView alloc] initWithFrame:CGRectMake(kMargin, stadiumAddrLabel.bottom, stadiumAddrLabel.width, kSplitterHeight)];
    [spLine1 setBackgroundColor:NORMAL_BACKGROUND_COLOR];
    [summaryView addSubview:spLine1];
    UILabel *dateLable = [self createLabelAndSetCommonPropWithFrame:CGRectMake(kMargin, spLine1.bottom, stadiumAddrLabel.width, kLabelHeight)];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if (![DateTimeHelper date:[NSDate date] isEqualOtherDate:orderDate]) {
        [dateFormatter setDateFormat:@"日期：YY-MM-dd\tEEE"];
    } else {
        [dateFormatter setDateFormat:@"日期：YY-MM-dd\t今天"];
    }
    [dateLable setText:[dateFormatter stringFromDate:orderDate]];
    [summaryView addSubview:dateLable];
    UILabel *sessionTitleLabel = [self createLabelAndSetCommonPropWithFrame:CGRectMake(kMargin, dateLable.bottom, kTitleLabelHeight, kLabelHeight)];
    [sessionTitleLabel setText:@"场次："];
    [summaryView addSubview:sessionTitleLabel];
    UIView *sessionListView = [[UIView alloc] initWithFrame:CGRectMake(sessionTitleLabel.right, sessionTitleLabel.y, summaryView.width - sessionTitleLabel.width - kMargin, kLabelHeight * orderedSessions.count)];
    [summaryView addSubview:sessionListView];
    CGFloat lastSessionLabelBottom = 0.0f;
    NSInteger amount = 0;
    for (SessionModel *model in orderedSessions) {
        UILabel *sessionLabel = [self createLabelAndSetCommonPropWithFrame:CGRectMake(0, lastSessionLabelBottom, sessionListView.width, kLabelHeight)];
        lastSessionLabelBottom = sessionLabel.bottom;
        [sessionLabel setText:[NSString stringWithFormat:@"%02ld:00-%02ld:00\t%@\t%ld元", model.sessionTime, model.sessionTime +1, model.sportField.name, model.price]];
        [sessionListView addSubview:sessionLabel];
        
        amount += model.price;
    }
    UIView *spLine2 = [[UIView alloc] initWithFrame:CGRectMake(kMargin, sessionListView.bottom, stadiumAddrLabel.width, kSplitterHeight)];
    [spLine2 setBackgroundColor:NORMAL_BACKGROUND_COLOR];
    [summaryView addSubview:spLine2];
    UILabel *amountTitleLabel = [self createLabelAndSetCommonPropWithFrame:CGRectMake(kMargin, spLine2.bottom, kTitleLabelHeight, kLabelHeight)];
    [amountTitleLabel setText:@"金额："];
    [summaryView addSubview:amountTitleLabel];
    UILabel *amountLable = [self createLabelAndSetCommonPropWithFrame:CGRectMake(amountTitleLabel.right, amountTitleLabel.y, summaryView.width - amountTitleLabel.width - kMargin, kLabelHeight)];
    [amountLable setText:[NSString stringWithFormat:@"%ld元", amount]];
    [amountLable setTextColor:[UIColor redColor]];
    [amountLable setFont:[UIFont systemFontOfSize:18]];
    [summaryView addSubview:amountLable];
    [summaryView setHeight:amountLable.bottom + kMargin];//重新设置summary的高度
}

- (UILabel *)createLabelAndSetCommonPropWithFrame:(CGRect)frame {
    UILabel *ret = [[UILabel alloc] initWithFrame:frame];
    [ret setBackgroundColor:[UIColor whiteColor]];
    [ret setTextColor:[UIColor grayColor]];
    [ret setFont:[UIFont systemFontOfSize:17]];
    return ret;
}

- (void)doReturn {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
