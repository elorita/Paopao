//
//  ShowProductInfoViewController.h
//  思木科技
//
//  Created by TsaoLipeng on 14-5-7.
//  Copyright (c) 2014年 TsaoLipeng. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ProductInfo.h"

@interface ShowProductInfoViewController : UIViewController

@property(nonatomic, strong) IBOutlet UILabel* lblSn;
@property(nonatomic, strong) IBOutlet UILabel* lblCategoryName;
@property(nonatomic, strong) IBOutlet UILabel* lblVendorName;
@property(nonatomic, strong) IBOutlet UILabel* lbkModelAdapted;
@property(nonatomic, strong) IBOutlet UILabel* lblProductDate;
@property(nonatomic, strong) IBOutlet UILabel* lblFactoryDate;
@property(nonatomic, strong) IBOutlet UILabel* lblSmCode;
@property(nonatomic, strong) IBOutlet UILabel* lblSize;
@property(nonatomic, strong) IBOutlet UILabel* lblOwner;

-(void) setProductID:(NSString *) oid;
-(void) showWarning;

@end
