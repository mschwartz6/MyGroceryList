//
//  SingleListTableViewController.m
//  MyGroceryList
//
//  Created by bloqhed on 12/15/17.
//  Copyright © 2017 cvr. All rights reserved.
//

#import "SingleListTableViewController.h"
#import "AddItemViewController.h"
#import "Item+CoreDataClass.h"
@interface SingleListTableViewController ()

@end

@implementation SingleListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    context = appDelegate.persistentContainer.viewContext;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated {
    NSLog(@"\n\n%@\n\n",[self.listName valueForKey:@"listName"]);
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:@"Item"];
    self.items = [[context executeFetchRequest:fetchRequest error:nil]mutableCopy];
    if ([self.items count]==0)
    {
        Item *anItem = [[Item alloc]initWithContext:context];
        [anItem setValue:@"Apples" forKey:@"itemName"];
        [anItem setValue:@"Produce" forKey:@"itemCategory"];
        [anItem setValue:[self.listName valueForKey:@"listName"] forKey:@"listName"];
        [self.items addObject:anItem];
    }
    
    [self.tableView reloadData];
}
- (IBAction)saveAndGoBack:(UIBarButtonItem *)sender {
    NSError *error = nil;
    if (![context save:&error]){
        NSLog(@"%@ %@",error,[error localizedDescription]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.items count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"SingleListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    NSManagedObjectModel *anItem = [self.items objectAtIndex:indexPath.row];
    
    [cell.textLabel setText:[anItem valueForKey:@"itemName"]];
    [cell.detailTextLabel setText:[anItem valueForKey:@"itemCategory"]];
  //  NSLog(@"%@ - %@ - %@",[anItem valueForKey:@"itemName"],[anItem valueForKey:@"itemCategory"],[anItem valueForKey:@"listName"]);
    // Configure the cell...
    
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.items count] > 1)
        return YES;
    return NO;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
   
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [context deleteObject:[self.items objectAtIndex:indexPath.row]];
    }
    
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"%@ %@", error, [error localizedDescription]);
    }
    
    //delete row from memory object
    [self.items removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"editItemInfo"]) {
        NSManagedObjectModel *selectedItem = [self.items objectAtIndex:[[self.tableView indexPathForSelectedRow]row]];
        AddItemViewController *updateItemView = segue.destinationViewController;
        updateItemView.anItem = selectedItem;
        updateItemView.listName = self.listName;
    }
}



@end
