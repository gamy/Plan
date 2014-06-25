//
//  DetailViewController.h
//  Plan
//
//  Created by gamyhuang on 14-6-25.
//  Copyright (c) 2014年 gamy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
