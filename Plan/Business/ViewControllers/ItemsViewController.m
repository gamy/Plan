//
//  DetailViewController.m
//  Plan
//
//  Created by gamyhuang on 14-6-25.
//  Copyright (c) 2014年 gamy. All rights reserved.
//

#import "ItemsViewController.h"
#import "EditItemViewController.h"
#import "GMTextField.h"
#import "Item.h"


@interface ItemsViewController ()

@property(nonatomic, strong)NSMutableArray *items;

- (void)configureView;
@end

@implementation ItemsViewController

#pragma mark - Managing the detail item

- (void)configureView
{
    __weak GMTextField *textField = (id)[self.navigationItem titleView];
    __weak Plan *plan = self.plan;
    __weak typeof (self) wself = self;
    
    wself.title = self.plan.title;
    
    textField.text = self.plan.title;

    textField.bk_didEndEditingBlock = ^(UITextField *field){
        if ([field.text length] != 0 && plan) {
            plan.title = field.text;
            wself.title = field.text;
            [[PlanManager sharedManager] saveModel:plan];
        }
    };
    if ([self.plan.title isEqualToString:@"未命名"]) {
        [textField performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.2];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureView];
    self.items = [[ItemManager sharedManager] itemsForPlanId:self.plan.cid];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.items sortUsingComparator:[Item comparator]];
    [self.tableView reloadData];
}

- (void)dealloc
{
    [[PlanManager sharedManager] saveModel:self.plan];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ItemCell" forIndexPath:indexPath];
    
    Item *object = _items[indexPath.row];
    cell.textLabel.text = object.title;
    cell.detailTextLabel.text = object.priceDescription;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Model *model = self.items[indexPath.row];
        [[ItemManager sharedManager] deleteModel:model];
        [self.items removeObject:model];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    Item *item = nil;
    if ([[segue identifier] isEqualToString:@"showItem"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        item = _items[indexPath.row];
    }else if ([[segue identifier] isEqualToString:@"addItem"]) {
        item = [[ItemManager sharedManager] createModel];
        item.planId = self.plan.cid;
        [self.items insertObject:item atIndex:0];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    [(EditItemViewController *)[segue destinationViewController] setItem:item];
    [[self.navigationItem titleView] resignFirstResponder];
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [[self.navigationItem titleView] resignFirstResponder];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
