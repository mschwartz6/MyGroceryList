//
//  MainTableViewController.m
//  MyGroceryList
//
//  Created by bloqhed on 12/15/17.
//  Copyright © 2017 cvr. All rights reserved.
//

#import "MainTableViewController.h"
#import "SingleListTableViewController.h"
#import "masterTableViewCell.h"
#import "Lists+CoreDataClass.h"
@interface MainTableViewController (){
    NSString *newListName;
    UITextField   *cellTextField;
}

@end

@implementation MainTableViewController

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
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:@"Lists"];
    self.lists = [[context executeFetchRequest:fetchRequest error:nil]mutableCopy];
    
    [self.tableView reloadData];
}

- (IBAction)addNewList:(UIBarButtonItem *)sender {
    Lists *myList = [[Lists alloc]initWithContext:context];
    [self.lists addObject:myList];
    [self.tableView reloadData];
}
-(void)addNewList{
    Lists *myList = [[Lists alloc]initWithContext:context];
    [self.lists addObject:myList];
    [self.tableView reloadData];
}
- (IBAction)cellTextFieldDoneEditing:(UITextField *)sender {
    newListName = [[NSString alloc]initWithString:sender.text];
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    Lists *myList = [self.lists objectAtIndex:path.row];
    [myList setValue:newListName forKey:@"listName"];
    
}
-(IBAction)dismissKeyboard:(id)sender{
    [self resignFirstResponder];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.lists count] == 0){
        return 1;
    }
    return [self.lists count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    masterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"masterTableViewCell" forIndexPath:indexPath];
    if ([self.lists count] > 0)
    {
        NSManagedObjectModel *list = [self.lists objectAtIndex:indexPath.row];
        [cell.listTextField setText:[list valueForKey:@"listName"]];
    }
    
    return cell;
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.lists count] > 1 )
            return YES;
    return NO;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
        
    
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            // Delete the row from the data source
            [context deleteObject:[self.lists objectAtIndex:indexPath.row]];
        }
        
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"%@ %@", error, [error localizedDescription]);
        }
    
    //delete row from memory object
        [self.lists removeObjectAtIndex:indexPath.row];
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
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    NSManagedObjectModel *listName = [self.lists objectAtIndex:path.row];
    
    if ([[segue identifier] isEqualToString:@"editList"]){
        
        SingleListTableViewController *destination = [segue destinationViewController];
        
        destination.listName = listName;
        
    }
}
-(void)unWindSegue:(UIStoryboardSegue *)seg {
    NSError *error = nil;
    if (![context save:&error]){
        NSLog(@"%@ %@",error,[error localizedDescription]);
    }
}

@end
