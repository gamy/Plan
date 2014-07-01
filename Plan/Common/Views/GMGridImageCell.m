//
//  GMGridImageCell.m
//  Plan
//
//  Created by gamyhuang on 14-6-28.
//  Copyright (c) 2014年 gamy. All rights reserved.
//

#import "GMGridImageCell.h"


#define MAX_IMAGE_NUMBER 3

@interface GMGridImageCell()<UIGestureRecognizerDelegate>

@property(nonatomic, strong)NSArray *images;

@end

@implementation GMGridImageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}


#define ADD_IMAGE_VIEW_TAG (20140701)


- (BOOL)isImageViewAddView:(UIImageView *)imageView
{
    return imageView.tag == ADD_IMAGE_VIEW_TAG;
}

- (void)awakeFromNib
{
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    WEAK_SELF(wself);
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

        }];
        lg.delegate = self;
        lg.minimumPressDuration = 0.3;
        [iv addGestureRecognizer:lg];
        
        ++ i;
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return YES;
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
        iv.tag = 0;
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
            iv.tag = ADD_IMAGE_VIEW_TAG;
            iv.image = [UIImage imageNamed:@"add_photo"];
        }else{
            iv.tag = 0;
            iv.hidden = YES;
        }
        temp ++;
    }
}
@end
