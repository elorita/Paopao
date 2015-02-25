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
#import "MeetModel.h"
#import "Defines.h"
#import "ScheduleHorizontalMenuLite.h"
#import "UIView+XD.h"
#import "Stadium.h"
#import "sportField.h"

#define MENUHEIHT 40

@interface ReservationViewController ()<UITableViewDataSource,UITableViewDelegate,MyCellDelegate,NormalNavigationDelegate,MenuHrizontalDelegate> {
    Stadium *curStadium;
}
@property (nonatomic, strong) NormalNavigationBar *navigationBar;
@property (nonatomic, strong) ScheduleHorizontalMenuLite *shMenuLite;
@property (nonatomic,strong) UIView *myHeadView;
@property (nonatomic,strong) UITableView *myTableView;
@property (nonatomic,strong) TimeView *timeView;
@property (nonatomic,strong) NSMutableArray *meets;
@property (nonatomic,strong) NSMutableArray *currentTime;
@end

@implementation ReservationViewController

- (instancetype)initWithStadium:(Stadium *)stadium {
    self = [super init];
    curStadium = stadium;
    return self;
}

-(void)initData
{
    self.meets=[NSMutableArray array];
    self.currentTime=[NSMutableArray array];
    for(int i=0;i<10;i++){
    
        MeetModel *meet=[[MeetModel alloc]init];
        meet.meetRoom=[NSString stringWithFormat:@"%03d",i];
        int currentTime=i*30+520;
        NSString *time=[NSString stringWithFormat:@"%d:%02d",currentTime/60,currentTime%60];
        meet.meetTime=time;
        [self.meets addObject:meet];
    }
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
    
    _shMenuLite = [[ScheduleHorizontalMenuLite alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT + STATU_BAR_HEIGHT, self.view.width, MENUHEIHT) withFirstDate:[NSDate date]];
    _shMenuLite.delegate = self;
    [_shMenuLite changeButtonStateAtIndex:originSelectedDateIndex];
    [self.view addSubview:_shMenuLite];

    [self createSubView_ColorIntro];//创建定场馆表格中各Cell颜色的介绍
    
    [self initData];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    AVQuery *query = [SportField query];
    [query whereKey:@"stadium" equalTo:curStadium];
    [query orderByAscending:@"order"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
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
            
            UIScrollView *myScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(42, NAVIGATION_BAR_HEIGHT + STATU_BAR_HEIGHT + MENUHEIHT + 60, self.view.frame.size.width-42, 320)];
            [myScrollView addSubview:tableView];
            myScrollView.bounces=NO;
            myScrollView.contentSize=CGSizeMake(tableView.width,0);
            [self.view addSubview:myScrollView];
        }
    }];

    self.timeView=[[TimeView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT + STATU_BAR_HEIGHT + MENUHEIHT + kReservationCellHeight + 60 - 8, 42, 300) withBeginTime:curStadium.shopHoursBegin withEndTime:curStadium.shopHoursEnd];
    [self.view addSubview:self.timeView];
}

- (void)createSubView_ColorIntro {
    UIView *colorIntroView = [[UIView alloc] initWithFrame:CGRectMake(10, NAVIGATION_BAR_HEIGHT + STATU_BAR_HEIGHT + MENUHEIHT, self.view.width - 20, 60)];
    UIView *reservatedCellIntroView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, colorIntroView.width / 3, colorIntroView.height)];
    UIView *curSelectedCellIntroView = [[UIView alloc] initWithFrame:CGRectMake(reservatedCellIntroView.width, 0, colorIntroView.width / 3, colorIntroView.height)];
    UIView *canReservateCellIntroView = [[UIView alloc] initWithFrame:CGRectMake(curSelectedCellIntroView.frame.origin.x + curSelectedCellIntroView.width, 0, colorIntroView.width / 3, colorIntroView.height)];
    
    UIView *reservatedCellColorView = [[UIView alloc] initWithFrame:CGRectMake((reservatedCellIntroView.width - 40) / 2, 10, 40, 20)];
    [reservatedCellColorView setBackgroundColor:DARK_BACKGROUND_COLOR];
    [reservatedCellIntroView addSubview:reservatedCellColorView];
    UILabel *reservatedLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, reservatedCellIntroView.width, 20)];
    [reservatedLabel setText:@"已售出"];
    [reservatedLabel setTextAlignment:NSTextAlignmentCenter];
    [reservatedLabel setTextColor:[UIColor grayColor]];
    [reservatedLabel setFont:[UIFont systemFontOfSize:15]];
    [reservatedCellIntroView addSubview:reservatedLabel];
    [colorIntroView addSubview:reservatedCellIntroView];
    
    UIView *curSelectedCellColorView = [[UIView alloc] initWithFrame:CGRectMake((curSelectedCellIntroView.width - 40) / 2, 10, 40, 20)];
    [curSelectedCellColorView setBackgroundColor:[UIColor orangeColor]];
    [curSelectedCellIntroView addSubview:curSelectedCellColorView];
    UILabel *curSelectedLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, curSelectedCellIntroView.width, 20)];
    [curSelectedLabel setText:@"当前选中"];
    [curSelectedLabel setTextAlignment:NSTextAlignmentCenter];
    [curSelectedLabel setTextColor:[UIColor grayColor]];
    [curSelectedLabel setFont:[UIFont systemFontOfSize:15]];
    [curSelectedCellIntroView addSubview:curSelectedLabel];
    [colorIntroView addSubview:curSelectedCellIntroView];
    
    UIView *canReservateCellColorView = [[UIView alloc] initWithFrame:CGRectMake((canReservateCellIntroView.width - 40) / 2, 10, 40, 20)];
    [canReservateCellColorView setBackgroundColor:MAIN_COLOR];
    [canReservateCellIntroView addSubview:canReservateCellColorView];
    UILabel *canReservateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, canReservateCellIntroView.width, 20)];
    [canReservateLabel setText:@"可订购"];
    [canReservateLabel setTextAlignment:NSTextAlignmentCenter];
    [canReservateLabel setTextColor:[UIColor grayColor]];
    [canReservateLabel setFont:[UIFont systemFontOfSize:15]];
    [canReservateCellIntroView addSubview:canReservateLabel];
    [colorIntroView addSubview:canReservateCellIntroView];
    
    UIView *spLine = [[UIView alloc] initWithFrame:CGRectMake(0, 56, colorIntroView.width, 1)];
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
    
        cell=[[MyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.delegate=self;
        cell.backgroundColor=[UIColor whiteColor];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    [self.currentTime removeAllObjects];
    for(MeetModel *model in self.meets){

        NSArray *timeArray=[ model.meetTime componentsSeparatedByString:@":"];
        int min=[timeArray[0] intValue]*60+[timeArray[1] intValue];
        int currentTime=indexPath.row*30+510;
        if(min>currentTime&&min<currentTime+30){
            [self.currentTime addObject:model];
        }
    }
    cell.index=indexPath.row;
    cell.currentTime=self.currentTime;
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
-(void)myHeadView:(HeadView *)headView point:(CGPoint)point
{
    CGPoint myPoint= [self.myTableView convertPoint:point fromView:headView];
    
    [self convertRoomFromPoint:myPoint];
}
-(void)convertRoomFromPoint:(CGPoint)ponit
{
    NSString *roomNum=[NSString stringWithFormat:@"%03d",(int)(ponit.x)/kReservationCellWidth];
    int currentTime=(ponit.y-kReservationCellHeight-kHeightMargin)*30.0/(kReservationCellHeight+kHeightMargin)+510;
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"clicked room" message:[NSString stringWithFormat:@"time :%@ room :%@",[NSString stringWithFormat:@"%d:%02d",currentTime/60,currentTime%60],roomNum] delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles:@"ok", nil];
    [alert show];
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

#pragma mark MenuHrizontalDelegate
-(void)didMenuHrizontalClickedButtonAtIndex:(NSInteger)aIndex {
    
}

@end
