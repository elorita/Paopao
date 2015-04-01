//
//  UICustomSettingViewController.m
//  paopao
//
//  Created by TsaoLipeng on 15/3/30.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import "CustomSettingViewController.h"
#import "NormalNavigationBar.h"
#import "Defines.h"
#import "UIView+XD.h"
#import "SettingTableViewCell.h"
#import <AVOSCloud/AVOSCloud.h>

@interface CustomSettingViewController()<NormalNavigationDelegate, UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NormalNavigationBar *navigationBar;

@end

@implementation CustomSettingViewController{
    NSArray *sexArray;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = NORMAL_BACKGROUND_COLOR;
    
    _navigationBar = [[NormalNavigationBar alloc] initWithTitle:@"修改资料"];
    self.navigationBar.delegate = self;
    [self.view addSubview:self.navigationBar];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _navigationBar.bottom, self.view.width, self.view.height - _navigationBar.bottom)];
    [_tableView setBackgroundColor:NORMAL_BACKGROUND_COLOR];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [self initPickerViewsArray];
}

#pragma mark NormalNavigationDelegate
- (void)doReturn {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UITableViewDelegate and UiTableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 80;
    }else{
        return 54;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *vCellIdentify = @"CustomSettingTableViewCell";
    SettingTableViewCell *vCell = [tableView dequeueReusableCellWithIdentifier:vCellIdentify];
    if (vCell == nil) {
        vCell = [[SettingTableViewCell alloc] init];
        vCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [vCell.textLabel setTextColor:NORMAL_TEXT_COLOR];
        vCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    AVUser *curUser = [AVUser currentUser];
    switch (indexPath.row) {
        case 0:{
            [vCell setKey:@"头像" withImage:nil];
            AVFile *headPortrait = [curUser objectForKey:@"headPortrait"];
            [headPortrait getThumbnail:YES width:120 height:120 withBlock:^(UIImage *image, NSError *error) {
                if (!error){
                    [vCell setKey:@"头像" withImage:image];
                }
            }];
            break;
        }
        case 1:
            [vCell setKey:@"昵称" withValue:[curUser objectForKey:@"nickname"]];
            break;
        case 2:{
            NSNumber *sexNum = [curUser objectForKey:@"sex"];
            NSString *sexString = [sexNum integerValue] == 1 ? @"男" : @"女";
            [vCell setKey:@"性别" withValue:sexString];
            break;
        }
        case 3:{
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"YYYY-MM-dd"];
            [vCell setKey:@"生日" withValue:[dateFormatter stringFromDate:[curUser objectForKey:@"birthday"]]];
            break;
        }
        case 4:
            [vCell setKey:@"签名" withValue:[curUser objectForKey:@"signature"]];
            break;
        case 5:
            [vCell setKey:@"行业" withValue:@"无"];
            break;
        case 6:
            [vCell setKey:@"爱好运动" withValue:@"无"];
            break;
        default:
            break;
    }
    return vCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 2:{
            UIPickerView *pickerView = [[UIPickerView alloc] init];
            pickerView.tag = 2;
            pickerView.delegate = self;
            pickerView.dataSource = self;
            pickerView.hidden = NO;
            [self.view addSubview:pickerView];
            break;
        }
        default:
            break;
    }
}

- (void)initPickerViewsArray
{
    sexArray = [NSArray arrayWithObjects:@"男",
             @"女", nil];
}

// UIPickerViewDataSource中定义的方法，该方法的返回值决定该控件包含多少列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    switch (pickerView.tag) {
        case 2:
            return 1;
            break;
        default:
            return 0;
            break;
    }
}
// UIPickerViewDataSource中定义的方法，该方法的返回值决定该控件指定列包含多少个列表项
- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    // 由于该控件只包含一列，因此无须理会列序号参数component
    // 该方法返回books.count，表明books包含多少个元素，该控件就包含多少行
    switch (pickerView.tag) {
        case 2:
            return sexArray.count;
            break;
        default:
            return 0;
            break;
    }
}
// UIPickerViewDelegate中定义的方法，该方法返回的NSString将作为UIPickerView
// 中指定列和列表项的标题文本
- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    // 由于该控件只包含一列，因此无须理会列序号参数component
    // 该方法根据row参数返回books中的元素，row参数代表列表项的编号，
    // 因此该方法表示第几个列表项，就使用books中的第几个元素
    switch (pickerView.tag) {
        case 2:
            return [sexArray objectAtIndex:row];
            break;
        default:
            return @"";
            break;
    }
}
// 当用户选中UIPickerViewDataSource中指定列和列表项时激发该方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:
(NSInteger)row inComponent:(NSInteger)component
{
    // 使用一个UIAlertView来显示用户选中的列表项
    UIAlertView* alert = [[UIAlertView alloc]
                          initWithTitle:@"提示"
                          message:[NSString stringWithFormat:@"你选中的性别是：%@"
                                   , [sexArray objectAtIndex:row]]
                          delegate:nil
                          cancelButtonTitle:@"确定"
                          otherButtonTitles:nil];
    [alert show];
}

@end
