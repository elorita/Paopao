//
//  PaymentViewController.m
//  paopao
//
//  Created by TsaoLipeng on 15/2/27.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import "PaymentViewController.h"
#import "NormalNavigationBar.h"
#import "Defines.h"
#import "UIView+XD.h"
#import "DateTimeHelper.h"
#import "Stadium.h"
#import "SVProgressHUD.h"
#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import "Pingpp.h"

#define kMargin 10
#define kLabelMargin 5
#define kSplitterHeight 1
#define kLabelHeight 26
#define kTextSize 14
#define kTitleLabelWidth 42
#define kButtonHeight 40

#define kWaiting          @"正在获取支付凭据,请稍后..."
#define kNote             @"提示"
#define kConfirm          @"确定"
#define kErrorNet         @"网络错误"
#define kResult           @"支付结果：%@"

#define kUrlScheme      @"YOUR-APP-URL-SCHEME"
#define kUrl            @"http://elorita.sinaapp.com/example/pay.php"

@interface PaymentViewController() <NormalNavigationDelegate>

@property (nonatomic, strong) NormalNavigationBar *navigationBar;
@property (nonatomic, strong) UILabel *payHintLabel;
@property (nonatomic, strong) UIButton *wxButton;
@property (nonatomic, strong) UIButton *alipayButton;
@property (nonatomic, strong) UIButton *upmpButton;
@property (nonatomic, strong) UIButton *bfbButton;

@end

@implementation PaymentViewController{
    ReservationOrder *curOrder;
    NSTimer *_timer;
    NSString *channel;
}

- (instancetype)initWithReservationOrder:(ReservationOrder *)order {
    self = [super init];
    curOrder = order;
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimerTime:) userInfo:nil repeats:YES];
    
    self.navigationBar = [[NormalNavigationBar alloc] initWithTitle:@"订单支付"];
    self.navigationBar.delegate = self;
    [self.view addSubview:self.navigationBar];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT + STATU_BAR_HEIGHT, self.view.width, self.view.height - NAVIGATION_BAR_HEIGHT - STATU_BAR_HEIGHT - kButtonHeight - kMargin * 2)];
    [scrollView setBackgroundColor:DARK_BACKGROUND_COLOR];
    [self.view addSubview:scrollView];
    
    UIView *summaryView = [[UIView alloc] initWithFrame:CGRectMake(kMargin, kMargin, self.view.width - kMargin * 2, 300)];
    [summaryView setBackgroundColor:[UIColor whiteColor]];
    summaryView.layer.cornerRadius = 4;
    [scrollView addSubview:summaryView];
    
    UILabel *stadiumNameLabel = [self createLabelAndSetCommonPropWithFrame:CGRectMake(kMargin, kLabelMargin, summaryView.width - kMargin * 2, kLabelHeight)];
    [stadiumNameLabel setText:@"正在获取场馆..."];
    [curOrder.stadium fetchIfNeededInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        if (!error) {
            [stadiumNameLabel setText:[NSString stringWithFormat:@"场馆：%@", ((Stadium*)object).name]];
        }
    }];
    [summaryView addSubview:stadiumNameLabel];
    
    UILabel *dateLable = [self createLabelAndSetCommonPropWithFrame:CGRectMake(kMargin, stadiumNameLabel.bottom, stadiumNameLabel.width, kLabelHeight)];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if (![DateTimeHelper date:[NSDate date] isEqualOtherDate:curOrder.date]) {
        [dateFormatter setDateFormat:@"日期：YY-MM-dd\tEEE"];
    } else {
        [dateFormatter setDateFormat:@"日期：YY-MM-dd\t今天"];
    }
    [dateLable setText:[dateFormatter stringFromDate:curOrder.date]];
    [summaryView addSubview:dateLable];
    
    UIView *spLine1 = [[UIView alloc] initWithFrame:CGRectMake(kMargin, dateLable.bottom, dateLable.width, kSplitterHeight)];
    [spLine1 setBackgroundColor:NORMAL_BACKGROUND_COLOR];
    [summaryView addSubview:spLine1];
    
    UILabel *amountTitleLabel = [self createLabelAndSetCommonPropWithFrame:CGRectMake(kMargin, spLine1.bottom, kTitleLabelWidth, kLabelHeight)];
    [amountTitleLabel setText:@"金额："];
    [summaryView addSubview:amountTitleLabel];
    
    UILabel *amountLable = [self createLabelAndSetCommonPropWithFrame:CGRectMake(amountTitleLabel.right, amountTitleLabel.y, summaryView.width - amountTitleLabel.width - kMargin * 2, kLabelHeight)];
    [amountLable setText:[NSString stringWithFormat:@"%ld元", [curOrder.amount integerValue]]];
    [amountLable setTextAlignment:NSTextAlignmentRight];
    [amountLable setFont:[UIFont systemFontOfSize:kTextSize + 2]];
    [summaryView addSubview:amountLable];
    [summaryView setHeight:amountLable.bottom + kLabelMargin];//重新设置summary的高度
    
    UIView *couponView = [[UIView alloc] initWithFrame:CGRectMake(kMargin, summaryView.bottom + kMargin, summaryView.width, 100)];
    [couponView setBackgroundColor:[UIColor whiteColor]];
    couponView.layer.cornerRadius = 4;
    [scrollView addSubview:couponView];
    
    UILabel *couponTitleLabel = [self createLabelAndSetCommonPropWithFrame:CGRectMake(kMargin, kLabelMargin, kTitleLabelWidth * 2, kLabelHeight)];
    [couponTitleLabel setText:@"优惠金额："];
    [couponView addSubview:couponTitleLabel];
    
    UILabel *couponLable = [self createLabelAndSetCommonPropWithFrame:CGRectMake(couponTitleLabel.right, couponTitleLabel.y, couponView.width - couponTitleLabel.width - kMargin * 2, kLabelHeight)];
    [couponLable setText:[NSString stringWithFormat:@"%d元", 0]];
    [couponLable setTextAlignment:NSTextAlignmentRight];
    [couponLable setFont:[UIFont systemFontOfSize:kTextSize + 2]];
    [couponView addSubview:couponLable];
    
    UIView *spLine2 = [[UIView alloc] initWithFrame:CGRectMake(kMargin, couponLable.bottom, spLine1.width, kSplitterHeight)];
    [spLine1 setBackgroundColor:NORMAL_BACKGROUND_COLOR];
    [couponView addSubview:spLine2];
    
    UILabel *finalAmountTitleLabel = [self createLabelAndSetCommonPropWithFrame:CGRectMake(kMargin, spLine2.bottom, kTitleLabelWidth * 2, kLabelHeight)];
    [finalAmountTitleLabel setText:@"支付金额："];
    [couponView addSubview:finalAmountTitleLabel];
    
    UILabel *finalAmountLable = [self createLabelAndSetCommonPropWithFrame:CGRectMake(finalAmountTitleLabel.right, finalAmountTitleLabel.y, couponView.width - finalAmountTitleLabel.width - kMargin * 2, kLabelHeight)];
    [finalAmountLable setText:[NSString stringWithFormat:@"%ld元", [curOrder.amount integerValue]]];
    [finalAmountLable setTextColor:[UIColor orangeColor]];
    [finalAmountLable setTextAlignment:NSTextAlignmentRight];
    [finalAmountLable setFont:[UIFont systemFontOfSize:kTextSize + 2]];
    [couponView addSubview:finalAmountLable];
    [couponView setHeight:finalAmountLable.bottom + kLabelMargin];//重新设置summary的高度
    
    _payHintLabel = [self createLabelAndSetCommonPropWithFrame:CGRectMake(kMargin, couponView.bottom, couponView.width, kLabelHeight)];
    [_payHintLabel setBackgroundColor:[UIColor clearColor]];
    [scrollView addSubview:_payHintLabel];
    
    
    UIView *payView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bottom - (kButtonHeight + kMargin) * 4 - kMargin, scrollView.width, (kButtonHeight + kMargin) * 4 + kMargin)];
    payView.backgroundColor = scrollView.backgroundColor;
    [self.view addSubview:payView];
    
    UIButton* wxButton = [[UIButton alloc] initWithFrame:CGRectMake(kMargin, kMargin, payView.width - kMargin * 2, kButtonHeight)];
    [wxButton setTitle:@"微信" forState:UIControlStateNormal];
    [wxButton addTarget:self action:@selector(normalPayAction:) forControlEvents:UIControlEventTouchUpInside];
    wxButton.layer.cornerRadius = 4.0f;
    wxButton.layer.masksToBounds = YES;
    wxButton.titleLabel.textColor = [UIColor whiteColor];
    wxButton.backgroundColor = [UIColor orangeColor];
    wxButton.titleLabel.font = [UIFont systemFontOfSize:kTextSize];
    [wxButton setTag:1];
    [payView addSubview:wxButton];
    
    UIButton* alipayButton = [[UIButton alloc] initWithFrame:CGRectMake(kMargin, wxButton.bottom + kMargin, wxButton.width, kButtonHeight)];
    [alipayButton setTitle:@"支付宝" forState:UIControlStateNormal];
    [alipayButton addTarget:self action:@selector(normalPayAction:) forControlEvents:UIControlEventTouchUpInside];
    alipayButton.layer.cornerRadius = 4.0f;
    alipayButton.layer.masksToBounds = YES;
    alipayButton.titleLabel.textColor = [UIColor whiteColor];
    alipayButton.backgroundColor = [UIColor orangeColor];
    alipayButton.titleLabel.font = [UIFont systemFontOfSize:kTextSize];
    [alipayButton setTag:2];
    [payView addSubview:alipayButton];
    
    UIButton* upmpButton = [[UIButton alloc] initWithFrame:CGRectMake(kMargin, alipayButton.bottom + kMargin, alipayButton.width, kButtonHeight)];;
    [upmpButton setTitle:@"银联" forState:UIControlStateNormal];
    [upmpButton addTarget:self action:@selector(normalPayAction:) forControlEvents:UIControlEventTouchUpInside];
    upmpButton.layer.cornerRadius = 4.0f;
    upmpButton.layer.masksToBounds = YES;
    upmpButton.titleLabel.textColor = [UIColor whiteColor];
    upmpButton.backgroundColor = [UIColor orangeColor];
    upmpButton.titleLabel.font = [UIFont systemFontOfSize:kTextSize];
    [upmpButton setTag:3];
    [payView addSubview:upmpButton];
    
    UIButton* bfbButton = [[UIButton alloc] initWithFrame:CGRectMake(kMargin, upmpButton.bottom + kMargin, upmpButton.width, kButtonHeight)];;
    [bfbButton setTitle:@"百度钱包" forState:UIControlStateNormal];
    [bfbButton addTarget:self action:@selector(normalPayAction:) forControlEvents:UIControlEventTouchUpInside];
    [bfbButton setFrame:CGRectMake(kMargin, upmpButton.bottom + kMargin, upmpButton.width, kButtonHeight)];
    bfbButton.layer.cornerRadius = 4.0f;
    bfbButton.layer.masksToBounds = YES;
    bfbButton.titleLabel.textColor = [UIColor whiteColor];
    bfbButton.backgroundColor = [UIColor orangeColor];
    bfbButton.titleLabel.font = [UIFont systemFontOfSize:kTextSize];
    [bfbButton setTag:4];
    [payView addSubview:bfbButton];
}

- (UILabel *)createLabelAndSetCommonPropWithFrame:(CGRect)frame {
    UILabel *ret = [[UILabel alloc] initWithFrame:frame];
    [ret setBackgroundColor:[UIColor whiteColor]];
    [ret setTextColor:[UIColor grayColor]];
    [ret setFont:[UIFont systemFontOfSize:kTextSize]];
    return ret;
}

- (void)onTimerTime:(NSTimer *)timer {
    NSInteger timeInterval = 60 * 15 - [[NSDate date] timeIntervalSinceDate:curOrder.generateDateTime];
    if (timeInterval >= 0) {
        [_payHintLabel setText:[NSString stringWithFormat:@"请在 %d分%d秒 内完成支付，超时订单将取消", (int)(timeInterval/60), (int)(timeInterval%60)]];
    } else {
        [_payHintLabel setText:@"订单已过期，请返回重新下单"];
        [_timer invalidate];
        _payHintLabel.enabled = NO;
    }
}

- (void)normalPayAction:(id)sender
{
    NSInteger tag = ((UIButton*)sender).tag;
    if (tag == 1) {
        channel = @"wx";
        //[self normalPayAction:nil];
    } else if (tag == 2) {
        channel = @"alipay";
    } else if (tag == 3) {
        channel = @"upacp";
    } else if (tag == 4) {
        channel = @"bfb";
    } else {
        return;
    }
    
    NSString *amountStr = [NSString stringWithFormat:@"%lld", [curOrder.amount longLongValue]];
    NSDictionary* dict = @{
                           @"channel" : channel,
                           @"amount"  : amountStr
                           };
    
    NSURL* url = [NSURL URLWithString:kUrl];
    NSMutableURLRequest * postRequest=[NSMutableURLRequest requestWithURL:url];
    NSData* data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *bodyData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    [postRequest setHTTPBody:[NSData dataWithBytes:[bodyData UTF8String] length:strlen([bodyData UTF8String])]];
    [postRequest setHTTPMethod:@"POST"];
    [postRequest setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    PaymentViewController * __weak weakSelf = self;
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [SVProgressHUD showWithStatus:@"正在获取支付凭据，请稍候"];
    [NSURLConnection sendAsynchronousRequest:postRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
        [SVProgressHUD dismiss];
        if (httpResponse.statusCode != 200) {
            [SVProgressHUD showErrorWithStatus:@"网络故障，请稍后重试" duration:2];
            return;
        }
        if (connectionError != nil) {
            NSLog(@"error = %@", connectionError);
            [SVProgressHUD showErrorWithStatus:@"网络故障，请稍后重试" duration:2];
            return;
        }
        NSString* charge = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"charge = %@", charge);
        dispatch_async(dispatch_get_main_queue(), ^{
            [Pingpp createPayment:charge viewController:weakSelf appURLScheme:kUrlScheme withCompletion:^(NSString *result, PingppError *error) {
                NSLog(@"completion block: %@", result);
                if (error == nil) {
                    NSLog(@"PingppError is nil");
                } else {
                    NSLog(@"PingppError: code=%lu msg=%@", (unsigned  long)error.code, [error getMsg]);
                }
                [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"支付成功：%@", result]];
            }];
        });
    }];
}

- (void)doReturn {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
