//
//  SelectPreferViewController.m
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-15.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import "SelectPreferViewController.h"
#import "Pharmacology.h"
#import "PreferInfo.h"
#import "PharCell.h"

@interface SelectPreferViewController ()

@end

@implementation SelectPreferViewController

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
    self.preferArray = [[[NSMutableArray alloc] init] autorelease];
    if (!self.selectArray) {
        self.selectArray = [[[NSMutableArray alloc] init] autorelease];
    }
    
    
    self.title = @"类别偏好";
    
    //back button
    self.backBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backBarButton setImage:[UIImage imageNamed:@"retreat.png"] forState:UIControlStateNormal];
    [self.backBarButton addTarget:self action:@selector(backToRootVC:) forControlEvents:UIControlEventTouchUpInside];
    self.backBarButton.frame = CGRectMake(0, 0, 30, 30);
    
    UIBarButtonItem *lBarButton = [[[UIBarButtonItem alloc] initWithCustomView:self.backBarButton] autorelease];
    [self.navigationItem setLeftBarButtonItem:lBarButton];
    
    
    self.preferTableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height-44-45) style:UITableViewStylePlain] autorelease];
    UIImageView *bottomImageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bottom_bg.png"]] autorelease];
    bottomImageView.userInteractionEnabled = YES;
    bottomImageView.frame = CGRectMake(0, self.view.frame.size.height-45-44, 320, 45);
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmButton setImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
    [confirmButton setImage:[UIImage imageNamed:@"button_p.png"] forState:UIControlStateHighlighted];
    confirmButton.frame = CGRectMake(110, 5, 101, 34);
    [confirmButton addTarget:self action:@selector(confirmSelect:) forControlEvents:UIControlEventTouchUpInside];
    [bottomImageView addSubview:confirmButton];
    
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 101, 34)] autorelease];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"确认";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [confirmButton addSubview:label];
    [self.view addSubview:bottomImageView];
    self.preferTableView.delegate = self;
    self.preferTableView.dataSource = self;
    [self.preferTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.preferTableView];
    
    
    
    
    [self getPreferJsonData];
    
    
    
}

- (void)confirmSelect:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kSelectPharFinished object:self.selectArray];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)backToRootVC:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:kSelectPharFinished object:self.selectArray];
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
            Pharmacology *phar = [[Pharmacology alloc] init];
            phar.content = [pharDict objectForKey:@"content"];
            phar.pharId = [[pharDict objectForKey:@"id"] longValue];
            phar.picturelinkurl = [pharDict objectForKey:@"picturelinkurl"];
            phar.col4 = [[pharDict objectForKey:@"col4"] intValue];
            [self.preferArray addObject:phar];
            [phar release];
        }];
        [self.preferTableView reloadData];
        
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
    return [self.preferArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 51.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"prefer array: %@", self.preferArray);
    NSLog(@"select array: %@", self.selectArray);
    static NSString *cellId = @"pharCell";
    PharCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PharCell" owner:self options:nil] objectAtIndex:0];
    }
    cell.nameLabel.text = [[self.preferArray objectAtIndex:indexPath.row] content];

    
    Pharmacology *phar = [self.preferArray objectAtIndex:indexPath.row];
    if ([self haveSelectThePrefer:phar]) {
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
    NSLog(@"prefer array: %@", self.preferArray);
    NSLog(@"select array: %@", self.selectArray);
    Pharmacology *phar = [self.preferArray objectAtIndex:indexPath.row];
    if (self.selectArray.count == 2 && ![self haveSelectThePrefer:phar]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"最多选择两个偏好" message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alert show];
        [alert release];
        return;
    }
    
    __block PreferInfo *selectPhar = nil;
    if ([self haveSelectThePrefer:phar]) {

        [self.selectArray enumerateObjectsUsingBlock:^(PreferInfo *prefer, NSUInteger idx, BOOL *stop) {
            if ([prefer.prefername isEqualToString:phar.content]) {
                selectPhar = prefer;
                *stop = YES;
            }
        }];
        
        [self.selectArray removeObject:selectPhar];
    }
    else{
        PreferInfo *prefer = [[PreferInfo alloc] init];
        prefer.prefername = phar.content;
        prefer.preferId = phar.pharId;
        [self.selectArray addObject:prefer];
        [prefer release];
    }
    [self.preferTableView reloadData];
}

- (BOOL)haveSelectThePrefer:(Pharmacology *)phar
{
    __block BOOL isSelect = NO;
    [self.selectArray enumerateObjectsUsingBlock:^(PreferInfo *prefer, NSUInteger idx, BOOL *stop) {
        if ([prefer.prefername isEqualToString:phar.content]) {
            isSelect = YES;
            *stop = YES;
        }
        
    }];
    return isSelect;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
