//
//  ShowProductView.h
//  Bauma360
//
//  Created by TsaoLipeng on 14/12/29.
//  Copyright (c) 2014年 TsaoLipeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RFID.h"
#import "Product.h"

@interface ShowProductView : UIScrollView

- (id)initWithFrame:(CGRect)frame controller:(UIViewController *)controller;

@property(nonatomic,retain) UIViewController *homeViewController;

-(void)ShowRfid:(RFID *)rfid;
-(void)ShowRfid:(RFID *)rfid andProduct:(Product *)product;
-(void)ShowWarning;

-(void)ShowLabelContainerRect;

@end
