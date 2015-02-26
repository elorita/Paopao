//
//  ViewController.m
//  表格
//
//  Created by zzy on 14-5-5.
//  Copyright (c) 2014年 zzy. All rights reserved.
//
#import "ReservationViewController.h"
#import "NormalNavigationBar.h"
#import "HeadView.h"
#import "TimeView.h"
#import "MyCell.h"
#import "SessionModel.h"
#import "Defines.h"
#import "ScheduleHorizontalMenuLite.h"
#import "UIView+XD.h"
#import "Stadium.h"
#import "sportField.h"
#import "ReservationSuborder.h"
#import "DateTimeHelper.h"
#import "SVProgressHUD.h"
#import "OrderConfirmViewController.h"

#define MENUHEIHT 40

@interface ReservationViewController ()<UITableViewDataSource,UITableViewDelegate,MyCellDelegate,NormalNavigationDelegate,MenuHrizontalDelegate> {
    Stadium *curStadium;
    NSInteger sportFieldCount;
    NSArray *sportsFields;
    NSMutableArray *selectedSessions;
    NSMutableArray *subOrderSessions;
    NSDate *beginDate;
    NSDate *selectedDate;
}
@property (nonatomic, strong) NormalNavigationBar *navigationBar;
@property (nonatomic, strong) ScheduleHorizontalMenuLite *shMenuLite;
@property (nonatomic,strong) UIView *myHeadView;
@property (nonatomic,strong) UITableView *myTableView;
@property (nonatomic,strong) TimeView *timeView;
@property (nonatomic,strong) UILabel *hintLabel;
@property (nonatomic,strong) UIButton *checkOutButton;
@end

@implementation ReservationViewController

- (instancetype)initWithStadium:(Stadium *)stadium {
    self = [super init];
    curStadium = stadium;
    return self;
}

- (void)setOriginSelectedDateIndex:(NSInteger)index {
    originSelectedDateIndex = index;
    if (_shMenuLite != nil) {
        [_shMenuLite changeButtonStateAtIndex:index];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationBar = [[NormalNavigationBar alloc] initWithTitle:@"场馆预订"];
    self.navigationBar.delegate = self;
    [self.view addSubview:self.navigationBar];
    
    beginDate = [DateTimeHelper getZeroHour:[NSDate date]];
    _shMenuLite = [[ScheduleHorizontalMenuLite alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT + STATU_BAR_HEIGHT, self.view.width, MENUHEIHT) withFirstDate:beginDate];
    _shMenuLite.delegate = self;
    [_shMenuLite changeButtonStateAtIndex:originSelectedDateIndex];
    [self.view addSubview:_shMenuLite];

    [self createSubView_ColorIntro];//创建定场馆表格中各Cell颜色的介绍
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    AVQuery *query = [SportField query];
    [query whereKey:@"stadium" equalTo:curStadium];
    [query orderByAscending:@"order"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            sportFieldCount = objects.count;
            sportsFields = [NSMutableArray arrayWithArray:objects];
            
            UIView *tableViewHeadView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, objects.count * kReservationCellWidth, kReservationCellHeight)];
            self.myHeadView=tableViewHeadView;
            
            for(int i=0; i<objects.count; i++){
                SportField *sp = [objects objectAtIndex:i];
                HeadView *headView=[[HeadView alloc]initWithFrame:CGRectMake(i*kReservationCellWidth, 0, kReservationCellWidth, kReservationCellHeight)];
                headView.name = sp.name;
                headView.backgroundColor=[UIColor whiteColor];
                [tableViewHeadView addSubview:headView];
            }
            
            UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.myHeadView.frame.size.width, 480) style:UITableViewStylePlain];
            tableView.delegate=self;
            tableView.dataSource=self;
            tableView.bounces=NO;
            tableView.showsVerticalScrollIndicator = NO;
            tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
            self.myTableView=tableView;
            tableView.backgroundColor=[UIColor whiteColor];
            
            UIScrollView *myScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(42, NAVIGATION_BAR_HEIGHT + STATU_BAR_HEIGHT + MENUHEIHT + 40, self.view.frame.size.width-42, 320)];
            [myScrollView addSubview:tableView];
            myScrollView.bounces=NO;
            myScrollView.contentSize=CGSizeMake(tableView.width,0);
            [self.view addSubview:myScrollView];
            
            [self queryReservationOrderWithDateOffset:originSelectedDateIndex];
        }
    }];

    self.timeView=[[TimeView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT + STATU_BAR_HEIGHT + MENUHEIHT + kReservationCellHeight + 40 - 8, 42, 300) withBeginTime:curStadium.shopHoursBegin withEndTime:curStadium.shopHoursEnd];
    [self.view addSubview:self.timeView];
    
    _hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, NAVIGATION_BAR_HEIGHT + STATU_BAR_HEIGHT + MENUHEIHT + 40 + 320, self.view.width - 10, 32)];
    [_hintLabel setFont:[UIFont systemFontOfSize:14]];
    [_hintLabel setTextColor:[UIColor grayColor]];
    [_hintLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:_hintLabel];
    
    _checkOutButton = [[UIButton alloc] initWithFrame:CGRectMake(10, self.view.height - 50, self.view.width - 20, 40)];
    _checkOutButton.layer.cornerRadius = 4.0f;
    _checkOutButton.layer.masksToBounds = YES;
    _checkOutButton.backgroundColor = [UIColor orangeColor];
    [_checkOutButton setTitle:@"提交订单" forState:UIControlStateNormal];
    [_checkOutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_checkOutButton addTarget:self action:@selector(doCheckOut) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_checkOutButton];
}

- (void)createSubView_ColorIntro {
    UIView *colorIntroView = [[UIView alloc] initWithFrame:CGRectMake(10, NAVIGATION_BAR_HEIGHT + STATU_BAR_HEIGHT + MENUHEIHT, self.view.width - 20, 40)];
    UIView *reservatedCellIntroView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, colorIntroView.width / 3, colorIntroView.height)];
    UIView *curSelectedCellIntroView = [[UIView alloc] initWithFrame:CGRectMake(reservatedCellIntroView.width, 0, colorIntroView.width / 3, colorIntroView.height)];
    UIView *canReservateCellIntroView = [[UIView alloc] initWithFrame:CGRectMake(curSelectedCellIntroView.frame.origin.x + curSelectedCellIntroView.width, 0, colorIntroView.width / 3, colorIntroView.height)];
    
    UIView *reservatedCellColorView = [[UIView alloc] initWithFrame:CGRectMake((reservatedCellIntroView.width - 40) / 2, 5, 40, 10)];
    [reservatedCellColorView setBackgroundColor:DARK_BACKGROUND_COLOR];
    [reservatedCellIntroView addSubview:reservatedCellColorView];
    UILabel *reservatedLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, reservatedCellIntroView.width, 20)];
    [reservatedLabel setText:@"已售出"];
    [reservatedLabel setTextAlignment:NSTextAlignmentCenter];
    [reservatedLabel setTextColor:[UIColor grayColor]];
    [reservatedLabel setFont:[UIFont systemFontOfSize:15]];
    [reservatedCellIntroView addSubview:reservatedLabel];
    [colorIntroView addSubview:reservatedCellIntroView];
    
    UIView *curSelectedCellColorView = [[UIView alloc] initWithFrame:CGRectMake((curSelectedCellIntroView.width - 40) / 2, 5, 40, 10)];
    [curSelectedCellColorView setBackgroundColor:[UIColor orangeColor]];
    [curSelectedCellIntroView addSubview:curSelectedCellColorView];
    UILabel *curSelectedLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, curSelectedCellIntroView.width, 20)];
    [curSelectedLabel setText:@"当前选中"];
    [curSelectedLabel setTextAlignment:NSTextAlignmentCenter];
    [curSelectedLabel setTextColor:[UIColor grayColor]];
    [curSelectedLabel setFont:[UIFont systemFontOfSize:15]];
    [curSelectedCellIntroView addSubview:curSelectedLabel];
    [colorIntroView addSubview:curSelectedCellIntroView];
    
    UIView *canReservateCellColorView = [[UIView alloc] initWithFrame:CGRectMake((canReservateCellIntroView.width - 40) / 2, 5, 40, 10)];
    [canReservateCellColorView setBackgroundColor:MAIN_COLOR];
    [canReservateCellIntroView addSubview:canReservateCellColorView];
    UILabel *canReservateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, canReservateCellIntroView.width, 20)];
    [canReservateLabel setText:@"可订购"];
    [canReservateLabel setTextAlignment:NSTextAlignmentCenter];
    [canReservateLabel setTextColor:[UIColor grayColor]];
    [canReservateLabel setFont:[UIFont systemFontOfSize:15]];
    [canReservateCellIntroView addSubview:canReservateLabel];
    [colorIntroView addSubview:canReservateCellIntroView];
    
    UIView *spLine = [[UIView alloc] initWithFrame:CGRectMake(0, 37, colorIntroView.width, 1)];
    [spLine setBackgroundColor:NORMAL_BACKGROUND_COLOR];
    [colorIntroView addSubview:spLine];
    
    [self.view addSubview: colorIntroView];
}

#pragma mark UITableViewDelegate N' UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return curStadium.shopHoursEnd - curStadium.shopHoursBegin + 5;//这里返回n+5后，才能有n条滚动的空间，原因不明
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"cell";
    
    MyCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil){
    
        cell=[[MyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier withSubCellCount:sportFieldCount];
        cell.delegate=self;
        cell.backgroundColor=[UIColor whiteColor];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.currentTime = curStadium.shopHoursBegin + indexPath.row;
    }
    [cell reloadDataWithReservatedSession:subOrderSessions];

    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    return self.myHeadView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kReservationCellHeight;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kReservationCellHeight;
}
- (void)selectingIsChanged:(BOOL)selected withTime:(NSInteger)time withSportField:(NSInteger)sportFieldIndex {
    if (selectedSessions == nil) {
        selectedSessions = [[NSMutableArray alloc] init];
    }
    
    if (!selected) {
        for (SessionModel *sm in selectedSessions) {
            if (sm.sessionTime == time && sm.sportFieldIndex == sportFieldIndex) {
                [selectedSessions removeObject:sm];
                break;
            }
        }
    } else {
        SessionModel *session = [[SessionModel alloc] init];
        session.sessionTime = time;
        session.sportFieldIndex = sportFieldIndex;
        session.sportField = [sportsFields objectAtIndex:sportFieldIndex];
        session.price = [[session.sportField.normalPrices objectAtIndex:session.sessionTime] integerValue];
        [selectedSessions addObject:session];
    }
    
    NSInteger amount = 0;
    for (SessionModel *session in selectedSessions) {
        SportField *sp = [sportsFields objectAtIndex:session.sportFieldIndex];
        id price = [sp.normalPrices objectAtIndex:(session.sessionTime)];
        amount += [price integerValue];
    }
    NSString *buttonTitle = [NSString stringWithFormat:@"%ld个场次\t合计%ld元\t提交订单", selectedSessions.count, amount];
    [_checkOutButton setTitle:buttonTitle forState:UIControlStateNormal];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY= self.myTableView.contentOffset.y;
    CGPoint timeOffsetY=self.timeView.timeTableView.contentOffset;
    timeOffsetY.y=offsetY;
    self.timeView.timeTableView.contentOffset=timeOffsetY;
    if(offsetY==0){
        self.timeView.timeTableView.contentOffset=CGPointZero;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)doReturn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)queryReservationOrderWithDateOffset:(NSInteger)offset {
    [SVProgressHUD showWithStatus:@"预订情况查询中..."];
    AVQuery *query = [ReservationSuborder query];
    [query whereKey:@"stadium" equalTo:curStadium];
    selectedDate = [beginDate dateByAddingTimeInterval:3600 * 24 * offset];
    //[query whereKey:@"date" equalTo:curDate];
    [query whereKey:@"date" greaterThanOrEqualTo:selectedDate];
    [query whereKey:@"date" lessThanOrEqualTo:[selectedDate dateByAddingTimeInterval:1]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            subOrderSessions = [[NSMutableArray alloc] init];
            for (ReservationSuborder *suborder in objects) {
                SessionModel *model = [[SessionModel alloc] init];
                model.sessionTime = suborder.time;
                model.sportField = suborder.sportField;
                model.sportFieldIndex = [self indexOfSportsField:suborder.sportField];
                [subOrderSessions addObject:model];
            }
            if (_myTableView != nil)
                [_myTableView reloadData];
            [SVProgressHUD dismiss];
        }
    }];
}

#pragma mark MenuHrizontalDelegate
-(void)didMenuHrizontalClickedButtonAtIndex:(NSInteger)aIndex {
    [_checkOutButton setTitle:@"提交订单" forState:UIControlStateNormal];
    [self queryReservationOrderWithDateOffset:aIndex];
}

- (NSInteger)indexOfSportsField:(SportField *)sportField {
    for (int i = 0; i < sportsFields.count; i++) {
        SportField *sp = [sportsFields objectAtIndex:i];
        if ([sp.objectId isEqualToString:sportField.objectId]) {
            return i;
        }
    }
    return -1;
}

- (void)doCheckOut {
    if (selectedSessions.count > 0) {
        //todo：还应该对session按场地/时间排序后再传入
        OrderConfirmViewController *ocVC = [[OrderConfirmViewController alloc] initWithStadium:curStadium withOrderDate:selectedDate withOrderedSessions:selectedSessions];
        [self.navigationController pushViewController:ocVC animated:YES];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"抱歉" message:@"您尚未选择任何场次" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

@end
