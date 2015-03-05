//
//  PPImageScrollingCellView.m
//  PPImageScrollingTableViewDemo
//
//  Created by popochess on 13/8/9.
//  Copyright (c) 2013年 popochess. All rights reserved.
//

#import "PPImageScrollingCellView.h"
#import "PPCollectionViewCell.h"
#import "ImageHelper.h"

@interface  PPImageScrollingCellView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) PPCollectionViewCell *myCollectionViewCell;
@property (strong, nonatomic) UICollectionView *myCollectionView;
@property (strong, nonatomic) NSMutableArray *collectionImageData;
@property (strong, nonatomic) NSMutableArray *originImageData;
@property (nonatomic) CGFloat imagetitleWidth;
@property (nonatomic) CGFloat imagetitleHeight;
@property (strong, nonatomic) UIColor *imageTilteBackgroundColor;
@property (strong, nonatomic) UIColor *imageTilteTextColor;


@end

@implementation PPImageScrollingCellView

- (id)initWithFrame:(CGRect)frame
{
     self = [super initWithFrame:frame];
    
    if (self) {
        // Initialization code

        /* Set flowLayout for CollectionView*/
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.itemSize = CGSizeMake(72, 72);
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 15);//滚动到最右侧留15dp边距
        flowLayout.minimumLineSpacing = 5;

        /* Init and Set CollectionView */
        self.myCollectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        self.myCollectionView.delegate = self;
        self.myCollectionView.dataSource = self;
        self.myCollectionView.showsHorizontalScrollIndicator = NO;

        [self.myCollectionView registerClass:[PPCollectionViewCell class] forCellWithReuseIdentifier:@"PPCollectionCell"];
        [self addSubview:_myCollectionView];
        
        _collectionImageData = [[NSMutableArray alloc] init];
        _originImageData = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) setImageData:(NSArray*)collectionImageData{

    _originImageData = [NSMutableArray arrayWithArray:collectionImageData];
    for (UIImage* img in _originImageData) {
        [_collectionImageData addObject:[ImageHelper generateSquareThumbnail:img withLength:144.0]];
    }
         
    [_myCollectionView reloadData];
}

- (void) addThumbnail:(UIImage *) thumb withAVFile:(AVFile *)file{
    [_collectionImageData addObject:[ImageHelper generateSquareThumbnail:thumb withLength:144.0]];
    [_originImageData addObject:file];
    [_myCollectionView reloadData];
}

- (void) clearImageList{
    [_collectionImageData removeAllObjects];
    [_originImageData removeAllObjects];
}

- (void) setBackgroundColor:(UIColor*)color{

    self.myCollectionView.backgroundColor = color;
    [_myCollectionView reloadData];
}

- (void) setImageTitleLabelWitdh:(CGFloat)width withHeight:(CGFloat)height{
    _imagetitleWidth = width;
    _imagetitleHeight = height;
}
- (void) setImageTitleTextColor:(UIColor*)textColor withBackgroundColor:(UIColor*)bgColor{
    
    _imageTilteTextColor = textColor;
    _imageTilteBackgroundColor = bgColor;
}

#pragma mark - UICollectionViewDataSource methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.collectionImageData count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{    
    PPCollectionViewCell *cell = (PPCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"PPCollectionCell" forIndexPath:indexPath];
    UIImage *image = [self.collectionImageData objectAtIndex:[indexPath row]];
    
    [cell setImage:image];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(collectionView:didSelectImageItemAtIndexPath:onImages:)])
        [self.delegate collectionView:self didSelectImageItemAtIndexPath:(NSIndexPath*)indexPath onImages:_originImageData];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
