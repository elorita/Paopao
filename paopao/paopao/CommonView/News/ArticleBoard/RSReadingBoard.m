//
//  RSReadingBoard.m
//  RSReadingBoardSample
//
//  Created by R0CKSTAR on 3/25/14.
//  Copyright (c) 2014 P.D.Q. All rights reserved.
//

#import "RSReadingBoard.h"

#import "RSArticle.h"

// https://github.com/yeahdongcn/RSImageFitness
#import "UIImage+Fitness.h"

#ifdef UI_USER_INTERFACE_IDIOM
#define IS_IPAD() (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#else
#define IS_IPAD() (false)
#endif

#define PROPERTY_NAME(property) [[(@""#property) componentsSeparatedByString:@"."] lastObject]

@interface RSClipView : UIImageView

@end

@implementation RSClipView

@end

@interface RSReadingBoard () <UIScrollViewDelegate>

@property (nonatomic, weak) IBOutlet UIScrollView *vContent;

@property (nonatomic, weak) IBOutlet UIImageView  *ivImage;
@property (nonatomic) CGRect ivImageFrame;

@property (nonatomic, weak) IBOutlet UIView       *vColor;

@property (nonatomic, weak) IBOutlet UILabel      *lTitle;

@property (nonatomic, weak) IBOutlet UILabel      *lSource;

@property (nonatomic, weak) IBOutlet UILabel      *lDate;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *lclTitleTop;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *lclTitleTrailing;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *lcvColorLeading;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *lcivImageTrailing;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *lcivImageTop;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *lcivImageBottom;

@property (nonatomic, strong) NSLayoutManager *layoutManager;

@property (nonatomic, strong) NSTextStorage   *textStorage;

@property (nonatomic, strong) NSMutableDictionary *oldConstants;

@property (nonatomic, strong) NSMutableArray *clipViews;

@property (nonatomic, strong) NSArray *clipViewsFrames;

@property (nonatomic) NSUInteger lastPage;

@end

@implementation RSReadingBoard

static NSString *const kReadingBoardNib_iPhone = @"RSReadingBoard_iPhone";
static NSString *const kReadingBoardNib_iPad   = @"RSReadingBoard_iPad";

#pragma mark - Private methods

- (CGFloat)widthForInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    CGSize size = [UIScreen mainScreen].bounds.size;
    if (interfaceOrientation == UIInterfaceOrientationPortrait) {
        return size.width > size.height ? size.height : size.width;
    } else {
        return size.width > size.height ? size.width : size.height;
    }
}

- (void)layoutImageByInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation == UIInterfaceOrientationPortrait) {
        self.lcivImageWidth.constant = [self widthForInterfaceOrientation:UIInterfaceOrientationPortrait];
    } else {
        self.lcivImageWidth.constant = roundf([self widthForInterfaceOrientation:UIInterfaceOrientationLandscapeLeft] / 2.0f);
    }
    self.lcivImageHeight.constant = roundf(self.lcivImageWidth.constant / 2.0f);
    
    [self.oldConstants setObject:@(self.lcivImageTop.constant) forKey:PROPERTY_NAME(self.lcivImageTop)];
    [self.oldConstants setObject:@(self.lcivImageHeight.constant) forKey:PROPERTY_NAME(self.lcivImageHeight)];
}

- (void)tap:(UITapGestureRecognizer *)tap
{
    RSClipView *tappedClipView = (RSClipView *)tap.view;
    
    CGPoint center = CGPointZero;
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait) {
        NSUInteger currentPage = roundf(self.vContent.contentOffset.y / (self.vContent.frame.size.height));
        center = CGPointMake(self.vContent.center.x, self.vContent.center.y + self.vContent.bounds.size.height * currentPage);
    } else {
        NSUInteger currentPage = roundf(self.vContent.contentOffset.x / (self.vContent.frame.size.width));
        center = CGPointMake(self.vContent.center.x  + self.vContent.bounds.size.width * currentPage, self.vContent.center.y);
    }
    [UIView animateWithDuration:0.3f animations:^{
        if (CGPointEqualToPoint(center, tappedClipView.center)) {
            tappedClipView.frame = [self.clipViewsFrames[tappedClipView.tag] CGRectValue];
        } else {
            tappedClipView.center = center;
            tappedClipView.transform = CGAffineTransformScale(tappedClipView.transform,
                                                              self.scaleX, self.scaleY);
            [self.vContent bringSubviewToFront:tappedClipView];
        }
    }];
    
    [UIView animateWithDuration:0.3f animations:^{
        [self.clipViews enumerateObjectsUsingBlock:^(RSClipView *clipView, NSUInteger idx, BOOL *stop) {
            if (clipView != tappedClipView && CGPointEqualToPoint(center, clipView.center)) {
                clipView.frame = [self.clipViewsFrames[clipView.tag] CGRectValue];
                if (!IS_IPAD()) {
                    [self.vContent sendSubviewToBack:clipView];
                }
            }
        }];
    }];
}

#pragma mark - Quick creation

+ (instancetype)board
{
    NSString *name = kReadingBoardNib_iPhone;
    if (IS_IPAD()) {
        name = kReadingBoardNib_iPad;
    }
    return [self boardWithWithNibName:name bundle:[NSBundle mainBundle]];
}

+ (instancetype)boardWithWithNibName:(NSString *)name bundle:(NSBundle *)bundle
{
    return [[bundle loadNibNamed:name owner:nil options:nil] firstObject];
}

#pragma mark - NSObject

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.scaleX = 3.0f;
        self.scaleY = 3.0f;
        
        self.contentInsets = UIEdgeInsetsMake(60, 20, 20, 20);
        
        self.enableImageDragZoomIn = YES;
        
        self.bodyBackgroundColor = [UIColor clearColor];
        self.bodyTextColor = [UIColor darkGrayColor];
        self.bodyFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    }
    return self;
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /**
     *  @NOTE: Turn off automatically adjusts scroll view insets in xib or here
     */
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    /**
     *  @NOTE: Make sure the image view's content mode is aspect fill, set it in xib or here
     */
    self.ivImage.contentMode = UIViewContentModeScaleAspectFill;
    
    /**
     *  @NOTE: Enable content view's paging in xib or here
     */
    self.vContent.pagingEnabled = YES;
    
    /**
     *  @NOTE: Set content view's delegate in xib or here
     */
    self.vContent.delegate = self;
    
    [self layoutImageByInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
    
    [self.oldConstants setObject:@(self.lcvColorLeading.constant) forKey:PROPERTY_NAME(self.lcvColorLeading)];
    [self.oldConstants setObject:@(self.lclTitleTrailing.constant) forKey:PROPERTY_NAME(self.lclTitleTrailing)];
    
    [self.oldConstants setObject:@(self.lclTitleTop.constant) forKey:PROPERTY_NAME(self.lclTitleTop)];
    [self.oldConstants setObject:@(self.lcVerticalSpaceBetweenlTitlelSource.constant) forKey:PROPERTY_NAME(self.lcVerticalSpaceBetweenlTitlelSource)];
    if (self.lTitle.font) {
        [self.oldConstants setObject:self.lTitle.font forKey:[NSString stringWithFormat:@"%@%@", PROPERTY_NAME(self.lTitle), @"Font"]];
    }
    if (self.lTitle.textColor) {
        [self.oldConstants setObject:self.lTitle.textColor forKey:[NSString stringWithFormat:@"%@%@", PROPERTY_NAME(self.lTitle), @"Color"]];
    }
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backButton setImage:[UIImage imageNamed:@"return.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    self.title = @"资讯";
}

- (NSUInteger)supportedInterfaceOrientations
{
    if (IS_IPAD()) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskPortrait;
    }
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    // Reset last page flag
    self.lastPage = 0;
    
    self.lclTitleTop.constant = [[self.oldConstants objectForKey:PROPERTY_NAME(self.lclTitleTop)] floatValue];
    self.lcVerticalSpaceBetweenlTitlelSource.constant = [[self.oldConstants objectForKey:PROPERTY_NAME(self.lcVerticalSpaceBetweenlTitlelSource)] floatValue];
    self.lcvColorLeading.constant = [[self.oldConstants objectForKey:PROPERTY_NAME(self.lcvColorLeading)] floatValue];
    self.lclTitleTrailing.constant = [[self.oldConstants objectForKey:PROPERTY_NAME(self.lclTitleTrailing)] floatValue];
    
    self.lcivImageBottom.constant = 0;
    self.lcivImageTrailing.constant = 0;
    
    [self layoutImageByInterfaceOrientation:toInterfaceOrientation];
    
    if (self.article) {
        self.article = self.article;
    }
}

#pragma mark - Setters

- (void)setArticle:(RSArticle *)article
{
    _article = article;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // Header
        if (article.image) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                UIImage *image = [article.image imageWithNewSize:CGSizeMake(self.lcivImageWidth.constant, self.lcivImageHeight.constant)];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.ivImage.image = image;
                });
            });
        } else {
            self.ivImage.image = nil;
            self.lcivImageBottom.constant = 0;
        }
        self.lTitle.text = article.title;
        self.lSource.text = article.source;
        self.lDate.text = article.date;
        if (article.color) {
            self.vColor.backgroundColor = article.color;
        } else {
            self.vColor.backgroundColor = [UIColor clearColor];
        }
        [self layoutHeader:NO];
        
        // Body
        for (RSClipView *clipView in self.clipViews) {
            [clipView removeFromSuperview];
        }
        [self.clipViews removeAllObjects];
        
        if (article && article.clips) {
            [article.clips enumerateObjectsUsingBlock:^(UIImage *clip, NSUInteger idx, BOOL *stop) {
                RSClipView *clipView = [[RSClipView alloc] initWithImage:clip];
                clipView.tag = idx;
                clipView.userInteractionEnabled = YES;
                [clipView sizeToFit];
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
                [clipView addGestureRecognizer:tap];
                [self.clipViews addObject:clipView];
                [self.vContent addSubview:clipView];
            }];
            
            NSDictionary *attribute = @{NSFontAttributeName:self.bodyFont};
            CGRect rect = [article.body boundingRectWithSize:CGSizeMake(self.vContent.bounds.size.width - self.contentInsets.left - self.contentInsets.right, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil];
            NSUInteger pages = rect.size.height / self.vContent.bounds.size.height + ((NSInteger)rect.size.height % (NSInteger)self.vContent.bounds.size.height > 0 ? 1 : 0);
            NSUInteger numberOfClips = [article.clips count];
            if (numberOfClips <= pages) {
                // One clip view at one page
                for (int i = 0; i < numberOfClips; i++) {
                    CGRect frame = [self.clipViews[i] frame];
                    if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait) {
                        frame.origin.x = self.vContent.bounds.size.width - frame.size.width - self.contentInsets.right;
                        frame.origin.y = self.vContent.bounds.size.height * ((i + 1) + 1) - frame.size.height - self.contentInsets.bottom;
                    } else {
                        frame.origin.x = self.vContent.bounds.size.width * ((i + 1) + 1) - frame.size.width - self.contentInsets.right;
                        frame.origin.y = self.vContent.bounds.size.height - frame.size.height - self.contentInsets.bottom;
                    }
                    [self.clipViews[i] setFrame:frame];
                }
            } else {
                // All clip views at (pages - 1)
                for (int i = 0; i < numberOfClips; i++) {
                    CGRect frame = [self.clipViews[i] frame];
                    if (IS_IPAD()) {
                        if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait) {
                            frame.origin.x = self.vContent.bounds.size.width - frame.size.width * (i + 1) - self.contentInsets.right * (i + 1);
                        } else {
                            frame.origin.x = self.vContent.bounds.size.width *pages - frame.size.width * (i + 1) - self.contentInsets.right * (i + 1);
                        }
                    } else {
                        frame.origin.x = self.vContent.bounds.size.width - frame.size.width - self.contentInsets.right;
                    }
                    if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait) {
                        frame.origin.y = self.vContent.bounds.size.height * pages - frame.size.height - self.contentInsets.bottom;
                    } else {
                        frame.origin.y = self.vContent.bounds.size.height - frame.size.height - self.contentInsets.bottom;
                    }
                    [self.clipViews[i] setFrame:frame];
                }
            }
            NSMutableArray *clipViewsFrames = [[NSMutableArray alloc] initWithCapacity:numberOfClips];
            for (int i = 0; i < numberOfClips; i++) {
                [clipViewsFrames addObject:[NSValue valueWithCGRect:[self.clipViews[i] frame]]];
            }
            self.clipViewsFrames = [NSArray arrayWithArray:clipViewsFrames];
        }
        
        for (UIView *subview in self.vContent.subviews) {
            if ([subview isKindOfClass:[UITextView class]]) {
                [subview removeFromSuperview];
            }
        }
        
        if (article && article.body) {
            self.textStorage = [[NSTextStorage alloc] initWithString:article.body];
            self.layoutManager = [[NSLayoutManager alloc] init];
            [self.textStorage addLayoutManager:self.layoutManager];
            
            NSUInteger lastGlyph = 0;
            NSUInteger currentPage = 0;
            while (lastGlyph < self.layoutManager.numberOfGlyphs) {
                CGRect frame = CGRectZero;
                if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait) {
                    frame = CGRectMake(self.contentInsets.left,
                                       self.contentInsets.top + self.vContent.bounds.size.height * currentPage,
                                       self.vContent.bounds.size.width - self.contentInsets.left - self.contentInsets.right,
                                       self.vContent.bounds.size.height - self.contentInsets.top - self.contentInsets.bottom);
                    
                } else {
                    frame = CGRectMake(self.contentInsets.left + self.lcivImageWidth.constant * currentPage,
                                       (currentPage % 2 == 1) ? self.contentInsets.bottom : self.contentInsets.top,
                                       self.lcivImageWidth.constant - self.contentInsets.left - self.contentInsets.right,
                                       self.vContent.bounds.size.height - self.contentInsets.top - self.contentInsets.bottom);
                }
                
                if (currentPage == 0) {
                    CGFloat δ = self.vColor.frame.origin.y + self.vColor.bounds.size.height;
                    frame.origin.y = δ;
                    frame.size.height = self.vContent.bounds.size.height - δ - self.contentInsets.bottom;
                }
                
                NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:frame.size];
                NSMutableArray *paths = [[NSMutableArray alloc] init];
                UIView *referenceView = [[UIView alloc] initWithFrame:frame];
                [self.vContent addSubview:referenceView];
                __block CGFloat y = NSNotFound;
                [self.clipViews enumerateObjectsUsingBlock:^(RSClipView *clipView, NSUInteger idx, BOOL *stop) {
                    if (y == NSNotFound) {
                        y = clipView.frame.origin.y;
                    } else if (y != clipView.frame.origin.y) {
                        y = CGFLOAT_MAX;
                        *stop = YES;
                    }
                }];
                if (y == CGFLOAT_MAX) {
                    for (RSClipView *clipView in self.clipViews) {
                        CGRect frame = [referenceView convertRect:clipView.bounds
                                                         fromView:clipView];
                        [paths addObject:[UIBezierPath bezierPathWithRect:frame]];
                    }
                } else {
                    CGRect frame = CGRectMake(CGFLOAT_MAX, CGFLOAT_MAX, 0, 0);
                    for (RSClipView *clipView in self.clipViews) {
                        if (frame.origin.x > clipView.frame.origin.x) {
                            frame.origin.x = clipView.frame.origin.x;
                        }
                        
                        if (frame.origin.y > clipView.frame.origin.y) {
                            frame.origin.y = clipView.frame.origin.y;
                        }
                        
                        if ((clipView.frame.origin.x + clipView.frame.size.width) > frame.size.width) {
                            frame.size.width = (clipView.frame.origin.x + clipView.frame.size.width);
                        }
                        if ((clipView.frame.origin.y + clipView.frame.size.height) > frame.size.height) {
                            frame.size.height = (clipView.frame.origin.y + clipView.frame.size.height);
                        }
                    }
                    frame.size.width -= frame.origin.x;
                    frame.size.height -= frame.origin.y;
                    UIView *view = [[UIView alloc] initWithFrame:frame];
                    [self.vContent addSubview:view];
                    frame = [referenceView convertRect:view.bounds
                                              fromView:view];
                    [paths addObject:[UIBezierPath bezierPathWithRect:frame]];
                    [view removeFromSuperview];
                }
                [referenceView removeFromSuperview];
                
                [textContainer setExclusionPaths:[NSArray arrayWithArray:paths]];
                [self.layoutManager addTextContainer:textContainer];
                
                UITextView *textView = [[UITextView alloc] initWithFrame:frame
                                                           textContainer:textContainer];
                [textView setBackgroundColor:self.bodyBackgroundColor];
                [textView setTextColor:self.bodyTextColor];
                [textView setFont:self.bodyFont];
                textView.scrollEnabled = NO;
                textView.editable = NO;
                textContainer.size = textView.contentSize;
                [self.vContent addSubview:textView];
                
                lastGlyph = NSMaxRange([self.layoutManager glyphRangeForTextContainer:textContainer]);
                currentPage++;
            }
            for (RSClipView *clipView in self.clipViews) {
                [self.vContent bringSubviewToFront:clipView];
            }
            if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait) {
                self.lcivImageBottom.constant = self.vContent.bounds.size.height * currentPage - self.lcivImageHeight.constant;
            } else {
                self.lcivImageTrailing.constant = self.vContent.bounds.size.width * (currentPage / 2 + ((currentPage % 2) == 1 ? 1 : 0)) - self.lcivImageWidth.constant;
            }
        }
    });
}

- (NSMutableDictionary *)oldConstants
{
    if (!_oldConstants) {
        _oldConstants = [[NSMutableDictionary alloc] init];
    }
    return _oldConstants;
}

- (NSMutableArray *)clipViews
{
    if (!_clipViews) {
        _clipViews = [[NSMutableArray alloc] init];
    }
    return _clipViews;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.vContent) {
        if (self.enableImageDragZoomIn) {
            CGFloat yOffset = scrollView.contentOffset.y;
            if (yOffset < 0) {
                self.lcivImageTop.constant = [[self.oldConstants objectForKey:PROPERTY_NAME(self.lcivImageTop)] floatValue] + yOffset;
                self.lcivImageHeight.constant = [[self.oldConstants objectForKey:PROPERTY_NAME(self.lcivImageHeight)] floatValue] - yOffset;
            } else {
                self.lcivImageTop.constant = [[self.oldConstants objectForKey:PROPERTY_NAME(self.lcivImageTop)] floatValue];
                self.lcivImageHeight.constant = [[self.oldConstants objectForKey:PROPERTY_NAME(self.lcivImageHeight)] floatValue];
            }
            [self.ivImage layoutIfNeeded];
        }
    }
}

- (void)layoutHeader:(BOOL)animated
{
    void(^layoutIfNeeded)() = [^() {
        [self.lTitle layoutIfNeeded];
        [self.lSource layoutIfNeeded];
        [self.lDate layoutIfNeeded];
        [self.vColor layoutIfNeeded];
        [self.ivImage layoutIfNeeded];
    } copy];
    
    if (animated) {
        [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
            layoutIfNeeded();
        } completion:nil];
    } else {
        layoutIfNeeded();
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.vContent) {
        NSUInteger currentPage = 0;
        if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait) {
            currentPage = roundf(scrollView.contentOffset.y / (scrollView.frame.size.height));
        } else {
            currentPage = roundf(scrollView.contentOffset.x / (scrollView.frame.size.width));
        }
        if (currentPage == 0) {
            self.lTitle.font = [self.oldConstants objectForKey:[NSString stringWithFormat:@"%@%@", PROPERTY_NAME(self.lTitle), @"Font"]];
            self.lTitle.textColor = [self.oldConstants objectForKey:[NSString stringWithFormat:@"%@%@", PROPERTY_NAME(self.lTitle), @"Color"]];
            self.lclTitleTop.constant = [[self.oldConstants objectForKey:PROPERTY_NAME(self.lclTitleTop)] floatValue];
            self.lcVerticalSpaceBetweenlTitlelSource.constant = [[self.oldConstants objectForKey:PROPERTY_NAME(self.lcVerticalSpaceBetweenlTitlelSource)] floatValue];
            self.lSource.text = self.article.source;
            self.lDate.text = self.article.date;
            if ([[UIApplication sharedApplication] statusBarOrientation] != UIInterfaceOrientationPortrait) {
                // FIXME: Avoid auto layout warning logs
                if (self.lastPage < currentPage) {
                    self.lclTitleTrailing.constant = [[self.oldConstants objectForKey:PROPERTY_NAME(self.lclTitleTrailing)] floatValue];
                    self.lcvColorLeading.constant = [[self.oldConstants objectForKey:PROPERTY_NAME(self.lcvColorLeading)] floatValue];
                } else {
                    self.lcvColorLeading.constant = [[self.oldConstants objectForKey:PROPERTY_NAME(self.lcvColorLeading)] floatValue];
                    self.lclTitleTrailing.constant = [[self.oldConstants objectForKey:PROPERTY_NAME(self.lclTitleTrailing)] floatValue];
                }
            }
            [self layoutHeader:YES];
            
        } else if (currentPage > 0) {
            self.lTitle.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
            [self.lTitle layoutIfNeeded];
            self.lTitle.textColor = [UIColor lightGrayColor];
            self.lclTitleTop.constant = self.vContent.bounds.size.height * currentPage - self.lcivImageTop.constant - self.lcivImageHeight.constant + roundf((self.contentInsets.top - self.lTitle.bounds.size.height) / 2.0f);
            self.lcVerticalSpaceBetweenlTitlelSource.constant = 0;
            self.lSource.text = nil;
            self.lDate.text = nil;
            if ([[UIApplication sharedApplication] statusBarOrientation] != UIInterfaceOrientationPortrait) {
                // FIXME: Avoid auto layout warning logs
                if (self.lastPage < currentPage) {
                    self.lclTitleTrailing.constant = [[self.oldConstants objectForKey:PROPERTY_NAME(self.lclTitleTrailing)] floatValue] + self.vContent.bounds.size.width * currentPage;
                    self.lcvColorLeading.constant = [[self.oldConstants objectForKey:PROPERTY_NAME(self.lcvColorLeading)] floatValue] + self.vContent.bounds.size.width * currentPage;
                } else {
                    self.lcvColorLeading.constant = [[self.oldConstants objectForKey:PROPERTY_NAME(self.lcvColorLeading)] floatValue] + self.vContent.bounds.size.width * currentPage;
                    self.lclTitleTrailing.constant = [[self.oldConstants objectForKey:PROPERTY_NAME(self.lclTitleTrailing)] floatValue] + self.vContent.bounds.size.width * currentPage;
                }
                
                self.lclTitleTop.constant = -self.lcivImageHeight.constant + roundf((self.contentInsets.top - self.lTitle.bounds.size.height) / 2.0f);
            }
            [self layoutHeader:YES];
        }
        
        self.lastPage = currentPage;
        
        for (RSClipView *clipView in self.clipViews) {
            clipView.frame = [self.clipViewsFrames[clipView.tag] CGRectValue];
        }
    }
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
