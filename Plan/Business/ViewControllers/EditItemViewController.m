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
#import "GMPhotoPicker.h"

typedef void (^ConfigCellBlock) (NSIndexPath *indexPath, UITableViewCell *cell, Item *item);




typedef enum{
     EditSectionTitle,
     EditSectionPrice,
     EditSectionDetail,
     EditSectionImage,
     EditSectionCount
}EditSection;

@interface EditItemViewController ()
{

}

@property(nonatomic, strong)GMPhotoPicker *picker;

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
    WEAK_SELF(wself);
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

- (void)dealloc
{
    [[ItemManager sharedManager] saveModel:self.item];
    [self.item clearImageCache];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return EditSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == EditSectionImage) {
        NSUInteger count = [self.item.imageKeys count];
        NSUInteger number = (count/3) + 1;
        return number;
    }
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat heights[] = {44.f, 44.f, 80.f, 110.f};
    return heights[indexPath.section];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray * reuseIdentifiers = @[[GMTextFieldCell reuseIdentifier], [GMTextFieldCell reuseIdentifier], [GMTextViewCell reuseIdentifier], [GMGridImageCell reuseIdentifier]];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifiers[indexPath.section] forIndexPath:indexPath];

    
    WEAK_SELF(wself);
    static ConfigCellBlock titleCellConfig = ^(NSIndexPath *indexPath, UITableViewCell *cell, Item *item)
    {
        GMTextFieldCell *tc = (id)cell;
        tc.textFiled.placeholder = @"名称";
        tc.textFiled.text = item.title;
        tc.textFiled.maxTextLength = 15;
        tc.textFiled.keyboardType = UIKeyboardTypeDefault;
        tc.textFiled.bk_didEndEditingBlock = ^(UITextField *textField)
        {
            if ([textField.text length] != 0) {
                item.title = textField.text;
                [[ItemManager sharedManager] saveModel:item];
            }
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


    ConfigCellBlock imageCellConfig = ^(NSIndexPath *indexPath, UITableViewCell *cell, Item *item)
    {
        GMGridImageCell *tc = (id)cell;
        NSUInteger count = [item.imageKeys count];
        NSUInteger loc = indexPath.row * 3;
        NSUInteger length = MIN(3, count - loc);
        NSMutableArray *images = [NSMutableArray arrayWithCapacity:3];
        if (length > 0) {
            NSArray *keys  = [item.imageKeys subarrayWithRange:NSMakeRange(loc, length)];
            for (NSString *key in keys) {
                UIImage *image = [item imageForKey:key];
                if (image) {
                    [images addObject:image];
                }
            }
        }
        [tc updateWithImages:images indexPath:indexPath];
        tc.tapImageBlock = ^(NSInteger index, NSIndexPath *ip){
            //TODO enter phto broswer
        };
        
        tc.addImageBlock = ^(NSInteger index, NSIndexPath *ip){
            [wself pickPhoto:nil];
        };
        
        tc.longPressImageBlock = ^(NSInteger index, NSIndexPath *ip){
            NSString *key = item.imageKeys[ip.row*3 + index];
            [wself editPhoto:key];
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



- (void)editPhoto:(NSString *)imageKey
{
    WEAK_SELF(wself);
    
    UIActionSheet *as = [UIActionSheet bk_actionSheetWithTitle:@"删除或更新图片"];
    [as bk_setDestructiveButtonWithTitle:@"删除" handler:^{
        [wself.item removeImageWithKey:imageKey];
        [[ItemManager sharedManager] saveModel:wself.item];
        [wself.tableView reloadData];
    }];
    
    [as bk_addButtonWithTitle:@"更新" handler:^{
        [wself pickPhoto:imageKey];
    }];
    [as bk_setCancelButtonWithTitle:@"取消" handler:NULL];
    [as showInView:[[UIApplication sharedApplication] keyWindow]];

}

- (void)pickPhoto:(NSString *)imageKey
{
    WEAK_SELF(wself);
    
    PhotoPickerBlock block = ^(UIImage *photo){
        NSAssert(photo, @"phto is nil!!");
        if (photo) {
            if (imageKey) {
                [wself.item setImage:photo ForKey:imageKey];
            }else{
                [wself.item addImage:photo];
            }
            [[ItemManager sharedManager] saveModel:wself.item];
        }
        [wself.tableView reloadData];
    };
    
    UIActionSheet *as = [UIActionSheet bk_actionSheetWithTitle:imageKey?@"更新图片":@"添加图片"];
    [as bk_addButtonWithTitle:@"拍照" handler:^{
        wself.picker = [GMCameraPicker new];
        [wself.picker showPickerInController:wself customBlock:^(UIImagePickerController *pickerController) {
            [GMCameraPicker updatePickerController:pickerController allowsEditing:YES cameraDevice:UIImagePickerControllerCameraDeviceRear];
        } photoBlock:block];
    }];
    
    [as bk_addButtonWithTitle:@"从手机相册选择" handler:^{
        wself.picker = [GMAlbumPicker new];
        [wself.picker showPickerInController:wself customBlock:^(UIImagePickerController *pickerController) {
            pickerController.allowsEditing = YES;
        } photoBlock:block];
    }];
    [as bk_setCancelButtonWithTitle:@"取消" handler:NULL];
    [as showInView:[[UIApplication sharedApplication] keyWindow]];
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

@end
