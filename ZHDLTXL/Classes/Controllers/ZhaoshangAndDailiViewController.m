//
//  ZhaoshangAndDailiViewController.m
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-16.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import "ZhaoshangAndDailiViewController.h"
#import "PharCell.h"
#import "SelectViewController.h"

@interface ZhaoshangAndDailiViewController ()

@property (nonatomic, assign) NSInteger zdKind;

@end

@implementation ZhaoshangAndDailiViewController

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
    return @"筛选";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //back button
    self.title = @"招商代理";
//    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"topmargin.png"] forBarMetrics:UIBarMetricsDefault];
    
//    self.backBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.backBarButton setImage:[UIImage imageNamed:@"retreat.png"] forState:UIControlStateNormal];
//    [self.backBarButton addTarget:self action:@selector(backToRootVC:) forControlEvents:UIControlEventTouchUpInside];
//    self.backBarButton.frame = CGRectMake(0, 0, 30, 30);
//    
//    UIBarButtonItem *lBarButton = [[UIBarButtonItem alloc] initWithCustomView:self.backBarButton];
//    [self.navigationItem setLeftBarButtonItem:lBarButton];
//    [lBarButton release];
    
    self.leftArray = [NSArray arrayWithObjects:@"招商", @"代理", nil];
    self.selectArray = [[[NSMutableArray alloc] init] autorelease];
    
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmButton setImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
    [confirmButton setImage:[UIImage imageNamed:@"button_p.png"] forState:UIControlStateHighlighted];
    confirmButton.frame = CGRectMake(0, 0, 75, 34);
    [confirmButton addTarget:self action:@selector(confirmSelect:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 75, 34)] autorelease];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"确认";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [confirmButton addSubview:label];
    
    UIBarButtonItem *rBarButton = [[[UIBarButtonItem alloc] initWithCustomView:confirmButton] autorelease];
    self.navigationItem.rightBarButtonItem = rBarButton;
    
    
}

- (void)confirmSelect:(UIButton *)sender
{

    if (self.selectArray.count == 2) {
        self.zdKind = 3;
    }
    if (self.selectArray.count == 1 && [[self.selectArray objectAtIndex:0] isEqualToString:@"招商"]) {
        self.zdKind = 1;
    }
    if (self.selectArray.count == 1 && [[self.selectArray objectAtIndex:0] isEqualToString:@"代理"]) {
        self.zdKind = 2;
    }
    
    if (self.zdKind == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请选择类型" message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alert show];
        [alert release];
    }
    else{
        SelectViewController *selectVC = [[SelectViewController alloc] init];
        selectVC.zdKind = self.zdKind;
        [self.navigationController pushViewController:selectVC animated:YES];
        [selectVC release];
    }
}

- (void)backToRootVC:(UIButton *)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.leftArray count];
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
    
    NSString *zdStr = [self.leftArray objectAtIndex:indexPath.row];
    cell.nameLabel.text = zdStr;
    
    if ([self.selectArray containsObject:zdStr]) {
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
    
    NSString *zdStr = [self.leftArray objectAtIndex:indexPath.row];
    if (![self.selectArray containsObject:zdStr]) {
        [self.selectArray addObject:zdStr];
    }
    else{
        [self.selectArray removeObject:zdStr];
    }
    [self.selectTableView reloadData];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_selectTableView release];
    [super dealloc];
}
@end
