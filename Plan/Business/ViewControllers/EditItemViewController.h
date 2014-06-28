//
//  EditItemViewController.h
//  Plan
//
//  Created by gamyhuang on 14-6-28.
//  Copyright (c) 2014年 gamy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Item;
@interface EditItemViewController : UITableViewController<UITextViewDelegate>

@property(nonatomic, weak)Item *item;

@end
