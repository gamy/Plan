//
//  GMGridImageCell.m
//  Plan
//
//  Created by gamyhuang on 14-6-28.
//  Copyright (c) 2014年 gamy. All rights reserved.
//

#import "GMGridImageCell.h"


#define MAX_IMAGE_NUMBER 3

@interface GMGridImageCell()

@property(nonatomic, weak)NSArray *images;

@end

@implementation GMGridImageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (BOOL)isImageViewAddView:(UIImageView *)imageView
{
    NSInteger count = self.images.count;
    if (count < MAX_IMAGE_NUMBER) {
        NSInteger i = 0;
        for (UIImageView *iv in self.imageViews) {
            if (i++ == count) {
                return imageView == iv;
            }
        }
    }
    return NO;
}

- (void)awakeFromNib
{
    __weak typeof (self) wself = self;
    NSInteger i = 0;
    for (UIImageView *iv in self.imageViews) {
        iv.userInteractionEnabled = YES;
        [iv bk_whenTapped:^{
            if ([wself isImageViewAddView:iv]) {
                if (wself.addImageBlock) {
                    wself.addImageBlock(i,wself.indexPath);
                }
            }else{
                if (wself.tapImageBlock) {
                    wself.tapImageBlock(i, wself.indexPath);
                }
            }
        }];
        
        UILongPressGestureRecognizer *lg = [UILongPressGestureRecognizer bk_recognizerWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
            if (state == UIGestureRecognizerStateEnded) {
                if (wself.longPressImageBlock) {
                    wself.longPressImageBlock(i, wself.indexPath);
                }
            }
        } delay:1];
        
        [iv addGestureRecognizer:lg];
        
        ++ i;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString *)reuseIdentifier
{
    return @"GMGridImageCell";
}


- (void)updateWithImages:(NSArray *)images indexPath:(NSIndexPath *)indexPath
{
    self.images = images;
    _indexPath = indexPath;
    
    NSInteger i = 0;
    for (UIImage *image in images) {
        UIImageView *iv = self.imageViews[i];
        iv.hidden = NO;
        iv.image = image;
        iv.backgroundColor = [UIColor clearColor];
        i ++;
        if (i > MAX_IMAGE_NUMBER) {
            break;
        }
    }
    NSInteger temp = i;
    while (temp < MAX_IMAGE_NUMBER) {
        UIImageView *iv = self.imageViews[temp];
        if (temp == i ) {
            iv.hidden = NO;
            //TODO set add image
            iv.backgroundColor = [UIColor redColor];
        }else{
            iv.hidden = YES;
            iv.backgroundColor = [UIColor clearColor];
        }
        temp ++;
    }
}

@end
