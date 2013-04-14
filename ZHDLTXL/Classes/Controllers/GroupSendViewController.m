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
    self.selectedContactArray = [[NSMutableArray new] autorelease];
    self.contactTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-44-45) style:UITableViewStylePlain];
    self.contactTableView.delegate = self;
    self.contactTableView.dataSource = self;
    [self.view addSubview:self.contactTableView];
    [self.contactTableView release];
    
    //back button
    self.backBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backBarButton setImage:[UIImage imageNamed:@"retreat.png"] forState:UIControlStateNormal];
    [self.backBarButton addTarget:self action:@selector(popVC:) forControlEvents:UIControlEventTouchUpInside];
    self.backBarButton.frame = CGRectMake(0, 0, 30, 30);
    
    UIBarButtonItem *lBarButton = [[UIBarButtonItem alloc] initWithCustomView:self.backBarButton];
    [self.navigationItem setLeftBarButtonItem:lBarButton];
    
    //bottom image view
	self.bottomImageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bottom_bg.png"]] autorelease];
    self.bottomImageView.frame = CGRectMake(0, self.view.frame.size.height-45-44, 320, 45);
    self.bottomImageView.userInteractionEnabled = YES;
    
    [self.view addSubview:self.bottomImageView];
    [self.bottomImageView release];
    
    //login button
    self.confirmSelectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.confirmSelectButton setImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
    [self.confirmSelectButton setImage:[UIImage imageNamed:@"button_p.png"] forState:UIControlStateHighlighted];
    
    self.confirmSelectButton.frame = CGRectMake(110, 5, 100.f, 34);
    UILabel *confirmLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, 100.f, 34.f)];
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
//    CellTapGestureRecognizer *tap = [[CellTapGestureRecognizer alloc] initWithTarget:self action:@selector(selectContact:)];
//    tap.contact = [[self.contactDictSortByAlpha objectForKey:indexKey] objectAtIndex:indexPath.row];
//    tap.indexRow = indexPath.row;
//    tap.indexSection = indexPath.section;
//    cell.unSelectedImage.userInteractionEnabled = YES;
//    [cell.unSelectedImage addGestureRecognizer:tap];
    if ([[self.contactDictSortByAlpha objectForKey:indexKey] count] != 0) {
        cell.nameLabel.text = [[[self.contactDictSortByAlpha objectForKey:indexKey] objectAtIndex:indexPath.row] username];
    }
    
//    Contact *contact = [[self.contactDictSortByAlpha objectForKey:indexPath] objectAtIndex:indexPath.row];
//    if ([[self.selectedContactDict allKeys] containsObject:[NSNumber numberWithLong:contact.userid]]
//        && !cell.unSelectedImage.isSelected) {
//        [[[cell.unSelectedImage subviews] objectAtIndex:0] removeFromSuperview];
//    }
    
    Contact *contact = [[self.contactDictSortByAlpha objectForKey:indexKey] objectAtIndex:indexPath.row];
    if ([self.selectedContactArray containsObject:contact]) {
        cell.unSelectedImage.image = [UIImage imageNamed:@"selected.png"];
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
    if ([self.selectedContactArray containsObject:contact]) {
        [self.selectedContactArray removeObject:contact];
    }
    else{
        [self.selectedContactArray addObject:contact];
    }
    [self.contactTableView reloadData];
    
}

//- (void)selectContact:(CellTapGestureRecognizer *)sender
//{
//    NSNumber *userId = [NSNumber numberWithLong:sender.contact.userid];
//    if ([self.selectedContactDict objectForKey:userId]) {
//        [self.selectedContactDict removeObjectForKey:userId];
//    }
//    else{
//        [self.selectedContactDict setObject:sender.contact forKey:userId];
//    }
//    
//    
//    SelectImageView *selectedImageView = (SelectImageView *)sender.view;
//    
//    BOOL isSelected = [selectedImageView isSelected];
//    if (!isSelected) {
//        UIImageView *selectedImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"selected.png"]];
//        selectedImage.frame = CGRectMake(0, 0, sender.view.frame.size.width, sender.view.frame.size.height);
//        [selectedImageView addSubview:selectedImage];
//    }
//    else{
//        [[[sender.view subviews] objectAtIndex:0] removeFromSuperview];
//    }
//    selectedImageView.isSelected = !isSelected;
//
//}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [super dealloc];
//    self.contactTableView = nil;
//    self.selectedContactArray = nil;
    
}

@end
