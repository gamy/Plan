//
//  GMTextFieldCell.h
//  Plan
//
//  Created by gamyhuang on 14-6-28.
//  Copyright (c) 2014年 gamy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMTextField.h"

@interface GMTextFieldCell : UITableViewCell

@property(nonatomic, weak) IBOutlet GMTextField *textFiled;

+ (NSString *)reuseIdentifier;

@end
