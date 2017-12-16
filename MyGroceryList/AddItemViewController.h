//
//  AddItemViewController.h
//  MyGroceryList
//
//  Created by bloqhed on 12/15/17.
//  Copyright © 2017 cvr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface AddItemViewController : UIViewController<UIPickerViewDelegate,UIPickerViewDataSource>
{
    AppDelegate *appDelegate;
    NSManagedObjectContext *context;
}

@property (strong) NSManagedObjectModel *anItem;
@property (strong, nonatomic) NSManagedObjectModel *listName;
@end
