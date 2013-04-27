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
    NSError *error = nil;

    _fetchedResultsController = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"error %@", error);
    }

    if (self.fetchedResultsController.fetchedObjects.count == 0) {
        [self getInvestmentUserListFromServer];
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
            

            [NSFetchedResultsController deleteCacheWithName:nil];
            [[json objectForKey:@"InvestmentUserList"] enumerateObjectsUsingBlock:^(NSDictionary *contactDict, NSUInteger idx, BOOL *stop) {
                NSLog(@"contact Dict: %@", contactDict);

                AllContact *contact = [NSEntityDescription insertNewObjectForEntityForName:@"AllContact" inManagedObjectContext:kAppDelegate.managedObjectContext];
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
                
                contact.sectionkey = [NSString stringWithFormat:@"%c", indexTitleOfString([contact.username characterAtIndex:0])];
                
//                NSLog(@"idx %d username %@, sectionkey %@", idx, contact.username, contact.sectionkey);
            }];
            
            NSError *error = nil;
            if (![kAppDelegate.managedObjectContext save:&error]) {
                NSLog(@"save error %@", error);
            }
            

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
    
    
    UserDetail *userDetail = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.headIcon.layer.cornerRadius = 4;
    cell.headIcon.layer.masksToBounds = YES;
    [cell.headIcon setImageWithURL:[NSURL URLWithString:userDetail.picturelinkurl] placeholderImage:[UIImage imageByName:@"AC_talk_icon.png"]];
    
    
    cell.nameLabel.text = userDetail.username;
    
    cell.unSelectedImage.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
