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
//    self.selectedContactArray = [[NSMutableArray new] autorelease];
    self.selectedContactDict = [[NSMutableDictionary new] autorelease];
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
    NSLog(@"select contact: %@", self.selectedContactDict);
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
    cell.selectionStyle = UITableViewCellEditingStyleNone;
    //    cell.headIcon.image = [UIImage imageNamed:@"AC_talk_icon.png"];
    
    NSString *indexKey = [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:indexPath.section];
//    NSString *imageUrl = [[[self.contactDictSortByAlpha objectForKey:indexKey] objectAtIndex:indexPath.row] picturelinkurl];
//    
//    
//    [cell.headIcon setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"AC_talk_icon.png"]];
    
    if ([[self.contactDictSortByAlpha objectForKey:indexKey] count] != 0) {
        cell.nameLabel.text = [[[self.contactDictSortByAlpha objectForKey:indexKey] objectAtIndex:indexPath.row] username];
    }
    
    CellTapGestureRecognizer *tap = [[CellTapGestureRecognizer alloc] initWithTarget:self action:@selector(selectContact:)];
    tap.contact = [[self.contactDictSortByAlpha objectForKey:indexKey] objectAtIndex:indexPath.row];
    tap.indexKey = indexKey;
    tap.indexRow = indexPath.row;
    tap.indexRow = indexPath.section;
//    tap.userId = [[[self.contactDictSortByAlpha objectForKey:indexKey] objectAtIndex:indexPath.row] userid];
    cell.unSelectedImage.userInteractionEnabled = YES;
    [cell.unSelectedImage addGestureRecognizer:tap];
    
//    cell.selectButton.indexKey = indexKey;
//    cell.selectButton.indexRow = indexPath.row;
//    [cell.selectButton setImage:[UIImage imageNamed:@"unselected.png"] forState:UIControlStateNormal];
//    [cell.selectButton setImage:nil forState:UIControlStateHighlighted];
//    [cell.selectButton addTarget:self action:@selector(selectContact:) forControlEvents:UIControlEventTouchUpInside];
    
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

- (void)selectContact:(CellTapGestureRecognizer *)sender
{
    NSNumber *userId = [NSNumber numberWithLong:sender.contact.userid];
    if ([self.selectedContactDict objectForKey:userId]) {
        [self.selectedContactDict removeObjectForKey:userId];
    }
    else{
        [self.selectedContactDict setObject:sender.contact forKey:userId];
    }
    
    
    BOOL isSelected = [(SelectImageView *)sender.view isSelected];
    if (!isSelected) {
        UIImageView *selectedImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"selected.png"]];
        selectedImage.frame = CGRectMake(0, 0, sender.view.frame.size.width, sender.view.frame.size.height);
        [(SelectImageView *)sender.view addSubview:selectedImage];
    }
    else{
        [[[sender.view subviews] objectAtIndex:0] removeFromSuperview];
    }
    ((SelectImageView *)sender.view).isSelected = !isSelected;

}



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
