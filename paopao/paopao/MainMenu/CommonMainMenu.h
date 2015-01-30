//
//  CommonMenu.h
//  paopao
//
//  Created by TsaoLipeng on 15/1/29.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JKSideSlipView.h"

@protocol CommonMainMenuDelegate <NSObject>

@required
-(void)ShowView:(UIView *)newView withTitle:(NSString *)title withRemoveLastView:(UIView *)lastView;

@end

@interface CommonMenu : NSObject

@property (nonatomic, strong) JKSideSlipView *sideSlipView;

@property (nonatomic, assign) id<CommonMainMenuDelegate> delegate;

- (instancetype)initWithRootController:(UIViewController *)controller;
- (JKSideSlipView *)createMainMenuWithSender:(id)sender;

@end
