//
//  ShowProductInfoViewController.m
//  思木科技
//
//  Created by TsaoLipeng on 14-5-7.
//  Copyright (c) 2014年 TsaoLipeng. All rights reserved.
//

#import "ShowProductInfoViewController.h"
#import <AVOSCloud/AVOSCloud.h>
#import "RFID.h"
#import "Product.h"
#import "ShowProductView.h"
#import "CustomColor.h"

@interface ShowProductInfoViewController ()

@end

@implementation ShowProductInfoViewController
{
    ShowProductView *showProductView;
    RFID *rfid;
    Product *product;
}

@synthesize lblSn, lblCategoryName, lblVendorName, lbkModelAdapted, lblProductDate, lblFactoryDate, lblSmCode, lblSize, lblOwner;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createContentView];
}

- (UIView *)createContentView {
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout =UIRectEdgeNone ;
    }
    
    UIView *vContentView = [[UIView alloc] initWithFrame:[self getContentViewRect]];
    [vContentView setBackgroundColor:[UIColor orangeColor]];
    
    self.view = vContentView;
    
    UIButton *returnButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 10, 44, 44)];
    [returnButton setImage:[UIImage imageNamed:@"return.png"] forState:UIControlStateNormal];
    [returnButton addTarget:self action:@selector(clickReturn:) forControlEvents:UIControlEventTouchUpInside];
    [vContentView addSubview: returnButton];
    
    return vContentView;
}

- (CGRect)getContentViewRect {
    int vWidth = (int)([UIScreen mainScreen].bounds.size.width);
    int vHeight = (int)([UIScreen mainScreen].bounds.size.height);
    return CGRectMake(0, 44 + 10, vWidth, vHeight);
}

-(void) setProductID:(NSString *) oid{
    AVQuery *query = [RFID query];
    if (oid.length == 32){
        NSMutableString * guid = [NSMutableString stringWithString:oid];
        [guid insertString:@"-" atIndex:8];
        [guid insertString:@"-" atIndex:13];
        [guid insertString:@"-" atIndex:18];
        [guid insertString:@"-" atIndex:23];
        [query whereKey:@"guid" equalTo:guid];
    }else
        [query whereKey:@"objectId" equalTo:oid];
    
    query.cachePolicy = kPFCachePolicyNetworkElseCache;
    query.maxCacheAge = 3600*24*30;//缓存一月时间
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error && objects.count > 0){
            self->rfid = [objects objectAtIndex:0];
            [self ShowProduct];
        } else {
            [self showWarning];
        }
    }];
}

-(void) ShowProduct
{
    if (self->rfid != nil){
        AVQuery *query = [Product query];
        [query whereKey:@"rfid" equalTo:self->rfid];
        query.cachePolicy = kPFCachePolicyNetworkElseCache;
        query.maxCacheAge = 3600*24*30;
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            self->showProductView = [[ShowProductView alloc] initWithFrame:[self getContentViewRect] controller:self];
            if (!error && objects.count > 0){
                self->product = [objects objectAtIndex:0];
                [self->showProductView ShowRfid:self->rfid andProduct:self->product];
                [self.view addSubview:self->showProductView];
            } else {
                [self->showProductView ShowRfid:self->rfid];
                [self.view addSubview:self->showProductView];
            }
        }];
    }
}

-(void) showWarning {
    self->showProductView = [[ShowProductView alloc] initWithFrame:[self getContentViewRect] controller:self];
    [self->showProductView ShowWarning];
    [self.view addSubview:self->showProductView];
}

-(void)clickReturn:(UIButton*)sender
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
