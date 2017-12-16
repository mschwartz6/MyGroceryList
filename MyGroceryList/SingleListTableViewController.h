//
//  SingleListTableViewController.h
//  MyGroceryList
//
//  Created by bloqhed on 12/15/17.
//  Copyright © 2017 cvr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface SingleListTableViewController : UITableViewController
{
    AppDelegate *appDelegate;
    NSManagedObjectContext *context;
}
@property (strong) NSMutableArray *items;
@property (strong, nonatomic) NSManagedObjectModel *listName;
@end
