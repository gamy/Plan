//
//  GMTextView.m
//  Plan
//
//  Created by gamyhuang on 14-06-09.
//  Copyright 2014 tencent. All rights reserved.
//

#import "GMTextView.h"

@interface GMTextView () 
{
    BOOL settingText;
}
@property (nonatomic, strong) UILabel *placeHolderLabel;

@property (nonatomic, assign) BOOL showPlaceHolder;


@end

@implementation GMTextView


#pragma mark -
#pragma mark Initialisation

- (id) initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self awakeFromNib];
    }
    return self;
}


- (CGRect)labelFrame
{
    CGFloat height = self.font.lineHeight;
    CGFloat xpadding = 5.f;
    CGFloat ypadding = 8.f;
    if (![GMDevice iOS7]) {
        xpadding = 10.f;
    }
    CGFloat width = CGRectGetWidth(self.bounds) - 2*xpadding;
    
    return CGRectMake(xpadding, ypadding, width, height);
}

- (void)awakeFromNib {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:self];
    
    
    //set up holder label.
    self.placeHolderLabel = [[UILabel alloc] initWithFrame:[self labelFrame]];
    [self addSubview:self.placeHolderLabel];
    self.placeHolderLabel.textAlignment = self.textAlignment;
    self.placeHolderLabel.font = self.font;
    self.placeHolderLabel.text = self.placeholder;

    self.realTextColor = self.textColor;
    self.placeholderColor = [UIColor colorWithHex:0xcccccc];
    self.showPlaceHolder = [[super text] length] == 0;

    self.placeHolderLabel.hidden = !self.showPlaceHolder;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.placeHolderLabel.frame = [self labelFrame];
}

#pragma mark -
#pragma mark Setter/Getters


- (void) setPlaceholder:(NSString *)aPlaceholder
{
    _placeholder = aPlaceholder;
    self.placeHolderLabel.text = aPlaceholder;
}


- (void)setPlaceholderColor:(UIColor *)aPlaceholderColor
{
    _placeholderColor = aPlaceholderColor;
    self.placeHolderLabel.textColor = aPlaceholderColor;
}


- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    self.placeHolderLabel.font = font;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment
{
    [super setTextAlignment:textAlignment];
    self.placeHolderLabel.textAlignment = textAlignment;
}


- (void) setText:(NSString *)text {
    settingText = YES;
    [super setText:text];
    self.showPlaceHolder = (text.length == 0);
    self.placeHolderLabel.hidden = !self.showPlaceHolder;
    settingText = NO;
}

- (void) textChanged:(NSNotification *)notification
{
    if (notification.object == self) {
        self.showPlaceHolder = ([[super text] length] == 0);
        self.placeHolderLabel.hidden = !self.showPlaceHolder;
        
        if (self.maxTextLength > 0 && self.markedTextRange == nil && self.maxTextLength < [self.text length]) {
            self.text = [self.text substringToIndex:self.maxTextLength];
        }else{
            [self systemBugFixWithNotification:notification];
        }
    }
}


- (void)scrollToCaretInTextView:(UITextView *)textView animated:(BOOL)animated {
    CGRect rect = [textView caretRectForPosition:textView.selectedTextRange.end];
    rect.size.height += textView.textContainerInset.bottom;
    [textView scrollRectToVisible:rect animated:animated];
}

//在ios7 下，如果敲入return键换行，会导致最后一行被遮住。系统bug

- (void)systemBugFixWithNotification:(NSNotification *)notification {
    if (notification.object == self && [GMDevice iOS7] && !settingText) {
        UITextView *textView = self;
        if ([textView.text hasSuffix:@"\n"]) {
            [CATransaction setCompletionBlock:^{
                [self scrollToCaretInTextView:textView animated:NO];
            }];
        } else {
            [self scrollToCaretInTextView:textView animated:NO];
        }
    }
}




#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
