//
//  ShowProductView.m
//  Bauma360
//
//  Created by TsaoLipeng on 14/12/29.
//  Copyright (c) 2014年 TsaoLipeng. All rights reserved.
//

#import "ShowProductView.h"

@implementation ShowProductView {
    UILabel* lblSn;
    UILabel* lblCategoryName;
    UILabel* lblVendorName;
    UILabel* lbkModelAdapted;
    UILabel* lblProductDate;
    UILabel* lblFactoryDate;
    UILabel* lblSmCode;
    UILabel* lblSize;
    UILabel* lblWeight;
    UILabel* lblOwner;
    
    UIView* labelContainerView;
}

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

- (void)initLabel:(UILabel *)label {
    labelContainerView.frame = CGRectMake(0, 0, labelContainerView.frame.size.width, labelContainerView.frame.size.height + 10 + 20);
    CGRect frame = CGRectMake(10, labelContainerView.frame.size.height + 10, self.frame.size.width, 20);
    label.frame = frame;
    [label setTextColor:[UIColor whiteColor]];
    [labelContainerView addSubview:label];
}

- (void)initLabelNContainerWhenShowProduct {
    labelContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0)];
    
    lblSn = [[UILabel alloc] init];
    lblCategoryName = [[UILabel alloc] init];
    lblVendorName = [[UILabel alloc] init];
    lbkModelAdapted = [[UILabel alloc] init];
    lblProductDate = [[UILabel alloc] init];
    lblFactoryDate = [[UILabel alloc] init];
    lblSmCode = [[UILabel alloc] init];
    lblSize = [[UILabel alloc] init];
    lblWeight = [[UILabel alloc] init];
    lblOwner = [[UILabel alloc] init];
    
    [self initLabel:lblCategoryName];
    [self initLabel:lblSn];
    [self initLabel:lblVendorName];
    [self initLabel:lbkModelAdapted];
    [self initLabel:lblProductDate];
    [self initLabel:lblFactoryDate];
    [self initLabel:lblSmCode];
    [self initLabel:lblSize];
    [self initLabel:lblWeight];
    [self initLabel:lblOwner];
    
    [self addSubview:labelContainerView];
}

- (void)initLabelNContainerWhenShowRfid {
    labelContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0)];
    
    
    lblCategoryName = [[UILabel alloc] init];
    lblSmCode = [[UILabel alloc] init];
    lblVendorName = [[UILabel alloc] init];
    
    [self initLabel:lblCategoryName];
    [self initLabel:lblSmCode];
    [self initLabel:lblVendorName];
    
    [self addSubview:labelContainerView];
}

-(void)ShowRfid:(RFID *)rfid andProduct:(Product *)product {
    [self initLabelNContainerWhenShowProduct];
    self.contentSize = CGSizeMake(self.frame.size.width, labelContainerView.frame.size.height);
    
    if (product.categoryName == nil){
        ProductCategory *category = product.category;
        [category fetchIfNeededInBackgroundWithBlock:^(AVObject *object, NSError *error) {
            if (!error) {
                if (product.category.image != nil) {
                    //NSData *data = [product.category.image getData];
                    [product.category.image getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                        if (!error) {
                            UIImage *image = [UIImage imageWithData:data];
                            UIImageView * imageView = [[UIImageView alloc] initWithImage:image];
                            imageView.frame = CGRectMake(0, 0, self.frame.size.width, image.size.height * self.frame.size.width / image.size.width);
                            
                            imageView.contentMode = UIViewContentModeScaleAspectFit;
                            imageView.autoresizesSubviews = YES;
                            imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
                            
                            [self addSubview:imageView];
                            self.contentSize = CGSizeMake(self.contentSize.width, self.contentSize.height + imageView.frame.size.height + 120);
                            CGRect newRect4LabelContainer = CGRectMake(0, self->labelContainerView.frame.origin.y + imageView.frame.size.height, self->labelContainerView.frame.size.width, self->labelContainerView.frame.size.height);
                            self->labelContainerView.frame = newRect4LabelContainer;
                        }
                    }];
                }
                
                NSString *categoryName;
                if (product.categoryName == nil){
                    categoryName = category.fullName == nil ? category.categoryName : category.fullName;
                }else{
                    categoryName = product.categoryName;
                }
                self->lblCategoryName.text = [NSString stringWithFormat:@"产品类别：%@", categoryName];
                self->lblSize.text = [NSString stringWithFormat:@"产品尺寸：%ld*%ld*%ld(mm)", (long)category.length, (long)category.width, category.height];
                self->lblWeight.text = [NSString stringWithFormat:@"产品重量：%ld(kg)", (long)category.weight];
                
                NSMutableString *wmmtString = [[NSMutableString alloc] init];
                for ( int i = 0; i < category.wmmtAdapted.count; i++ ) {
                    NSString *wmmtID = category.wmmtAdapted[i];
                    AVQuery *query = [AVQuery queryWithClassName:@"WMMT"];
                    [query getObjectInBackgroundWithId:wmmtID block:^(AVObject *object, NSError *error) {
                        if (!error) {
                            AVObject *wmmt = object;
                            NSString *typeName = [wmmt objectForKey:@"typeName"];
                            if ([wmmtString length] > 0)
                                [wmmtString appendString:@" / "];
                            [wmmtString appendString: typeName];
                        }
                        self->lbkModelAdapted.text = [NSString stringWithFormat:@"适用机型：%@", wmmtString];
                    }];
                }
            }
        }];
        
        self->lblSn.text = [NSString stringWithFormat:@"产品序号：%@", product.productSn];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
        self->lblProductDate.text = [NSString stringWithFormat:@"生产日期：%@", [dateFormatter stringFromDate: product.productDate]];
        self->lblFactoryDate.text = [NSString stringWithFormat:@"出厂日期：%@", [dateFormatter stringFromDate: product.factoryDate]];
        
        Customer *customer = product.customer;
        [customer fetchIfNeededInBackgroundWithBlock:^(AVObject *object, NSError *error) {
            if (!error)
                self->lblOwner.text = [NSString stringWithFormat:@"当前产权人：%@" ,customer.customerName];
        }];
        
        Vendor *vendor = product.vendor;
        [vendor fetchIfNeededInBackgroundWithBlock:^(AVObject *object, NSError *error) {
            if (!error){
                self->lblVendorName.text = [NSString stringWithFormat:@"生产厂家：%@", vendor.vendorName];
                
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yy"];
                NSString *sy = [dateFormatter stringFromDate: product.productDate];
                self->lblSmCode.text = [NSString stringWithFormat:@"标签序号：%@%@%05ld", vendor.vendorCode, sy, (long)rfid.printingSN];
            }
        }];
    }
}

-(void)ShowRfid:(RFID *)rfid {
    UIImage *rfidOKImage = [UIImage imageNamed:@"rfidOK.png"];
    UIImageView *rfidOKImageView = [[UIImageView alloc] initWithImage:rfidOKImage];
    CGRect imageFrame = CGRectMake((self.frame.size.width - rfidOKImage.size.width) / 2, 20, rfidOKImage.size.width, rfidOKImage.size.height);
    rfidOKImageView.frame = imageFrame;
    [self addSubview:rfidOKImageView];
    
    Vendor *vendor = rfid.vendor;
    [vendor fetchIfNeededInBackgroundWithBlock:^(AVObject *object, NSError *error) {
        if (!error){
            [self initLabelNContainerWhenShowRfid];
            self->labelContainerView.frame = CGRectMake(0, imageFrame.origin.y + imageFrame.size.height, self.frame.size.width, self->labelContainerView.frame.size.height);
            
            self->lblCategoryName.text = @"思木认证标签，但厂家尚未录入明细";
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yy"];
            NSString *sy = [dateFormatter stringFromDate: rfid.initializeDate];
            self->lblSmCode.text = [NSString stringWithFormat:@"标签序号：%@%@%05ld", vendor.vendorCode, sy, (long)rfid.printingSN];
            
            self->lblVendorName.text = [NSString stringWithFormat:@"生产厂家：%@", vendor.vendorName];
        }
    }];
}

-(void)ShowWarning {
    UIImage *rfidOKImage = [UIImage imageNamed:@"Warning.png"];
    UIImageView *rfidOKImageView = [[UIImageView alloc] initWithImage:rfidOKImage];
    CGRect imageFrame = CGRectMake((self.frame.size.width - rfidOKImage.size.width) / 2, 20, rfidOKImage.size.width, rfidOKImage.size.height);
    rfidOKImageView.frame = imageFrame;
    [self addSubview:rfidOKImageView];
    
    [self initLabelNContainerWhenShowRfid];
    self->labelContainerView.frame = CGRectMake(0, imageFrame.origin.y + imageFrame.size.height, self.frame.size.width, self->labelContainerView.frame.size.height);
    
    self->lblCategoryName.text = @"注意，思木数据库中无此条码信息！";
}

-(void)ShowLabelContainerRect {
    TTAlert([NSString stringWithFormat:@"x:%f,y:%f,w:%f,h:%f,cw:%f,ch:%f", labelContainerView.frame.origin.x, labelContainerView.frame.origin.y, labelContainerView.frame.size.width, labelContainerView.frame.size.height, self.contentSize.width, self.contentSize.height]);
}

@end
