//
//  TelephoneHelper.m
//  Bauma360
//
//  Created by TsaoLipeng on 14/12/7.
//  Copyright (c) 2014年 TsaoLipeng. All rights reserved.
//

#import "TelephoneHelper.h"

@implementation TelephoneHelper

+ (void)callPhone:(NSString *)phoneNumber
{
    //phoneNumber = "18369......"
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",phoneNumber];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}

@end
