//
//  SidebarViewController.m
//  LLBlurSidebar
//
//  Created by Lugede on 14/11/20.
//  Copyright (c) 2014年 lugede.cn. All rights reserved.
//

#import "SidebarViewController.h"
#import "MenuCell.h"
#import "UserSummaryView.h"

@interface SidebarViewController ()<UITableViewDelegate, UITableViewDataSource, SignInDelegate>

@property (nonatomic, retain) UITableView* menuTableView;

@end

@implementation SidebarViewController{
    NSMutableArray *cells;
    UILabel *welcomeLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // 列表
    self.menuTableView = [[UITableView alloc] initWithFrame:self.contentView.bounds];
    [self.menuTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.menuTableView.backgroundColor = [UIColor whiteColor];
    self.menuTableView.delegate = self;
    self.menuTableView.dataSource = self;
    [self.contentView addSubview:self.menuTableView];
    
    [self.view setAlpha:0.98];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setItems:(NSArray *)items{
    _items = items;
}

#pragma mark - TableView
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 80;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UserSummaryView *userSummaryView = [[UserSummaryView alloc] init];
    userSummaryView.delegate = self;
    return userSummaryView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _items.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.menuTableView registerNib:[UINib nibWithNibName:@"MenuCell" bundle:nil] forCellReuseIdentifier:@"MenuCell"];
    MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuCell"];
    cell.tag = indexPath.row;
    if (cells == nil)
        cells = [NSMutableArray array];
    [cells addObject:cell];
    cell.label.text = [self.items[indexPath.row] objectForKey:@"title"];
    cell.normalImage = [UIImage imageNamed:[self.items[indexPath.row] objectForKey:@"imagenormal"]];
    cell.highlightImage = [UIImage imageNamed:[self.items[indexPath.row] objectForKey:@"imagehighlight"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self showHideSidebar];
    if ([_delegate respondsToSelector:@selector(menuItemSelectedOnIndex:)])
        [_delegate menuItemSelectedOnIndex:indexPath.row];
}

#pragma mark SignInDelegate 将header中登陆相关的操作转发给主控制器操作
- (void)onLogin {
    if ([_signInDelegate respondsToSelector:@selector(onLogin)])
        [_signInDelegate onLogin];
    [self showHideSidebar];
}

- (void)onUserHome {
    if ([_signInDelegate respondsToSelector:@selector(onUserHome)])
        [_signInDelegate onUserHome];
    [self showHideSidebar];
}

@end
