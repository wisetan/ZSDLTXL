//
//  GroupSendViewController.m
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-13.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import "GroupSendViewController.h"
#import "ContactCell.h"
#import "Contact.h"
#import "CellButton.h"
#import "CellTapGestureRecognizer.h"
#import "UIImageView+WebCache.h"

@interface GroupSendViewController ()

@end

@implementation GroupSendViewController

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
	
    self.title = @"群发人员";
    NSString *userDataFile = [PersistenceHelper dataForKey:kUserDataFile];
    
    NSLog(@"self.selectContactArray %@", self.selectedContactArray);
    
    self.contactDictSortByAlpha = [NSKeyedUnarchiver unarchiveObjectWithFile:userDataFile];
    self.contactTableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-44-45) style:UITableViewStylePlain] autorelease];
    self.contactTableView.delegate = self;
    self.contactTableView.dataSource = self;
    self.contactTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.contactTableView];
    
    //back button
    self.backBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backBarButton setImage:[UIImage imageNamed:@"retreat.png"] forState:UIControlStateNormal];
    [self.backBarButton addTarget:self action:@selector(popVC:) forControlEvents:UIControlEventTouchUpInside];
    self.backBarButton.frame = CGRectMake(0, 0, 30, 30);
    
    UIBarButtonItem *lBarButton = [[[UIBarButtonItem alloc] initWithCustomView:self.backBarButton] autorelease];
    [self.navigationItem setLeftBarButtonItem:lBarButton];
    
    //bottom image view
	self.bottomImageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bottom_bg.png"]] autorelease];
    self.bottomImageView.frame = CGRectMake(0, self.view.frame.size.height-45-44, 320, 45);
    self.bottomImageView.userInteractionEnabled = YES;
    
    [self.view addSubview:self.bottomImageView];
    
    //login button
    self.confirmSelectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.confirmSelectButton setImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
    [self.confirmSelectButton setImage:[UIImage imageNamed:@"button_p.png"] forState:UIControlStateHighlighted];
    
    self.confirmSelectButton.frame = CGRectMake(110, 5, 100.f, 34);
    UILabel *confirmLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, 100.f, 34.f)] autorelease];
    confirmLabel.backgroundColor = [UIColor clearColor];
    confirmLabel.text = @"确认发送";
    confirmLabel.textColor = [UIColor whiteColor];
    confirmLabel.textAlignment = NSTextAlignmentCenter;
    [self.confirmSelectButton addSubview:confirmLabel];
    [self.confirmSelectButton addTarget:self action:@selector(confirmSelect:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomImageView addSubview:self.confirmSelectButton];
    
}

- (void)popVC:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)confirmSelect:(UIButton *)sender
{
    NSLog(@"select contact: %@", self.selectedContactArray);
    [[NSNotificationCenter defaultCenter] postNotificationName:kSendMessageAddFriendNotification object:self.selectedContactArray];
    [self popVC:nil];
}



#pragma mark - table view datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //    return [self.indexArray count];
    return [[self.contactDictSortByAlpha allKeys] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *indexKey = [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section];
    NSInteger count = [[self.contactDictSortByAlpha objectForKey:indexKey] count];
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 51.f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [[UILocalizedIndexedCollation currentCollation] sectionTitles];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"contactCell";
    ContactCell *cell = (ContactCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ContactCell" owner:self options:nil] objectAtIndex:0];
    }
    NSString *indexKey = [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:indexPath.section];
    Contact *contact = [[self.contactDictSortByAlpha objectForKey:indexKey] objectAtIndex:indexPath.row];
    if ([[self.contactDictSortByAlpha objectForKey:indexKey] count] != 0) {
        cell.nameLabel.text = contact.username;
    }
    
    if ([contact.picturelinkurl isValid]) {
        [[SDImageCache sharedImageCache] queryDiskCacheForKey:contact.picturelinkurl done:^(UIImage *image, SDImageCacheType cacheType) {
            if (image != nil) {
                cell.headIcon.image = image;
            }
            else {
                [cell.headIcon setImageWithURL:[NSURL URLWithString:contact.picturelinkurl] placeholderImage:[UIImage imageNamed:@"AC_talk_icon.png"]];
            }
        }];
        NSLog(@"contact pic url; %@", contact.picturelinkurl);
    }
    
    Contact *findContact = [self containTheContact:contact];
    if (findContact) {
        cell.unSelectedImage.image = [UIImage imageNamed:@"selected.png"];
        if ([self isTheOriginContact:contact]) {
//            NSLog(@"contact.userid %@, contactTmp.userid %@", self.originContact.userid, contact.userid);
            cell.userInteractionEnabled = NO;
        }
    }
    else{
        cell.unSelectedImage.image = [UIImage imageNamed:@"unselected.png"];
    }
    
    
    cell.selectionStyle = UITableViewCellEditingStyleNone;
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSString *indexKey = [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section];
    if ([[self.contactDictSortByAlpha objectForKey:indexKey] count] == 0) {
        return 0.f;
    }
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *indexKey = [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:indexPath.section];
    Contact *contact = [[self.contactDictSortByAlpha objectForKey:indexKey] objectAtIndex:indexPath.row];
    Contact *findContact = [self containTheContact:contact];
    if (findContact) {
        [self.selectedContactArray removeObject:findContact];
    }
    else{
        [self.selectedContactArray addObject:contact];
    }
    [self.contactTableView reloadData];
    
}

#pragma mark - help method

- (Contact *)containTheContact:(Contact *)contactTmp
{
    __block Contact *findContact = nil;
    [self.selectedContactArray enumerateObjectsUsingBlock:^(Contact *contact, NSUInteger idx, BOOL *stop) {

        if (contact.userid.longValue == contactTmp.userid.longValue) {
            NSLog(@"contact.userid %@, contactTmp.userid %@", contact.userid, contactTmp.userid);
            findContact = contact;
            *stop = YES;
        }
    }];
    return findContact;
}

- (BOOL)isTheOriginContact:(Contact *)contactTmp
{
//    NSLog(@"contact.userid %@, contactTmp.userid %@", self.originContact.userid, contactTmp.userid);
    if ([self.originContact.userid isEqualToNumber:contactTmp.userid]) {
        return YES;
    }
    return NO;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [super dealloc];
}

@end
