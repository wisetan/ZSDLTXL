//
//  FriendContactViewController.m
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-26.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import "FriendContactViewController.h"
#import "ContactCell.h"
#import "FriendContact.h"
#import "OtherHomepageViewController.h"

@interface FriendContactViewController ()

@end

@implementation FriendContactViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSString *)tabImageName
{
    return nil;
}

// Setting the title of the tab.
- (NSString *)tabTitle
{
    return @"好友";
}

- (void)viewDidDisappear:(BOOL)animated
{
    self.alertShow = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    if ([kAppDelegate.userId isEqualToString:@"0"]) {
        if (!self.alertShow) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请先登录" message:nil delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
            [alert show];
            [alert release];
            self.alertShow = YES;
        }
        return;
    }
    
//    NSError *error = nil;
    
//    _fetchedResultsController = nil;
//    if (![self.fetchedResultsController performFetch:&error]) {
//        NSLog(@"error %@", error);
//    }
    
    if (self.fetchedResultsController.fetchedObjects.count == 0) {
        [self getInvestmentUserListFromServer];
    }
    else{
        NSLog(@"count %d", self.fetchedResultsController.fetchedObjects.count);
        [self.mTableView reloadData];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"好友";
    self.entityName = @"FriendContact";
    self.contactType = eFriendContatType;
    
    self.page = 1;
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contextDidSave:) name:NSManagedObjectContextDidSaveNotification object:nil];
    
//    if ([self showLoginAlert]) {
//        return;
//    }
}

//- (void)contextDidSave:(NSNotification*)notification{
//    NSLog(@"contextDidSave Notification fired.");
//    SEL selector = @selector(mergeChangesFromContextDidSaveNotification:);
//    [kAppDelegate.managedObjectContext performSelectorOnMainThread:selector withObject:notification waitUntilDone:NO];
//}

- (void)getInvestmentUserListFromServer
{
    [self setProvinceIdAndCityIdOfCity:[PersistenceHelper dataForKey:kCityName]];
    NSLog(@"current city; %@", self.currentCity);
    //parameter: provinceid, cityid, userid(用来取备注),
    NSString *userid = kAppDelegate.userId;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:self.curProvinceId, @"provinceid",
                          [PersistenceHelper dataForKey:kCityId], @"cityid",
                          userid, @"userid",
                          @"getZsAttentionUserByArea.json", @"path", nil];
    
    
    NSLog(@"all contact dict %@", dict);
    
    
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:[kAppDelegate window] animated:YES];
    hub.labelText = @"获取好友列表";
    
    [DreamFactoryClient getWithURLParameters:dict success:^(NSDictionary *json) {
        if ([[[json objForKey:@"returnCode"] stringValue] isEqualToString:@"0"]) {
            
            NSLog(@"friend json %@", json);
            
            
            [[json objectForKey:@"DataList"] enumerateObjectsUsingBlock:^(NSDictionary *contactDict, NSUInteger idx, BOOL *stop) {
                NSLog(@"contact Dict: %@", contactDict);
                
//                FriendContact *contact = [NSEntityDescription insertNewObjectForEntityForName:@"FriendContact" inManagedObjectContext:kAppDelegate.managedObjectContext];
                
                FriendContact *contact = [FriendContact createEntity];
                contact.userid = [[contactDict objForKey:@"id"] stringValue];
                contact.username = [contactDict objForKey:@"username"];
                contact.tel = [contactDict objForKey:@"tel"];
                contact.mailbox = [contactDict objForKey:@"mailbox"];
                contact.picturelinkurl = [contactDict objForKey:@"picturelinkurl"];
                contact.col1 = [contactDict objForKey:@"col1"];
                contact.col2 = [contactDict objForKey:@"col2"];
                contact.col2 = [contactDict objForKey:@"col2"];
                contact.cityid = [PersistenceHelper dataForKey:kCityId];
                contact.loginid = [kAppDelegate userId];
                contact.type = @"1";
                
                NSLog(@"pinyin %@", makePinYin([contact.username characterAtIndex:0]));
                
//                contact.username_p =
                
                //                contact.city = gpsCity;
                contact.sectionkey = [NSString stringWithFormat:@"%c", indexTitleOfString([contact.username characterAtIndex:0])];
            }];
            
//            NSError *error;
////            if (![kAppDelegate.managedObjectContext save:&error]) {
////                NSLog(@"save error %@", error);
////            }
            
            [hub hide:YES];
        } else {
            [hub hide:YES];
            [kAppDelegate showWithCustomAlertViewWithText:GET_RETURNMESSAGE(json) andImageName:nil];
        }
    } failure:^(NSError *error) {
        [hub hide:YES];
        [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
    }];
}

#pragma mark - table view

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    NSLog(@"self.entity %@", self.entityName);
//    return [[self.fetchedResultsController sections] count];
//}
//
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    id  sectionInfo =
//    [[self.fetchedResultsController sections] objectAtIndex:section];
//    return [sectionInfo numberOfObjects];
    
    NSArray *sections = [self.fetchedResultsController sections];
    int count = [[sections objectAtIndex:section] numberOfObjects];
    if (section == [sections count]) {
        return count+1;
    }
    else{
        return count;
    }
}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 51.f;
//}
//
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return  [[self.fetchedResultsController sectionIndexTitles] objectAtIndex:section];
//}
//
//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
//{
//    return [self.fetchedResultsController sectionIndexTitles];
//}
//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"contactCell";
    ContactCell *cell = (ContactCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ContactCell" owner:self options:nil] objectAtIndex:0];
    }
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    OtherHomepageViewController *otherProfileVC = nil;
//    if (IS_IPHONE_5) {
//        otherProfileVC = [[OtherHomepageViewController alloc] initWithNibName:@"OtherHomepageViewController_ip5" bundle:nil];
//    }
//    else{
//        otherProfileVC = [[OtherHomepageViewController alloc] initWithNibName:@"OtherHomepageViewController" bundle:nil];
//    }
//    
//    //    NSString *indexKey = [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:indexPath.section];
//    //    homeVC.contact = [[self.contactDictSortByAlpha objectForKey:indexKey] objectAtIndex:indexPath.row];
//    
//    otherProfileVC.contactId = [[self.fetchedResultsController objectAtIndexPath:indexPath] userId];
//    [self.navigationController pushViewController:otherProfileVC animated:YES];
//    [otherProfileVC release];
//}

- (void)configureCell:(ContactCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    cell.selectionStyle = UITableViewCellEditingStyleNone;
    
    
    FriendContact *userDetail = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.headIcon.layer.cornerRadius = 4;
    cell.headIcon.layer.masksToBounds = YES;
    [cell.headIcon setImageWithURL:[NSURL URLWithString:userDetail.picturelinkurl] placeholderImage:[UIImage imageByName:@"AC_talk_icon.png"]];
    
    
    cell.nameLabel.text = userDetail.username;
    
    cell.unSelectedImage.hidden = YES;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OtherHomepageViewController *otherProfileVC = nil;
    if (IS_IPHONE_5) {
        otherProfileVC = [[OtherHomepageViewController alloc] initWithNibName:@"OtherHomepageViewController_ip5" bundle:nil];
    }
    else{
        otherProfileVC = [[OtherHomepageViewController alloc] initWithNibName:@"OtherHomepageViewController" bundle:nil];
    }
    
    //    NSString *indexKey = [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:indexPath.section];
    //    homeVC.contact = [[self.contactDictSortByAlpha objectForKey:indexKey] objectAtIndex:indexPath.row];
    
//    otherProfileVC.delegate = self;
    otherProfileVC.contact = [self.fetchedResultsController objectAtIndexPath:indexPath];
//    otherProfileVC.contactyType = eFriendContatType;
    [self.navigationController pushViewController:otherProfileVC animated:YES];
    [otherProfileVC release];
}
//
//#pragma mark - fetch controller
//
//- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
//    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
//    [self.mTableView beginUpdates];
//}
//
//
//- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
//    
//    UITableView *tableView = self.mTableView;
//    
//    switch(type) {
//            
//        case NSFetchedResultsChangeInsert:
//            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
//            break;
//            
//        case NSFetchedResultsChangeDelete:
//            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//            break;
//            
//        case NSFetchedResultsChangeUpdate:
//            [self configureCell:(ContactCell *)[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
//            break;
//            
//        case NSFetchedResultsChangeMove:
//            [tableView deleteRowsAtIndexPaths:[NSArray
//                                               arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//            [tableView insertRowsAtIndexPaths:[NSArray
//                                               arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
//            break;
//    }
//}
//
//
//- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id )sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
//    
//    switch(type) {
//            
//        case NSFetchedResultsChangeInsert:
//            [self.mTableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
//            break;
//            
//        case NSFetchedResultsChangeDelete:
//            [self.mTableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
//            break;
//    }
//}
//
//
//- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
//    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
//    [self.mTableView endUpdates];
//}
//
//#pragma mark - notification
//
//- (void)addObserver
//{
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(investmentUserListRefreshed:)
//                                                 name:kInvestmentUserListRefreshed
//                                               object:nil];
//}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
//    NSLog(@"self.entityname %@", self.entityName);
//    
//    NSEntityDescription *entity = [NSEntityDescription entityForName:self.entityName
//                                              inManagedObjectContext:kAppDelegate.managedObjectContext];
//    
//    NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
//    [fetchRequest setEntity:entity];
//    
//    NSSortDescriptor *sort1 = [NSSortDescriptor sortDescriptorWithKey:@"sectionkey" ascending:YES];
//    
//    NSSortDescriptor *sort2 = [NSSortDescriptor sortDescriptorWithKey:@"username"
//                                                            ascending:YES
//                                                             selector:@selector(localizedCaseInsensitiveCompare:)];
//    
//    [fetchRequest setSortDescriptors:@[sort1, sort2]];
//    
//    NSLog(@"city id %@", [PersistenceHelper dataForKey:kCityId]);
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"cityid == %@ AND type == %@", [PersistenceHelper dataForKey:kCityId], @"1"];
//    [fetchRequest setPredicate:pred];
//    [fetchRequest setFetchBatchSize:50];
//    
//    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
//                                                                    managedObjectContext:kAppDelegate.managedObjectContext
//                                                                      sectionNameKeyPath:@"sectionkey"
//                                                                               cacheName:nil];
//    
//    _fetchedResultsController.delegate = self;
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"cityid == %@ AND loginid == %@ AND type == %@", [PersistenceHelper dataForKey:kCityId], [kAppDelegate userId], @"1"];
    _fetchedResultsController = [FriendContact MR_fetchAllGroupedBy:@"sectionkey" withPredicate:pred sortedBy:@"sectionkey,username_p" ascending:YES delegate:self];
    
    return _fetchedResultsController;
}

#pragma mark - other controller delegate

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
