//
//  EditItemViewController.m
//  Plan
//
//  Created by gamyhuang on 14-6-28.
//  Copyright (c) 2014年 gamy. All rights reserved.
//

#import "EditItemViewController.h"
#import "GMTextFieldCell.h"
#import "GMTextViewCell.h"
#import "GMGridImageCell.h"
#import "Item.h"


typedef void (^ConfigCellBlock) (NSIndexPath *indexPath, UITableViewCell *cell, Item *item);


typedef enum{
     EditSectionTitle,
     EditSectionPrice,
     EditSectionDetail,
     EditSectionImage,
     EditSectionCount
}EditSection;

@interface EditItemViewController ()

@end

@implementation EditItemViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)configureView
{
    __weak typeof (self) wself = self;
    [self.view bk_whenTapped:^{
        [[wself.view firstResponder] becomeFirstResponder];
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureView];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [[ItemManager sharedManager] saveModel:self.item];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return EditSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == EditSectionImage) {
        return ([self.item.images count] % 3) + 1;
    }
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat heights[] = {44.f, 44.f, 130.f, 110.f};
    return heights[indexPath.section];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    __weak typeof (self) wself = self;
    
    NSArray * reuseIdentifiers = @[[GMTextFieldCell reuseIdentifier], [GMTextFieldCell reuseIdentifier], [GMTextViewCell reuseIdentifier], [GMGridImageCell reuseIdentifier]];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifiers[indexPath.section] forIndexPath:indexPath];

    static ConfigCellBlock titleCellConfig = ^(NSIndexPath *indexPath, UITableViewCell *cell, Item *item)
    {
        GMTextFieldCell *tc = (id)cell;
        tc.textFiled.placeholder = @"名称";
        tc.textFiled.text = item.title;
        tc.textFiled.maxTextLength = 15;
        tc.textFiled.keyboardType = UIKeyboardTypeDefault;
        tc.textFiled.bk_didEndEditingBlock = ^(UITextField *textField)
        {
            item.title = textField.text;
            [[ItemManager sharedManager] saveModel:item];
        };
    };

    static ConfigCellBlock priceCellConfig = ^(NSIndexPath *indexPath, UITableViewCell *cell, Item *item)
    {
        GMTextFieldCell *tc = (id)cell;
        tc.textFiled.placeholder = @"价格";
        tc.textFiled.text = item.priceDescription;
        tc.textFiled.maxTextLength = 10;
        tc.textFiled.keyboardType = UIKeyboardTypeNumberPad;
        
        tc.textFiled.bk_didEndEditingBlock = ^(UITextField *textField)
        {
            item.price = [textField.text floatValue];
            [[ItemManager sharedManager] saveModel:item];
        };
 
    };

    static ConfigCellBlock detailCellConfig = ^(NSIndexPath *indexPath, UITableViewCell *cell, Item *item)
    {
        GMTextViewCell *tc = (id)cell;
        tc.textView.text = item.detail;
        
    };


    static ConfigCellBlock imageCellConfig = ^(NSIndexPath *indexPath, UITableViewCell *cell, Item *item)
    {
        GMGridImageCell *tc = (id)cell;
        NSUInteger count = [item.images count];
        NSUInteger loc = count - indexPath.row * 3;
        NSUInteger length = MIN(3, count - loc);
        NSArray *images = nil;
        if (length > 0) {
            images = [item.images subarrayWithRange:NSMakeRange(loc, length)];
        }
        [tc updateWithImages:images indexPath:indexPath];
        tc.tapImageBlock = ^(NSInteger index, NSIndexPath *ip){
            NSLog(@"tap in image, index = %d, indexPath = %@", index, ip);
        };
        
        tc.addImageBlock = ^(NSInteger index, NSIndexPath *ip){
            NSLog(@"add image, index = %d, indexPath = %@", index, ip);
        };
        
        tc.longPressImageBlock = ^(NSInteger index, NSIndexPath *ip){
            NSLog(@"long press in image, index = %d, indexPath = %@", index, ip);
        };
    };

        
    NSArray *configures = @[titleCellConfig, priceCellConfig, detailCellConfig, imageCellConfig];
    ConfigCellBlock config = configures[indexPath.section];
    config(indexPath, cell, self.item);
    
    if ([cell isKindOfClass:[GMTextViewCell class]]) {
        [(GMTextViewCell*) cell textView].delegate = wself;
    }
    return cell;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    self.item.detail = textView.text;
    [[ItemManager sharedManager] saveModel:self.item];
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    UIView *firstRes = [self.tableView firstResponder];
    [firstRes resignFirstResponder];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


@end
