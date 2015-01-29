//
//  MenuView.m
//  JKSideSlipView
//
//  Created by Jakey on 15/1/10.
//  Copyright (c) 2015年 www.skyfox.org. All rights reserved.
//

#import "MenuView.h"
#import "MenuCell.h"
@implementation MenuView {
    NSMutableArray *cells;
}

+(instancetype)menuView
{
    UIView *result = nil;

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

- (void)viewDidLoad {
    _myTableView.separatorStyle = UITableViewCellSelectionStyleNone;
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


@end
