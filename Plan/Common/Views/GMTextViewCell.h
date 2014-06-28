//
//  GMTextViewCell.h
//  Plan
//
//  Created by gamyhuang on 14-6-28.
//  Copyright (c) 2014年 gamy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMTextView.h"

@interface GMTextViewCell : UITableViewCell

@property(nonatomic, weak) IBOutlet GMTextView *textView;

+ (NSString *)reuseIdentifier;

@end
