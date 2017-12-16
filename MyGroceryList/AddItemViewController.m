//
//  AddItemViewController.m
//  MyGroceryList
//
//  Created by bloqhed on 12/15/17.
//  Copyright © 2017 cvr. All rights reserved.
//

#import "AddItemViewController.h"
#import "Item+CoreDataClass.h"
@interface AddItemViewController (){
    NSString *categoryName;
    NSArray *categoryNameArray;
}
@property (weak, nonatomic) IBOutlet UITextField *itemName;
@property (weak, nonatomic) IBOutlet UITextField *itemCategory;
@property (weak, nonatomic) IBOutlet UILabel *listLabel;
@property (weak, nonatomic) IBOutlet UIButton *saveItem;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;
@end

@implementation AddItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    categoryName = [[NSString alloc]init];
    categoryNameArray = @[@"Berverages",@"Bread/Bakery",@"Canned/Jarred Goods",@"Dairy",@"Dry/Baking Goods", @"Frozen Foods",@"Meat",@"Produce",@"Cleaners",@"Paper Goods",@"Personal Care",@"Other"];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    [self.pickerView reloadAllComponents];
    self.listLabel.text = @"Add New Item";
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    context = appDelegate.persistentContainer.viewContext;
    
    if (self.anItem) {
        self.itemName.text = [self.anItem valueForKey:@"itemName"];
        NSString *category = [self.anItem valueForKey:@"itemCategory"];
        categoryName = category;
        NSInteger row = [self findCategoryIndex: category];
        [self.pickerView viewForRow:row forComponent:1];
        self.listLabel.text = [self.listName valueForKey:@"listName"];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(IBAction)saveRecord: (UIButton *)sender {
   NSLog(@"\n\n%@\n\n",[self.listName valueForKey:@"listName"]);
    if (self.anItem) {
        [self.anItem setValue:self.itemName.text forKey:@"itemName"];
        [self.anItem setValue:[self getCategoryName] forKey:@"itemCategory"];
        [self.anItem setValue:[self.listName valueForKey:@"listName"] forKey:@"listName"];
    }else {
    Item *myItem = [[Item alloc]initWithContext:context];
    [myItem setValue:self.itemName.text forKey:@"itemName"];
    [myItem setValue:[self getCategoryName] forKey:@"itemCategory"];
    [myItem setValue: [self.listName valueForKey:@"listName"] forKey:@"listName"];
    
    NSLog(@"myItem: %@",myItem);
    }
    
    self.itemName.text = @"";
    
    NSError *error = nil;
    if (![context save:&error]){
        NSLog(@"%@ %@",error,[error localizedDescription]);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)dismissKeyboard:(id)sender {
    [self resignFirstResponder];
}
#pragma mark - Picker Data Source Methods

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [categoryNameArray count];
}

#pragma mark - Picker Delegate Methods
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    categoryName = [categoryNameArray objectAtIndex:row];
    return categoryName;
}

-(NSInteger) findCategoryIndex: (NSString *) category{
    for (int i = 0; i < [categoryNameArray count];i++){
        if ([[categoryNameArray objectAtIndex:i] isEqualToString:category]){
            return i;
        }
    }
    //return "other" if something goes wrong
    return ([categoryNameArray count] - 1);
}
-(NSString *)getCategoryName {
    NSInteger row = [self.pickerView selectedRowInComponent:0];
    NSString* cat = [categoryNameArray objectAtIndex:row];
    return cat;
}

@end
