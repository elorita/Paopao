//
//  HomeVC.h
//  ShowProduct
//
//  Created by lin on 14-5-22.
//  Copyright (c) 2014年 @"". All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableOuterProtocols.h"
#import "PPImageScrollingCellView.h"

@interface HomeVC : UIViewController<CustomTableCellDelegate,ResellOuterDelegate,PPImageScrollingViewDelegate>

-(void)showArticle:(Article *)article;

@end
