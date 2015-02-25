//
//  TimeView.m
//  表格
//
//  Created by zzy on 14-5-6.
//  Copyright (c) 2014年 zzy. All rights reserved.
//
#import "TimeView.h"
#import "MyLabel.h"
#import "TimeCell.h"
#import "Defines.h"
@interface TimeView()<UITableViewDataSource,UITableViewDelegate> {
    NSInteger timeCount;
}
@property (nonatomic,strong) NSMutableArray *times;
@end

@implementation TimeView

- (id)initWithFrame:(CGRect)frame withBeginTime:(NSInteger)beginTime withEndTime:(NSInteger)endTime
{
    self = [super initWithFrame:frame];
    if (self) {
        self.times=[NSMutableArray array];
        timeCount = endTime - beginTime + 1;
        for (int i=0; i<=timeCount; i++) {
            NSInteger currentTime = 60 * beginTime + 60 * i;
            NSString *time=[NSString stringWithFormat:@"%02ld:%02ld-",currentTime/60,currentTime%60];
            [self.times addObject:time];
        }
        
         self.timeTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) style:UITableViewStylePlain];
         self.timeTableView.delegate=self;
         self.timeTableView.dataSource=self;
         self.timeTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
         self.timeTableView.userInteractionEnabled=NO;
        [self addSubview: self.timeTableView];
        
    }
    return self;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return timeCount;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kReservationCellHeight;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"cell";
    TimeCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil){
        
        cell=[[TimeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.timeLabel.text=self.times[indexPath.row];
    return cell;
}
@end
