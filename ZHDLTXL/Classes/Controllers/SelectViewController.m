//
//  SelectViewController.m
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-16.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import "SelectViewController.h"
#import "PharCell.h"
#import "Pharmacology.h"
#import "SelectedUserViewController.h"
#import "Contact.h"


@interface SelectViewController ()

@property (nonatomic, retain) NSMutableArray *contactArray;
@property (nonatomic, retain) NSMutableDictionary *contactDictSortByAlpha;
@property (nonatomic, assign) BOOL isSelectAll;

@end

@implementation SelectViewController
@synthesize fetchedResultsController = _fetchedResultsController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"筛选";
    self.fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Pharmacology"];
    
    self.cateArray = [[[NSMutableArray alloc] init] autorelease];
    self.selectArray = [[[NSMutableArray alloc] init] autorelease];
    
    self.contactArray = [[[NSMutableArray alloc] init] autorelease];
    self.contactDictSortByAlpha = [[[NSMutableDictionary alloc] init] autorelease];
    self.isSelectAll = NO;
    
    //back button
    self.backBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backBarButton setImage:[UIImage imageNamed:@"retreat.png"] forState:UIControlStateNormal];
    [self.backBarButton addTarget:self action:@selector(backToRootVC:) forControlEvents:UIControlEventTouchUpInside];
    self.backBarButton.frame = CGRectMake(0, 0, 30, 30);
    
    UIBarButtonItem *lBarButton = [[[UIBarButtonItem alloc] initWithCustomView:self.backBarButton] autorelease];
    [self.navigationItem setLeftBarButtonItem:lBarButton];
    
    //right bar button
    UILabel *selectAllLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 55, 30)] autorelease];
    selectAllLabel.text = @"全选";
    selectAllLabel.textAlignment = NSTextAlignmentCenter;
    selectAllLabel.textColor = [UIColor whiteColor];
    selectAllLabel.backgroundColor = [UIColor clearColor];
    
    
    self.rightBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rightBarButton setImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
    [self.rightBarButton setImage:[UIImage imageNamed:@"button_p.png"] forState:UIControlStateHighlighted];
    [self.rightBarButton addTarget:self action:@selector(selectAllCate:) forControlEvents:UIControlEventTouchUpInside];
    self.rightBarButton.frame = CGRectMake(0, 0, 55, 30);
    [self.rightBarButton addSubview:selectAllLabel];
    
    UIBarButtonItem *rBarButton = [[[UIBarButtonItem alloc] initWithCustomView:self.rightBarButton] autorelease];
    [self.navigationItem setRightBarButtonItem:rBarButton];
    
    
    self.selectTableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height-45-44) style:UITableViewStylePlain] autorelease];
    self.selectTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.selectTableView.dataSource = self;
    self.selectTableView.delegate = self;
    [self.view addSubview:self.selectTableView];
    
    UIImageView *bottomImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-45-44, 320, 45)];
    bottomImage.image = [UIImage imageNamed:@"bottom_bg.png"];
    bottomImage.userInteractionEnabled = YES;
    [self.view addSubview:bottomImage];
    
    self.confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.confirmButton.frame = CGRectMake(110, 5, 100, 35);
    [self.confirmButton setImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
    [bottomImage addSubview:self.confirmButton];
    [self.confirmButton addTarget:self action:@selector(confirmSelect:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *confirmLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 35)];
    confirmLabel.backgroundColor = [UIColor clearColor];
    confirmLabel.text = @"确认选择";
    confirmLabel.textAlignment = NSTextAlignmentCenter;
    confirmLabel.textColor = [UIColor whiteColor];
    [self.confirmButton addSubview:confirmLabel];
    
    [self getPharFromDB];
}

- (void)getPharFromDB
{
    NSError *error;
    self.cateArray = [NSMutableArray arrayWithArray:[self.managedObjectContext executeFetchRequest:self.fetchRequest error:&error]];
    if (self.cateArray.count == 0) {
        [self getPreferJsonData];
    }
}

- (void)confirmSelect:(UIButton *)sender
{
    if (self.selectArray.count == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请选择类型" message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        
        [alert show];
        [alert release];
    }
    else{
        //para dict: getZsUserByprefer.json userid provinceid cityid invagency preferid
        NSString *provinceId = [PersistenceHelper dataForKey:kProvinceId];
        NSString *cityId = [PersistenceHelper dataForKey:kCityId];
        
        NSString *userid = [kAppDelegate userId];
        NSMutableString *preferid = [[NSMutableString alloc] init];
        [self.selectArray enumerateObjectsUsingBlock:^(Pharmacology *phar, NSUInteger idx, BOOL *stop) {
            [preferid appendFormat:@"%@、", phar.pharid];
        }];
        
        preferid = [NSMutableString stringWithString:[preferid substringToIndex:[preferid length]-1]];
        NSNumber *preferidInt = [NSNumber numberWithInt:[preferid intValue]];
//        NSLog(@"preferid: %@", preferid);
        
        NSNumber *zdKind = [NSNumber numberWithInt:self.zdKind];
        
        NSDictionary *paraDict = [NSDictionary dictionaryWithObjectsAndKeys:provinceId, @"provinceid",
                                                                            cityId, @"cityid",
                                                                            userid, @"userid",
                                                                            zdKind, @"invagency",
                                                                            preferidInt, @"preferid",
                                                                            @"getZsUserByprefer.json", @"path", nil];
//        NSLog(@"select user dict: %@", paraDict);
        [MBProgressHUD showHUDAddedTo:[kAppDelegate window] animated:YES];
        [DreamFactoryClient getWithURLParameters:paraDict success:^(NSDictionary *json) {
            if ([[json objectForKey:@"returnCode"] longValue] == 0) {
                
                NSLog(@"json data: %@", json);
                
                [MBProgressHUD hideAllHUDsForView:[kAppDelegate window] animated:YES];
                NSArray *friendArrayJson = [json objectForKey:@"DataList"];
                NSMutableArray *friendArray = [[NSMutableArray alloc] init];
                [friendArrayJson enumerateObjectsUsingBlock:^(NSDictionary *contactDict, NSUInteger idx, BOOL *stop) {
                    Contact *contact = [Contact new];
                    contact.userid = [contactDict objectForKey:@"id"];
                    contact.username = [contactDict objForKey:@"username"];
                    contact.tel = [contactDict objForKey:@"tel"];
                    contact.mailbox = [contactDict objForKey:@"mailbox"];
                    contact.picturelinkurl = [contactDict objForKey:@"picturelinkurl"];
                    contact.col1 = [contactDict objForKey:@"col1"];
                    contact.col2 = [contactDict objForKey:@"col2"];
                    contact.col2 = [contactDict objForKey:@"col2"];
                    [friendArray addObject:contact];
                    [contact release];
                }];
                [self friendListRefreshed:friendArray];
                [friendArray release];
                
                SelectedUserViewController *selectedVC = [[SelectedUserViewController alloc] init];
                selectedVC.contactDictSortByAlpha = self.contactDictSortByAlpha;
                [self.navigationController pushViewController:selectedVC animated:YES];
                [selectedVC release];
            }
            else{
                [MBProgressHUD hideAllHUDsForView:[kAppDelegate window] animated:YES];
                [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
            }
            
            
        } failure:^(NSError *error) {
            [MBProgressHUD hideAllHUDsForView:[kAppDelegate window] animated:YES];
            [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
        }];
        
        
    }
}

- (void)friendListRefreshed:(NSArray *)friendArray
{
    NSLog(@"friend array: %@", friendArray);
    NSLog(@"self.contactArray: %@", self.contactArray);
    [self.contactArray removeAllObjects];
    [self.contactArray addObjectsFromArray:friendArray];
    [self.contactDictSortByAlpha removeAllObjects];
    //按字母分组
    UILocalizedIndexedCollation *theCollation = [UILocalizedIndexedCollation currentCollation];
    for (NSString *indexKey in [theCollation sectionTitles]) {
        NSMutableArray *contactArrayTmp = [[NSMutableArray alloc] init];
        [self.contactDictSortByAlpha setObject:contactArrayTmp forKey:indexKey];
        [contactArrayTmp release];
    }
    
    [self.contactArray enumerateObjectsUsingBlock:^(Contact *contact, NSUInteger idx, BOOL *stop) {
        NSString *indexKey = [NSString stringWithFormat:@"%c", indexTitleOfString([contact.username characterAtIndex:0])];
        [[self.contactDictSortByAlpha objectForKey:indexKey] addObject:contact];
    }];
    NSLog(@"reach here");
}


- (void)backToRootVC:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)selectAllCate:(UIButton *)sender
{
    if (!self.isSelectAll) {
        [self.selectArray removeAllObjects];
        [self.selectArray addObjectsFromArray:self.cateArray];
    }
    else{
        [self.selectArray removeAllObjects];
    }
    self.isSelectAll = !self.isSelectAll;
    [self.selectTableView reloadData];
    
}
                       

- (void)getPreferJsonData
{
    //getPharmacologyClassify.json
    
    
    NSDictionary *paraDict = [NSDictionary dictionaryWithObjectsAndKeys:@"getPharmacologyClassify.json", @"path", nil];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[kAppDelegate window] animated:YES];
    hud.labelText = @"获取药品类别";
    [DreamFactoryClient getWithURLParameters:paraDict success:^(NSDictionary *json) {
        [MBProgressHUD hideHUDForView:[kAppDelegate window] animated:YES];
        NSArray *pharArray = [json objectForKey:@"PharmacologyList"];
        [pharArray enumerateObjectsUsingBlock:^(NSDictionary *pharDict, NSUInteger idx, BOOL *stop) {
            Pharmacology *phar = [NSEntityDescription insertNewObjectForEntityForName:@"Pharmacology" inManagedObjectContext:self.managedObjectContext];
            phar.content = [pharDict objForKey:@"content"];
            phar.pharid = [[pharDict objForKey:@"id"] stringValue];
            phar.picturelinkurl = [pharDict objForKey:@"picturelinkurl"];
            phar.col4 = [[pharDict objForKey:@"col4"] stringValue];
            [self.cateArray addObject:phar];
            NSError *error;
            if (![self.managedObjectContext save:&error]) {
                NSLog(@"error %@", [error localizedDescription]);
            }
        }];
        [self.selectTableView reloadData];
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:[kAppDelegate window] animated:YES];
        [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
    }];
}

#pragma mark - table view datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.cateArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 51.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"pharCell";
    PharCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PharCell" owner:self options:nil] objectAtIndex:0];
    }
    cell.nameLabel.text = [[self.cateArray objectAtIndex:indexPath.row] content];
    
    
    Pharmacology *phar = [self.cateArray objectAtIndex:indexPath.row];
    if ([self.selectArray containsObject:phar]) {
        cell.selectImage.image = [UIImage imageNamed:@"selected.png"];
    }
    else{
        cell.selectImage.image = [UIImage imageNamed:@"unselected.png"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"select array: %@", self.selectArray);
    
    Pharmacology *phar = [self.cateArray objectAtIndex:indexPath.row];
    if (![self.selectArray containsObject:phar]) {
        [self.selectArray addObject:phar];
    }
    else{
        [self.selectArray removeObject:phar];
    }
    [self.selectTableView reloadData];
}


- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _fetchedResultsController;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_selectTableView release];
    [_confirmButton release];
    [super dealloc];
}
@end
