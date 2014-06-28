//
//  GMGridImageCell.h
//  Plan
//
//  Created by gamyhuang on 14-6-28.
//  Copyright (c) 2014年 gamy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GMGridImageCell : UITableViewCell

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *imageViews;
@property (strong, readonly) NSIndexPath *indexPath;

@property (copy, nonatomic) void (^longPressImageBlock) (NSInteger index, NSIndexPath *indexPath);
@property (copy, nonatomic) void (^tapImageBlock) (NSInteger index, NSIndexPath *indexPath);
@property (copy, nonatomic) void (^addImageBlock) (NSInteger index, NSIndexPath *indexPath);


+ (NSString *)reuseIdentifier;

- (void)updateWithImages:(NSArray *)images indexPath:(NSIndexPath *)indexPath;



@end
