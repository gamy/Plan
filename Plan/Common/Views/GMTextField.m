//
//  GMTextField.m
//  Plan
//
//  Created by gamyhuang on 14-6-28.
//  Copyright (c) 2014年 gamy. All rights reserved.
//

#import "GMTextField.h"

@implementation GMTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self registerObserver];
    }
    return self;
}

- (void)registerObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkText:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self registerObserver];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)checkText:(NSNotification *)note
{
    if (self.maxTextLength > 0 && self.markedTextRange == nil && self.maxTextLength < [self.text length]) {
        self.text = [self.text substringToIndex:self.maxTextLength];
    }
}
@end
