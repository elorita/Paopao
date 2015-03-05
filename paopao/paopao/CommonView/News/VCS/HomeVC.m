//
//  HomeVC.m
//  ShowProduct
//
//  Created by lin on 14-5-22.
//  Copyright (c) 2014年 @"". All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>

#import "HomeVC.h"
#import "HomeView.h"
#import "Macros.h"
#import "Article.h"
#import "ArticleClips.h"
#import "RSArticle.h"
#import "RSReadingBoard.h"
#import "AddFriendViewController.h"
#import "SimuCertifiedViewController.h"
#import "ImgShowViewController.h"
#import "ChatViewController.h"
#import "LoginViewController.h"

@interface HomeVC ()
{
    HomeView *mHomeView;
}

@end

@implementation HomeVC

//-----------------------------标准方法------------------
- (id) initWithNibName:(NSString *)aNibName bundle:(NSBundle *)aBuddle {
    self = [super initWithNibName:aNibName bundle:aBuddle];
    if (self != nil) {
        [self initCommonData];
        [self initTopNavBar];
    }
    return self;
}

//主要用来方向改变后重新改变布局
- (void) setLayout: (BOOL) aPortait {

    [self setViewFrame];
}

//重载导航条
-(void)initTopNavBar{
    self.title = @"首页";
    //self.navigationItem.leftBarButtonItem = Nil;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = backItem;

}

- (void)backAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewDidLoad{
    [self initView];
}

//初始化数据
-(void)initCommonData{
    
}

#if __has_feature(objc_arc)
#else
// dealloc函数
- (void) dealloc {
    [mHomeView release];
    [super dealloc];
}
#endif

// 初始View
- (void) initView {
    
    if (IS_IOS7) {
        self.edgesForExtendedLayout =UIRectEdgeNone ;
    }
    //contentView大小设置
    int vWidth = (int)([UIScreen mainScreen].bounds.size.width);
    int vHeight = (int)([UIScreen mainScreen].bounds.size.height);
    //contentView大小设置
    
    CGRect vViewRect = CGRectMake(0, 0, vWidth, vHeight -44 -40);
    UIView *vContentView = [[UIView alloc] initWithFrame:vViewRect];
    if (mHomeView == nil) {
        mHomeView = [[HomeView alloc] initWithFrame:vContentView.frame controller:self];
    }
    [vContentView addSubview:mHomeView];
    
    self.view = vContentView;
    
    [self setViewFrame];
}

//设置View方向
-(void) setViewFrame{
 
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

//------------------------------------------------

-(void)showArticle:(Article *)article{
    RSArticle *rsArticle = [RSArticle new];
    rsArticle.image = [UIImage imageWithData:[article.mainImageFile getData]];
    rsArticle.title = article.title;
    rsArticle.source = article.source;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat : @"yyyy年M月d日 H点m分"];
    rsArticle.date = [formatter stringFromDate:article.date];
    rsArticle.body = article.body;
    rsArticle.color = [UIColor orangeColor];
//    [[article.clips query] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        if (!error) {
//            NSMutableArray *clipArray = [[NSMutableArray alloc] init];
//            for (ArticleClips *object in objects) {
//                NSData *imageData = [object.clip getData];
//                UIImage *image = [UIImage imageWithData:imageData];
//                [clipArray addObject:image];
//            }
//            rsArticle.clips = clipArray;
//        }
//    }];
    rsArticle.clips = @[[UIImage imageNamed:@"Bauma360Banner.png"]];
    
    RSReadingBoard *board = [RSReadingBoard board];
    board.article = rsArticle;

    [self.navigationController pushViewController:board animated:YES];
}

#pragma ResellOuterDelegate

-(void)showResell:(Resell *)resell{
}

-(void)showCertificate:(Resell *)resell{
    SimuCertifiedViewController *controller = [[SimuCertifiedViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)callOwner:(AVUser *)owner{
    AVUser *curUser = [AVUser currentUser];
    NSDictionary *easeLoginInfo = [[[EaseMob sharedInstance] chatManager] loginInfo];
    if (curUser != nil && easeLoginInfo != nil) {
        if (curUser.username == owner.username) {
            TTAlert(@"您不能向自己发送消息!");
        } else {
            ChatViewController *chatVC = [[ChatViewController alloc] initWithChatter:owner.username];
            chatVC.title = [owner objectForKey:@"nickname"];
            [self.navigationController pushViewController:chatVC animated:YES];
        }
    } else {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}

#pragma
- (void)collectionView:(PPImageScrollingCellView *)collectionView didSelectImageItemAtIndexPath:(NSIndexPath*)indexPath onImages:(NSArray *)images{
    ImgShowViewController *imgShow = [[ImgShowViewController alloc] initWithSourceData:[NSMutableArray arrayWithArray:images] withIndex:indexPath.row];
    //[self.navigationController presentViewController:imgShow animated:YES completion:nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:imgShow];
    [self presentViewController:nav animated:YES completion:nil];
}



@end
