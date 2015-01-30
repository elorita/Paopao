//
//  MenuView.m
//  JKSideSlipView
//
//  Created by Jakey on 15/1/10.
//  Copyright (c) 2015年 www.skyfox.org. All rights reserved.
//

#import "MenuView.h"
#import "MenuCell.h"
#import <AVOSCloud/AVOSCloud.h>
#import "ShareInstances.h"
#import "Defines.h"

static UIImage *headPortraitCache;
static NSInteger welcomeLabelHeight = 60;

@interface MenuView ()

@property (nonatomic, strong) UIImageView *portraitImageView;

@end

@implementation MenuView {
    NSMutableArray *cells;
    UILabel *welcomeLabel;
}

+(instancetype)menuView
{
    MenuView *result = nil;

    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    for (id object in nibView)
    {
        if ([object isKindOfClass:[self class]])
        {
            result = object;
            break;
        }
    }
    return result;
}

- (void)awakeFromNib {
    _myTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self initUserStatu];
}

-(void)didSelectRowAtIndexPath:(void (^)(id cell, NSIndexPath *indexPath))didSelectRowAtIndexPath{
    _didSelectRowAtIndexPath = [didSelectRowAtIndexPath copy];
}

-(void)setItems:(NSArray *)items{
    _items = items;
}


#pragma -mark tableView Delegates

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_items count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_didSelectRowAtIndexPath) {
        MenuCell *cell = (MenuCell *)[tableView cellForRowAtIndexPath:indexPath];
        _didSelectRowAtIndexPath(cell,indexPath);
    }
    //[self.myTableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.myTableView registerNib:[UINib nibWithNibName:@"MenuCell" bundle:nil] forCellReuseIdentifier:@"MenuCell"];
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

- (void)refreshSignStatu {
    AVUser *curUser = [AVUser currentUser];
    
    if (curUser != nil)
        [ShareInstances setCurrentUserHeadPortraitWithUserName:curUser.username];
    
    [self addSubview:self.portraitImageView];
    [self loadPortrait];
    
    if (welcomeLabel == nil) {
        welcomeLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 20, 160, welcomeLabelHeight)];
        [self addSubview:welcomeLabel];
        
        UIButton *loginButton = [[UIButton alloc] initWithFrame:welcomeLabel.frame];
        [loginButton addTarget:self action:@selector(doLogin) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:loginButton];
    }
    welcomeLabel.textColor = [UIColor whiteColor];
    welcomeLabel.font = [UIFont systemFontOfSize:15];
    welcomeLabel.textAlignment = NSTextAlignmentLeft;
    welcomeLabel.text = curUser == nil ? @"Hi 你好 点击登录" : [NSString stringWithFormat:@"Hi %@", [curUser objectForKey:@"nickname"]];
}

- (void)initUserStatu {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginStateChange:)
                                                 name:KNOTIFICATION_LOGINCHANGE
                                               object:nil];
    
    [self refreshSignStatu];
}

-(void)loginStateChange:(NSNotification *)notification {
    [self refreshSignStatu];
}

- (void)loadPortrait {
    AVUser *curUser = [AVUser currentUser];
    if (curUser != nil) {
        if (headPortraitCache == nil){
            AVFile *imageFile = [curUser objectForKey:@"headPortrait"];
            if (imageFile != nil) {
                [imageFile getThumbnail:YES width:150 height:150 withBlock:^(UIImage * image, NSError *error) {
                    if (!error) {
                        headPortraitCache = image;
                    } else {
                        headPortraitCache = [UIImage imageNamed:@"mzwyyc.jpg"];
                    }
                    self.portraitImageView.image = headPortraitCache;
                }];
            } else {
                headPortraitCache = [UIImage imageNamed:@"mzwyyc.jpg"];
                _portraitImageView.image = headPortraitCache;
            }
        }
    } else {
        _portraitImageView.image = [UIImage imageNamed:@"mzwyyc.jpg"];
    }
}

#pragma mark portraitImageView getter
- (UIImageView *)portraitImageView {
    if (!_portraitImageView) {
        CGFloat w = 40.0f;
        CGFloat h = w;
        CGFloat x = 22.0f;
        CGFloat y = 30.0f;
        _portraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
        [_portraitImageView.layer setCornerRadius:(_portraitImageView.frame.size.height/2)];
        [_portraitImageView.layer setMasksToBounds:YES];
        [_portraitImageView setContentMode:UIViewContentModeScaleAspectFill];
        [_portraitImageView setClipsToBounds:YES];
        _portraitImageView.layer.shadowColor = [UIColor blackColor].CGColor;
        _portraitImageView.layer.shadowOffset = CGSizeMake(4, 4);
        _portraitImageView.layer.shadowOpacity = 0.5;
        _portraitImageView.layer.shadowRadius = 2.0;
        _portraitImageView.layer.borderColor = [MAIN_COLOR CGColor];
        _portraitImageView.layer.borderWidth = 0.5f;
        _portraitImageView.userInteractionEnabled = YES;
        _portraitImageView.backgroundColor = [UIColor whiteColor];
        UITapGestureRecognizer *portraitTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doLogin)];
        [_portraitImageView addGestureRecognizer:portraitTap];
    }
    return _portraitImageView;
}

- (void)doLogin {
    if ([_delegate respondsToSelector:@selector(onLogin)])
        [_delegate onLogin];
}

@end
