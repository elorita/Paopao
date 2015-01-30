//
//  NormalNavigationBar.h
//  paopao
//
//  Created by TsaoLipeng on 15/1/30.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NormalNavigationDelegate <NSObject>

@required
- (void)doReturn;

@end

@interface NormalNavigationBar : UIView

@property (nonatomic, weak) id<NormalNavigationDelegate> delegate;

- (instancetype)initWithTitle:(NSString *)title;

@end
