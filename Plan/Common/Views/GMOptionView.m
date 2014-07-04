//
//  GMOptionView.m
//  Plan
//
//  Created by gamyhuang on 14-7-2.
//  Copyright (c) 2014年 gamy. All rights reserved.
//

#import "GMOptionView.h"
#import "UIView+Sugar.h"

typedef NS_ENUM(NSInteger, OptionStatus){
    OptionStatusClose,
    OptionStatusShow,
    OptionStatusAnimating,
};

@interface GMOptionView()<UIScrollViewDelegate>
@property(nonatomic, strong)NSMutableArray *buttons;
@property(nonatomic, strong)UIScrollView *scrollView;
@property(nonatomic, strong)UIImageView *snapCell;
@property(nonatomic, copy)GMOptionHandler handler;
@end

@implementation GMOptionView



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#define BUTTON_WIDTH (40.f)

- (UIButton *)createButton:(BOOL)gray height:(CGFloat)height title:(NSString *)title
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, BUTTON_WIDTH, height);
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickOption:) forControlEvents:UIControlEventTouchUpInside];
    if (!gray) {
        btn.backgroundColor = [UIColor colorWithRed:251./255. green:34./255. blue:38./255. alpha:1.];
    }else{
        btn.backgroundColor = [UIColor lightGrayColor];
    }
    return btn;
}

+ (instancetype)optionViewWithCell:(UITableViewCell *)cell optionTitles:(NSArray *)titles handler:(GMOptionHandler)handler
{
    GMOptionView *opView = [[GMOptionView alloc] initWithFrame:cell.bounds];
    
    CGFloat width = BUTTON_WIDTH;
    CGFloat height = CGRectGetHeight(opView.frame);
    
    CGFloat startX = CGRectGetWidth(opView.bounds) - width * [titles count];
    
    opView.buttons = [NSMutableArray array];
    NSInteger i = 0;
    for (NSString *title in titles) {
        BOOL gray = (i != ([titles count] - 1));
        UIButton *button = [opView createButton:gray height:height title:title];
        [opView addSubview:button];
        [opView.buttons addObject:button];
        CGRect frame = button.frame;
        frame.origin.x = startX + i * width;
        button.frame = frame;
        i ++;
    }
    
    opView.snapCell = [[UIImageView alloc] initWithFrame:opView.bounds];
    opView.snapCell.image = cell.snapshot;
    
    opView.scrollView = [[UIScrollView alloc] initWithFrame:opView.bounds];
    CGFloat buttonWidth = BUTTON_WIDTH * [titles count];
    CGFloat boundsWidth = CGRectGetWidth(opView.bounds);
    opView.scrollView.contentSize = CGSizeMake(buttonWidth+boundsWidth, height);

    //update opView frame
    CGRect frame = opView.frame;
    frame.origin.x = buttonWidth;
    opView.snapCell.frame = frame;
    
    opView.scrollView.contentOffset = CGPointMake(buttonWidth, 0);
    
    [opView.scrollView addSubview:opView.snapCell];
    opView.scrollView.delegate = opView;
    [opView addSubview:opView.scrollView];
    [cell addSubview:opView];
    return opView;
}


- (CGFloat)buttonsWitdh
{
    return BUTTON_WIDTH * [self.buttons count];
}

- (void)dragOffset:(CGFloat)offset
{
    CGRect rect = self.snapCell.frame;
    rect.origin.x = - offset;
    self.snapCell.frame = rect;
    CGFloat offsetX = [self buttonsWitdh] - offset;
    offsetX = MAX(offsetX, [self buttonsWitdh]);
    self.scrollView.contentOffset = CGPointMake(offsetX, 0);
}

- (void)relaxAtOffset:(CGFloat)offset
{
    [self dragOffset:offset];
    if (offset < [self buttonsWitdh] / 2) {
//        [self.scrollView setContentOffset:CGPointMake([self buttonsWitdh], 0) animated:YES];
        [self hide:YES];
    }else{
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}

- (void)hide:(BOOL)animated
{
    [self.scrollView setContentOffset:CGPointMake([self buttonsWitdh], 0) animated:animated];
}

- (void)clickOption:(UIButton *)sender
{
    if (self.handler) {
        self.handler(self, sender.tag);
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self relaxAtOffset:scrollView.contentOffset.x - [self buttonsWitdh]];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x >= [self buttonsWitdh]) {
        [self removeFromSuperview];        
    }
}

@end
