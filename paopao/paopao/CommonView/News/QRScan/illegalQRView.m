//
//  illegalQRView.m
//  Bauma360
//
//  Created by TsaoLipeng on 15/1/1.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import "illegalQRView.h"

@implementation illegalQRView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame controller:(UIViewController *)controller{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.homeViewController = controller;
    }
    return self;
}

- (void)ShowIllegalInfo {
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
