//
//  RegistViewController.m
//  ZXCXBlyt
//
//  Created by zly on 12-3-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RegistViewController.h"
#import "DreamFactoryClient.h"
#import "AddInfoViewController.h"
#import "MyInfo.h"
#import "UserDetail.h"

#define CELL_COLUM  2
#define CELL_ROW    5

@interface RegistViewController ()

@end

@implementation RegistViewController
@synthesize mTableView;
@synthesize leftArray;
@synthesize rightArray;
@synthesize registInfo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"注册";
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(keyboardWillShow:) 
                                                     name:UIKeyboardWillShowNotification 
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(keyboardWillHide:) 
                                                     name:UIKeyboardWillHideNotification 
                                                   object:nil];	
    }
    return self;
}

- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setHidesBottomBarWhenPushed:YES];
    
    ////////////////////init registinfo
    
    self.registInfo = [NSMutableArray arrayWithArray:@[@"",@"",@"",@"",@""]];
    
    
    self.view.backgroundColor = bgGreyColor;
    self.mTableView.backgroundColor = bgGreyColor;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 30, 30);
    [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageByName:@"retreat.png"] forState:UIControlStateNormal];
    UIBarButtonItem *button1 = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
    self.navigationItem.leftBarButtonItem = button1;

    self.leftArray = [NSArray arrayWithObjects:@"手机号", @"密码", @"确认密码",@"真实姓名", @"邮箱", nil];
    self.rightArray = [NSArray arrayWithObjects:@"必填", @"密码不得少于6个字符", @"请再次输入密码", @"必填", @"可选", nil];

    //right item
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 30, 30);
    [button addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageByName:@"icon_confirm"] forState:UIControlStateNormal];
    button1 = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
    self.navigationItem.rightBarButtonItem = button1;
    
    UIView *footView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)] autorelease];
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    submitButton.frame = CGRectMake((320-300)/2.0, 5, 300, 44);
    [submitButton addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    [submitButton setBackgroundImage:[UIImage imageByName:@"regist"] forState:UIControlStateNormal];
    [submitButton setBackgroundImage:[UIImage imageByName:@"regist_p"] forState:UIControlStateDisabled];
    [submitButton setTitle:@"注 册" forState:UIControlStateNormal];
    [footView addSubview:submitButton];
    self.mTableView.tableFooterView = footView;
}

- (void)restoreValidationState {
    alreadyGetValidationCode = NO;
}

- (void)submitAction {

    [self.view endEditing:YES];
    
    NSString *telNum = [self.registInfo objectAtIndex:0];
    if (![telNum isValid] || ![telNum isMobileNumber]) {
        [kAppDelegate showWithCustomAlertViewWithText:@"请输入正确的手机号" andImageName:kErrorIcon];
        return;
    }
    
    NSString *password = [self.registInfo objectAtIndex:1];
    if (![password isValid]) {
        [kAppDelegate showWithCustomAlertViewWithText:@"请输入密码" andImageName:kErrorIcon];
        return;
    } else {
        if ([password length] < 6) {
            [kAppDelegate showWithCustomAlertViewWithText:@"密码不得小于6位" andImageName:kErrorIcon];
            return;
        }
    }

    NSString *rePassword = [self.registInfo objectAtIndex:2];
    if (![rePassword isValid]) {
        [kAppDelegate showWithCustomAlertViewWithText:@"请再次输入密码" andImageName:kErrorIcon];
        return;
    } else {
        if (![rePassword isEqualToString:password]) {
            return;
        }
    }
    
    NSString *realName = [self.registInfo objectAtIndex:3];
    if (![realName isValid]) {
        [kAppDelegate showWithCustomAlertViewWithText:@"请输入用户名" andImageName:kErrorIcon];
        return;
    } else {
        if ([realName length] < 2)
        {
            [kAppDelegate showWithCustomAlertViewWithText:@"用户名不得少于2个字符" andImageName:kErrorIcon];
            return;
        }
        if (![realName isMatchedByRegex:@"\\[u4e00-u9fa5\\]"]) {
            [kAppDelegate showWithCustomAlertViewWithText:@"用户民必须全为汉字" andImageName:kErrorIcon];
            return;
        }
    }
    
    NSString *email = [self.registInfo objectAtIndex:4];
//    if (![email isValid] || ![email isValidEmail]) {
//        [kAppDelegate showWithCustomAlertViewWithText:@"请输入正确的邮件格式" andImageName:kErrorIcon];
//        return;
//    }
    if (![email isValid]) {
        email = @"";
    }
    
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[kAppDelegate window] animated:YES];
    hud.labelText = @"正在提交注册";

    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:telNum, @"tel", password, @"passwd", realName, @"name", email, @"mail", kAppDelegate.uuid, @"uuid", @"addInvestmentUser.json", @"path", nil];
    NSLog(@"regist dict %@", dict);
    
    
    [DreamFactoryClient getWithURLParameters:dict success:^(NSDictionary *json) {
        
        NSLog(@"regist json: %@", json);
        if ([GET_RETURNCODE(json) isEqualToString:@"0"]) {
            [MBProgressHUD hideHUDForView:[kAppDelegate window] animated:YES];
            
            MyInfo *myInfo = [MyInfo createEntity];
            myInfo.account = [NSNumber numberWithInt:10];
            UserDetail *userDetail = [UserDetail createEntity];
            userDetail.userid = [json objForKey:@"Userid"];
            userDetail.username = [self.registInfo objectAtIndex:3];
            userDetail.tel = [self.registInfo objectAtIndex:0];
            userDetail.mailbox = [self.registInfo objectAtIndex:4];
            userDetail.col1 = [NSString stringWithFormat:@"%@@boramail.com", [json objForKey:@"Userid"]];
            myInfo.userDetail = userDetail;
            [PersistenceHelper setData:[json objForKey:@"Userid"] forKey:kUserId];
            [PersistenceHelper setData:[self.registInfo objectAtIndex:2] forKey:KPassWord];
            DB_SAVE();
            
            AddInfoViewController *addInfoVC = [[AddInfoViewController alloc] init];
            addInfoVC.delegate = self;
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:addInfoVC];
            [self presentModalViewController:nav animated:YES];
            [addInfoVC release];
            [nav release];
            
        } else {
            [MBProgressHUD hideHUDForView:[kAppDelegate window] animated:YES];
            [kAppDelegate showWithCustomAlertViewWithText:GET_RETURNMESSAGE(json) andImageName:nil];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:[kAppDelegate window] animated:YES];
        [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
    }];
    

}

- (void)finishAddInfo
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [self setMTableView:nil];
    [super viewDidUnload];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

    return @"基本信息";

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.leftArray count];
}

- (void)configureCell:(ELCTextfieldCell *)cell atIndexPath:(NSIndexPath *)indexPath {

    cell.leftLabel.text = [self.leftArray objectAtIndex:indexPath.row];
    if ((indexPath.row == 1 || indexPath.row == 2)) {
        cell.rightTextField.secureTextEntry = YES;
    } else {
        cell.rightTextField.secureTextEntry = NO;
    }
    
    if (indexPath.row == 0) {
        cell.rightTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    if (indexPath.row == 4) {
        cell.rightTextField.keyboardType = UIKeyboardTypeEmailAddress;
    }
    cell.rightTextField.placeholder = [self.rightArray objectAtIndex:indexPath.row];
    cell.isEditable = YES;
    cell.indexPath = indexPath;
    cell.ELCDelegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSString *text = [registInfo objectAtIndex:indexPath.row];
    cell.rightTextField.text = text;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *kCellIdentifier = @"ELCCell";
    ELCTextfieldCell *cell = (ELCTextfieldCell *)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (cell == nil) {
        cell = [[[ELCTextfieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier] autorelease];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
        
    return cell;
}

-(void)keyboardWillShow:(NSNotification *)note {
    // get keyboard size and loctaion
	CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
        
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    CGFloat keyBoardHeight = keyboardBounds.size.height;
    if (IS_IPHONE_5) {
        self.mTableView.frame = CGRectMake(0, 0, 320, 548 - 44 - keyBoardHeight);
    }
    else{
        self.mTableView.frame = CGRectMake(0, 0, 320, 460 - 44 - keyBoardHeight);
    }
    [UIView commitAnimations];
}

-(void)keyboardWillHide:(NSNotification *)note {
	CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    if (IS_IPHONE_5) {
        self.mTableView.frame = CGRectMake(0, 0, 320, 548-44);
    }
    else{
        self.mTableView.frame = CGRectMake(0, 0, 320, 460-44);
    }
    [UIView commitAnimations];
}

- (void)updateText:(NSString *)text atIndexPath:(NSIndexPath *)indexPath {
//    NSMutableArray *array = [self.registInfo objectAtIndex:indexPath.section];
    [self.registInfo replaceObjectAtIndex:indexPath.row withObject:text];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [registInfo release];
    [mTableView release];
    self.leftArray  = nil;
    self.rightArray = nil;
    [super dealloc];
}
@end
