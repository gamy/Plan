//
//  GMOptionView.h
//  Plan
//
//  Created by gamyhuang on 14-7-2.
//  Copyright (c) 2014年 gamy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GMOptionView;
typedef void (^GMOptionHandler) (GMOptionView *optionView, NSInteger index) ;

@interface GMOptionView : UIView

+ (instancetype)optionViewWithCell:(UITableViewCell *)cell optionTitles:(NSArray *)titles handler:(GMOptionHandler)handler;

- (void)dragOffset:(CGFloat)offset;

- (void)relaxAtOffset:(CGFloat)offset;

- (void)hide:(BOOL)animated;

@end
