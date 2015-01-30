//
//  StadiumViewController.h
//  paopao
//
//  Created by TsaoLipeng on 15/1/29.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StadiumView : UIView

- (id)initWithFrame:(CGRect)frame withController:(UIViewController *)controller;

@property(nonatomic,retain) UIViewController *homeViewController;

@end
