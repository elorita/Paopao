//
//  Defines.h
//  paopao
//
//  Created by TsaoLipeng on 15/1/30.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#ifndef paopao_Defines_h
#define paopao_Defines_h


#endif

#define SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

//事件notification定义
#define KNOTIFICATION_LOGINCHANGE @"loginStateChange"
#define KNOTIFICATION_APPRESIGNACTIVE @"appResignActive"
#define KNOTIFICATION_LOCATIONUPDATED @"locationUpdated"


//UI定义
#define STATU_BAR_HEIGHT 20
#define NAVIGATION_BAR_HEIGHT 44

#define NAVIGATION_BUTTON_WIDTH 44
#define NAVIGATION_BUTTON_HEIGHT 44
#define NAVIGATION_LBUTTON_MARGIN_LEFT 5
#define NAVIGATION_RBUTTON_MARGIN_RIGHT 5
#define NAVIGATION_BUTTON_RESPONSE_WIDTH 120

#define NAVIGATION_TITLE_WIDTH 120
#define NAVIGATION_TITLE_HEIGHT 44

#define kReservationCellWidth 56
#define kReservationCellHeight 32

#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define MAIN_COLOR [UIColor colorWithRed:(77.0)/255.0 green:(177.0)/255.0 blue:(53.0)/255.0 alpha:(1.0)]

//表单排序类型
#define DataOrderTypeCount 6
enum DataOrderType{
    dotDefault = 0,
    dotCanOrder,
    dotNear,
    dotCheap,
    dotPopularity,
    dotEvaluation
};
typedef enum DataOrderType DataOrderType;
const NSArray *___DataOrderType;
// 创建初始化函数。等于用宏创建一个getter函数
#define DataOrderTypeGet (___DataOrderType == nil ? ___DataOrderType = [[NSArray alloc] initWithObjects:@"默认排序",@"可预订",@"离我最近",@"价格最低",@"人气最高",@"评分最高", nil] : ___DataOrderType)
// 枚举 to 字串
#define DataOrderTypeString(type) ([DataOrderTypeGet objectAtIndex:type])
// 字串 to 枚举
#define DataOrderTypeEnum(string) ([DataOrderTypeGet indexOfObject:string])
