//
//  SelectPreferViewController.m
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-15.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import "SelectPharViewController.h"
#import "Pharmacology.h"
#import "PreferInfo.h"
#import "PharCell.h"

@interface SelectPharViewController ()

@end

@implementation SelectPharViewController

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
    self.hidesBottomBarWhenPushed = YES;
    
    self.title = @"类别偏好";
    
    //back button
    self.backBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backBarButton setImage:[UIImage imageNamed:@"retreat.png"] forState:UIControlStateNormal];
    [self.backBarButton addTarget:self action:@selector(backToRootVC:) forControlEvents:UIControlEventTouchUpInside];
    self.backBarButton.frame = CGRectMake(0, 0, 30, 30);
    
    UIBarButtonItem *lBarButton = [[[UIBarButtonItem alloc] initWithCustomView:self.backBarButton] autorelease];
    [self.navigationItem setLeftBarButtonItem:lBarButton];
    
    
    self.preferTableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height-44) style:UITableViewStylePlain] autorelease];
//    UIImageView *bottomImageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bottom_bg.png"]] autorelease];
//    bottomImageView.userInteractionEnabled = YES;
//    bottomImageView.frame = CGRectMake(0, self.view.frame.size.height-45-44, 320, 45);
//    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [confirmButton setImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
//    [confirmButton setImage:[UIImage imageNamed:@"button_p.png"] forState:UIControlStateHighlighted];
//    confirmButton.frame = CGRectMake(110, 5, 101, 34);
//    [confirmButton addTarget:self action:@selector(confirmSelect:) forControlEvents:UIControlEventTouchUpInside];
//    [bottomImageView addSubview:confirmButton];
//    
//    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 101, 34)] autorelease];
//    label.backgroundColor = [UIColor clearColor];
//    label.text = @"确认";
//    label.textColor = [UIColor whiteColor];
//    label.textAlignment = NSTextAlignmentCenter;
//    [confirmButton addSubview:label];
//    [self.view addSubview:bottomImageView];
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmButton setImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
    [confirmButton setImage:[UIImage imageNamed:@"button_p.png"] forState:UIControlStateHighlighted];
    confirmButton.frame = CGRectMake(0, 0, 80, 34);
    [confirmButton addTarget:self action:@selector(confirmSelect:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 34)] autorelease];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"确认";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [confirmButton addSubview:label];
    
    UIBarButtonItem *rBarButton = [[[UIBarButtonItem alloc] initWithCustomView:confirmButton] autorelease];
    self.navigationItem.rightBarButtonItem = rBarButton;
    
    [self getUserinfoFromDB];
    [self getPreferJsonData];
    
    self.preferTableView.delegate = self;
    self.preferTableView.dataSource = self;
    [self.preferTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.preferTableView];
    
    self.theNewPharSet = [NSMutableSet setWithSet:self.myInfo.pharList];
    

}

- (void)getUserinfoFromDB
{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"userDetail.userid == %@", kAppDelegate.userId];
    self.myInfo = [MyInfo findFirstWithPredicate:pred];
}

- (void)confirmSelect:(UIButton *)sender
{
//    [[NSNotificationCenter defaultCenter] postNotificationName:kSelectPharFinished object:self.selectArray];
//    [self.navigationController popViewControllerAnimated:YES];
    
    //上传数据
    //para: changezsarea.json provcityid userid
    NSString *userid = [kAppDelegate userId];
    NSMutableString *preferid = [[NSMutableString alloc] init];
    [self.myInfo.pharList enumerateObjectsUsingBlock:^(Pharmacology *phar, BOOL *stop) {
        [preferid appendFormat:@"%@,", phar.pharid];
    }];
    
    
    if (![preferid isValid]) {
        preferid = [NSMutableString stringWithString:@"1"];
    }
    else{
        preferid = (NSMutableString *)[preferid substringToIndex:[preferid length]-1];
    }


    NSDictionary *paraDict = [NSDictionary dictionaryWithObjectsAndKeys:preferid, @"preferid", userid, @"userid", @"changeprefer.json", @"path", nil];

//    NSLog(@"para dict %@", paraDict);

    [MBProgressHUD showHUDAddedTo:[kAppDelegate window] animated:YES];
    [DreamFactoryClient getWithURLParameters:paraDict success:^(NSDictionary *json) {
        NSLog(@"add resident %@", json);
        if ([[[json objForKey:@"returnCode"] stringValue] isEqualToString:@"0"]) {
            [MBProgressHUD hideAllHUDsForView:[kAppDelegate window] animated:YES];
            NSLog(@"myinfo %@", self.myInfo);
            DB_SAVE();
            if ([self.delegate respondsToSelector:@selector(finishSelectPhar:)]) {
                [self.delegate performSelector:@selector(finishSelectPhar:) withObject:self.myInfo.pharList];
            }
            
            [self.navigationController popViewControllerAnimated:YES];

        }
        else{
            [MBProgressHUD hideAllHUDsForView:[kAppDelegate window] animated:YES];
            [kAppDelegate showWithCustomAlertViewWithText:GET_RETURNMESSAGE(json) andImageName:nil];
        }


    } failure:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:[kAppDelegate window] animated:YES];
        [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
    }];
}

- (void)backToRootVC:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
//    [[NSNotificationCenter defaultCenter] postNotificationName:kSelectPharFinished object:self.selectArray];
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
            Pharmacology *phar = [Pharmacology createEntity];
            phar.content = [pharDict objForKey:@"content"];
            phar.pharid = [[pharDict objForKey:@"id"] stringValue];
            phar.picturelinkurl = [pharDict objForKey:@"picturelinkurl"];
            phar.col4 = [[pharDict objForKey:@"col4"] stringValue];
            [self.preferArray addObject:phar];
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
//    NSLog(@"prefer array: %@", self.preferArray);
//    NSLog(@"select array: %@", self.selectArray);
    Pharmacology *phar = [self.preferArray objectAtIndex:indexPath.row];
    if (self.myInfo.pharList.count == 2 && ![self haveSelectThePrefer:phar]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"最多选择两个偏好" message:nil delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    

    if ([self haveSelectThePrefer:phar]) {

        __block Pharmacology *phar2delete = nil;
        [self.myInfo.pharList enumerateObjectsUsingBlock:^(Pharmacology *pharTmp, BOOL *stop) {
            if ([pharTmp.pharid isEqualToString:phar.pharid]) {
                phar2delete = pharTmp;
            }
        }];
        
        if (phar2delete) {
            [self.myInfo removePharListObject:phar2delete];
        }
        NSLog(@"self.theNewPharSet.count = %d", self.theNewPharSet.count);
    }
    else{
        [self.myInfo addPharListObject:phar];
    }
    [self.preferTableView reloadData];
}

- (BOOL)haveSelectThePrefer:(Pharmacology *)phar
{
    __block BOOL isSelect = NO;
    [self.myInfo.pharList enumerateObjectsUsingBlock:^(Pharmacology *pharTmp, BOOL *stop) {
        if ([pharTmp.pharid isEqualToString:phar.pharid]) {
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
