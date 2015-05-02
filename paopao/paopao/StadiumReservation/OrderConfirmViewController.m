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
#import "ReservationOrder.h"
#import "ReservationSuborder.h"
#import "SVProgressHUD.h"
#import "PaymentViewController.h"
#import <Pingpp.h>

#define kMargin 10
#define kSplitterHeight 1
#define kLabelHeight 26
#define kTextSize 14
#define kTitleLabelHeight 42
#define kButtonHeight 40

#define kUrlScheme      @"paopao"
#define kUrl            @"http://elorita.sinaapp.com/example/pay.php"

@interface OrderConfirmViewController() <NormalNavigationDelegate> {
    Stadium *orderStadium;
    NSDate *orderDate;
    NSArray *orderedSessions;
    NSInteger amount;
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
    
    self.navigationBar = [[NormalNavigationBar alloc] initWithTitle:@"确认订单"];
    self.navigationBar.delegate = self;
    [self.view addSubview:self.navigationBar];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT + STATU_BAR_HEIGHT, self.view.width, self.view.height - NAVIGATION_BAR_HEIGHT - STATU_BAR_HEIGHT - kButtonHeight - kMargin * 2)];
    [scrollView setBackgroundColor:DARK_BACKGROUND_COLOR];
    [self.view addSubview:scrollView];
    
    UIView *summaryView = [[UIView alloc] initWithFrame:CGRectMake(kMargin, kMargin, self.view.width - kMargin * 2, 300)];
    [summaryView setBackgroundColor:[UIColor whiteColor]];
    summaryView.layer.cornerRadius = 4;
    [scrollView addSubview:summaryView];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMargin, 5, summaryView.width - kMargin * 2, kLabelHeight)];
    [titleLabel setTextColor:[UIColor orangeColor]];
    [titleLabel setFont:[UIFont systemFontOfSize:kTextSize + 2]];
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
    amount = 0;
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
    [amountLable setFont:[UIFont systemFontOfSize:kTextSize + 2]];
    [summaryView addSubview:amountLable];
    [summaryView setHeight:amountLable.bottom + kMargin];//重新设置summary的高度
    
    UILabel *phoneNoLabel = [self createLabelAndSetCommonPropWithFrame:CGRectMake(summaryView.x, summaryView.bottom + kMargin, summaryView.width, kLabelHeight)];
    [phoneNoLabel setText:[NSString stringWithFormat:@"确认您的手机号：%@", [AVUser currentUser].mobilePhoneNumber]];
    [phoneNoLabel setBackgroundColor:[UIColor clearColor]];
    [scrollView addSubview:phoneNoLabel];
    
    UIButton *submitButton = [[UIButton alloc] initWithFrame:CGRectMake(kMargin, self.view.bottom - kButtonHeight - kMargin, summaryView.width, 40)];
    submitButton.layer.cornerRadius = 4.0f;
    submitButton.layer.masksToBounds = YES;
    submitButton.backgroundColor = [UIColor orangeColor];
    [submitButton setTitle:@"提交订单" forState:UIControlStateNormal];
    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitButton.titleLabel setFont:[UIFont systemFontOfSize:kTextSize]];
    [submitButton addTarget:self action:@selector(doSubmit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitButton];
}

- (UILabel *)createLabelAndSetCommonPropWithFrame:(CGRect)frame {
    UILabel *ret = [[UILabel alloc] initWithFrame:frame];
    [ret setBackgroundColor:[UIColor whiteColor]];
    [ret setTextColor:[UIColor grayColor]];
    [ret setFont:[UIFont systemFontOfSize:kTextSize]];
    return ret;
}

- (void)doReturn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)doSubmit {
    ReservationOrder *order = [[ReservationOrder alloc] init];
//    order.generateDateTime = [NSDate date];
//    order.date = orderDate;
//    order.stadium = orderStadium;
//    order.user = [AVUser currentUser];
    [order setObject:[NSDate date] forKey:@"generateDateTime"];
    [order setObject:[orderDate dateByAddingTimeInterval:1] forKey:@"date"];
    [order setObject:orderStadium forKey:@"stadium"];
    [order setObject:[NSNumber numberWithInteger:amount] forKey:@"amount"];
    [order setObject:[NSNumber numberWithInteger:orderedSessions.count] forKeyedSubscript:@"suborderCount"];
    [order setObject:[AVUser currentUser] forKey:@"user"];
    [SVProgressHUD showWithStatus:@"正在生成订单"];
    
    [order saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            [SVProgressHUD dismiss];
            [SVProgressHUD showWithStatus:@"正在锁定场次"];
            
            NSMutableArray *subordersContent = [[NSMutableArray alloc] init];
            AVRelation *suborderRelation = [order relationforKey:@"suborders"];
            for (SessionModel *model in orderedSessions) {
                ReservationSuborder *suborder = [[ReservationSuborder alloc] init];
                [suborder setObject:order.generateDateTime forKey:@"generateDateTime"];
                [suborder setObject:order.date forKey:@"date"];
                [suborder setObject:[NSNumber numberWithInteger:model.sessionTime] forKey:@"time"];
                [suborder setObject:order.stadium forKey:@"stadium"];
                [suborder setObject:model.sportField forKey:@"sportField"];
                [suborder setObject:[NSNumber numberWithInteger:model.price] forKey:@"price"];
                [suborder setObject:order.user forKey:@"user"];
                [suborder setObject:[NSNumber numberWithBool:NO] forKey:@"isPaid"];
                if ([suborder save])
                    [suborderRelation addObject:suborder];
                else{
                    [SVProgressHUD showErrorWithStatus:@"网络故障，请稍后重试" duration:2];
                    return;
                }
            }
            
            [order saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    [SVProgressHUD dismiss];
                    PaymentViewController *paymentVC = [[PaymentViewController alloc] initWithReservationOrder:order];
                    [self.navigationController pushViewController:paymentVC animated:YES];
                }
                else{
                    [SVProgressHUD showErrorWithStatus:@"网络故障，请稍后重试" duration:2];
                    return;
                }
            }];
        } else {
            [SVProgressHUD showErrorWithStatus:@"网络故障，请稍后重试" duration:2];
        }
    }];
}

@end
