//
//  RootViewController.m
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-8.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import "AllContactViewController.h"
#import "ContactCell.h"
#import "Contact.h"
#import "ProvinceViewController.h"
#import "SendMessageViewController.h"
#import "SendEmailViewController.h"
#import "ChatViewController.h"
#import "UIImageView+WebCache.h"
#import "MyHomePageViewController.h"
#import "MyFriendViewController.h"
#import "LoginViewController.h"


#import "UIImageView+WebCache.h"
#import "CityInfo.h"

#import "AllContact.h"

#import "UIScrollView+SVInfiniteScrolling.h"
#import "OtherHomepageViewController.h"

@interface AllContactViewController ()

@end

@implementation AllContactViewController

- (NSString *)tabImageName
{
    return nil;
}

// Setting the title of the tab.
- (NSString *)tabTitle
{
    return @"全部";
}

//- (void)selectArea:(UIButton *)sender
//{
//    NSLog(@"select area");
//    ProvinceViewController *areaVC = [[ProvinceViewController alloc] init];
//    areaVC.isAddResident = NO;
////    _fetchedResultsController = nil;
////    [NSFetchedResultsController deleteCacheWithName:nil];
////    [self.mTableView reloadData];
//    [self.navigationController pushViewController:areaVC animated:YES];
//    [areaVC release];
//}
//
//- (void)tapOnLocationIcon
//{
//    [self selectArea:nil];
//}


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
    self.title = @"全部";
    self.entityName = @"AllContact";
    self.contactType = eAllContact;
    
}

- (void)viewWillAppear:(BOOL)animated
{
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
    }

    [self.mTableView reloadData];
}

//
- (void)getInvestmentUserListFromServer
{
    [self setProvinceIdAndCityIdOfCity:[PersistenceHelper dataForKey:kCityName]];
    NSLog(@"current city; %@", self.currentCity);
    //parameter: provinceid, cityid, userid(用来取备注),
    NSString *userid = kAppDelegate.userId;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:self.curProvinceId, @"provinceid",
                                                                    self.curCityId, @"cityid",
                                                                    userid, @"userid",
                                                                    @"getInvestmentUserList.json", @"path", nil];
    
    
    NSLog(@"all contact dict %@", dict);

    
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:[kAppDelegate window] animated:YES];
    hub.labelText = @"获取商家列表";
    
    [DreamFactoryClient getWithURLParameters:dict success:^(NSDictionary *json) {
        if ([[[json objForKey:@"returnCode"] stringValue] isEqualToString:@"0"]) {
            
            [[json objectForKey:@"InvestmentUserList"] enumerateObjectsUsingBlock:^(NSDictionary *contactDict, NSUInteger idx, BOOL *stop) {
//                NSLog(@"contact Dict: %@", contactDict);
                
                AllContact *contact = [AllContact MR_createEntity];
                
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
                contact.username_p = makePinYinOfName(contact.username);
                
                
//                NSLog(@"name pinyin %@", contact.username_p);
                
                contact.sectionkey = [NSString stringWithFormat:@"%c", indexTitleOfString([contact.username characterAtIndex:0])];
                
//                NSLog(@"idx %d username %@, sectionkey %@", idx, contact.username, contact.sectionkey);
            }];
            
            [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreAndWait];


            
//            NSError *error = nil;
//            if (![kAppDelegate.managedObjectContext save:&error]) {
//                NSLog(@"save error %@", error);
//            }
            

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

- (void)configureCell:(ContactCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    cell.selectionStyle = UITableViewCellEditingStyleNone;
    
    
    AllContact *userDetail = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
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
    
    otherProfileVC.contact = [self.fetchedResultsController objectAtIndexPath:indexPath];
    otherProfileVC.contactyType = eAllContact;
    [self.navigationController pushViewController:otherProfileVC animated:YES];
    [otherProfileVC release];
}

- (NSFetchedResultsController *)fetchedResultsController
{
//    if (_fetchedResultsController != nil) {
//        return _fetchedResultsController;
//    }
//
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
//                                                           ascending:YES
//                                                            selector:@selector(localizedCaseInsensitiveCompare:)];
//
//    [fetchRequest setSortDescriptors:@[sort1, sort2]];
//
//    NSLog(@"city id %@", [PersistenceHelper dataForKey:kCityId]);
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"cityid == %@", [PersistenceHelper dataForKey:kCityId]];
//    [fetchRequest setPredicate:pred];
//
//    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
//                                                                    managedObjectContext:kAppDelegate.managedObjectContext
//                                                                      sectionNameKeyPath:@"sectionkey"
//                                                                               cacheName:nil];
//
//    _fetchedResultsController.delegate = self;
//
//    return _fetchedResultsController;
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
//    _fetchedResultsController = [AllContact fetchAllGroupedBy:@"sectionkey" withPredicate:nil sortedBy:@"username" ascending:YES delegate:self];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"cityid == %@ AND loginid == %@", [PersistenceHelper dataForKey:kCityId], [kAppDelegate userId]];
    _fetchedResultsController = [AllContact MR_fetchAllGroupedBy:@"sectionkey" withPredicate:pred sortedBy:@"sectionkey,username_p" ascending:YES delegate:self];
    
    
    return _fetchedResultsController;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
