//
//  StadiumViewController.h
//  paopao
//
//  Created by TsaoLipeng on 15/1/29.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"

@interface StadiumView : UIView

- (id)initWithFrame:(CGRect)frame withController:(UIViewController *)controller;

- (void)forceRefresh;

@property(nonatomic,weak) RootViewController *homeViewController;

@end
