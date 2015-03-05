//
//  TableCellDelegates.h
//  Bauma360
//
//  Created by TsaoLipeng on 14-10-17.
//  Copyright (c) 2014年 TsaoLipeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Article.h"
#import "Resell.h"

@protocol CustomTableCellDelegate <NSObject>
@required;
-(void)showArticle:(Article *)article;

@end

@protocol ResellOuterDelegate <NSObject>
@required;
-(void)showResell:(Resell *)resell;
-(void)showCertificate:(Resell *)resell;
-(void)callOwner:(AVUser *)owner;
@end