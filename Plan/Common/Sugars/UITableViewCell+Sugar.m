//
//  UITableViewCell+Sugar.m
//  Plan
//
//  Created by gamyhuang on 14-7-2.
//  Copyright (c) 2014年 gamy. All rights reserved.
//

#import "UITableViewCell+Sugar.h"
#import "GMOptionView.h"

@implementation UITableViewCell (Sugar)

- (void)setAttachment:(id)attachment
{
    [self bk_associateValue:attachment withKey:@"attachment"];
}

- (id)attachment
{
    return [self bk_associatedValueForKey:@"attachment"];
}

@end
