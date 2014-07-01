//
// GMTextView.h
//  Plan
//
//  Created by gamyhuang on 14-06-09.
//  Copyright 2014 gamy. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GMTextView : UITextView 

@property(nonatomic, strong) NSString *placeholder;

@property (nonatomic, strong) UIColor *realTextColor;
@property (nonatomic, strong) UIColor *placeholderColor;


@property(nonatomic, assign) NSUInteger maxTextLength;



@end
