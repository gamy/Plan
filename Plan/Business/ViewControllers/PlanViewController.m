//
//  MasterViewController.m
//  Plan
//
//  Created by gamyhuang on 14-6-25.
//  Copyright (c) 2014年 gamy. All rights reserved.
//

#import "PlanViewController.h"
#import "ItemsViewController.h"
#import "Plan.h"

@interface PlanViewController ()<UIImagePickerControllerDelegate> {

}
@property(nonatomic, weak) NSArray *plans;

@end


@implementation PlanViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.plans = [[PlanManager sharedManager] allModels];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[PlanManager sharedManager] sortModels];
    [self.tableView reloadData];
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _plans.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    Plan *object = _plans[indexPath.row];
    cell.textLabel.text = object.title;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[object.modifyDate formattedAsTimeAgo]];
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
        Model *model = self.plans[indexPath.row];
        [[PlanManager sharedManager] deleteModel:model];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    Plan *plan = nil;
    if ([[segue identifier] isEqualToString:@"showPlan"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        plan = _plans[indexPath.row];
    }else if ([[segue identifier] isEqualToString:@"addPlan"]) {
        plan = [[PlanManager sharedManager] createModel];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    [[segue destinationViewController] setPlan:plan];
}



@end
