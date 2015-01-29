//
//  ViewController.h
//  paopao
//
//  Created by TsaoLipeng on 15/1/28.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKSideSlipView.h"

@interface ViewController : UIViewController
{
    JKSideSlipView *_sideSlipView;
}
- (IBAction)switchTouched:(id)sender;

@end

