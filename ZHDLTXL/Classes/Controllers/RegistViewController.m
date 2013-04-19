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
    
    ////////////////////init registinfo
    
    self.registInfo = [NSMutableArray arrayWithCapacity:2];
    NSMutableArray *array0 = [NSMutableArray arrayWithCapacity:4];
    for (int j = 0; j < CELL_ROW; j++) {
        [array0 addObject:@""];
    }
    [self.registInfo addObject:array0];
    NSMutableArray *array1 = [NSMutableArray arrayWithCapacity:2];
    for (int j = 0; j < CELL_COLUM; j++) {
        [array1 addObject:@""];
    }
    [self.registInfo addObject:array1];
    
    ////////////////////init end
    
    
    self.view.backgroundColor = bgGreyColor;
    self.mTableView.backgroundColor = bgGreyColor;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 30, 30);
    [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    button.showsTouchWhenHighlighted = YES;
    [button setImage:[UIImage imageByName:@"retreat.png"] forState:UIControlStateNormal];
    UIBarButtonItem *button1 = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
    self.navigationItem.leftBarButtonItem = button1;

    self.leftArray = [NSArray arrayWithObjects:[NSArray arrayWithObjects:@"手机号", @"密码", @"确认密码",@"真实姓名", @"邮箱", nil], nil];
    self.rightArray = [NSArray arrayWithObjects:[NSArray arrayWithObjects:@"必填", @"密码不得少于6个字符", @"请再次输入密码", @"可选", @"必填", nil], nil];

    //right item
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 30, 30);
    [button addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    button.showsTouchWhenHighlighted = YES;
    [button setImage:[UIImage imageByName:@"icon_confirm"] forState:UIControlStateNormal];
    button1 = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
    self.navigationItem.rightBarButtonItem = button1;
    
    UIView *footView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)] autorelease];
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    submitButton.frame = CGRectMake((320-300)/2.0, 5, 300, 44);
    [submitButton addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    [submitButton setBackgroundImage:[UIImage imageByName:@"submit"] forState:UIControlStateNormal];
    [submitButton setTitle:@"注册提交" forState:UIControlStateNormal];
    [footView addSubview:submitButton];
    self.mTableView.tableFooterView = footView;
}

- (void)restoreValidationState {
    alreadyGetValidationCode = NO;
}

- (void)submitAction {

    
    NSString *telNum = [[self.registInfo objectAtIndex:0] objectAtIndex:0];
    if (![telNum isValid] || ![telNum isMobileNumber]) {
        [kAppDelegate showWithCustomAlertViewWithText:@"请输入正确的手机号" andImageName:kErrorIcon];
        return;
    }
    
    NSString *password = [[self.registInfo objectAtIndex:0] objectAtIndex:1];
    if (![password isValid]) {
        [kAppDelegate showWithCustomAlertViewWithText:@"请输入密码" andImageName:kErrorIcon];
        return;
    } else {
        if ([password length] < 6) {
            [kAppDelegate showWithCustomAlertViewWithText:@"密码不得小于6位" andImageName:kErrorIcon];
            return;
        }
    }

    NSString *rePassword = [[self.registInfo objectAtIndex:0] objectAtIndex:2];
    if (![rePassword isValid]) {
        [kAppDelegate showWithCustomAlertViewWithText:@"请再次输入密码" andImageName:kErrorIcon];
        return;
    } else {
        if (![rePassword isEqualToString:password]) {
            return;
        }
    }
    
    NSString *realName = [[self.registInfo objectAtIndex:0] objectAtIndex:3];
    if (![realName isValid]) {
        [kAppDelegate showWithCustomAlertViewWithText:@"请输入用户名" andImageName:kErrorIcon];
        return;
    } else {
        if ([realName length] < 2) {
            [kAppDelegate showWithCustomAlertViewWithText:@"用户名不得少于2个字符" andImageName:kErrorIcon];
            return;
        }
        if ([Utility isNumberString:realName]) {
            [kAppDelegate showWithCustomAlertViewWithText:@"用户名不能全为数字" andImageName:kErrorIcon];
            return;
        }
    }
    
    NSString *email = [[self.registInfo objectAtIndex:0] objectAtIndex:4];
    if (![email isValid] || ![email isValidEmail]) {
        [kAppDelegate showWithCustomAlertViewWithText:@"请输入正确的邮件格式" andImageName:kErrorIcon];
        return;
    }
    
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[kAppDelegate window] animated:YES];
    hud.labelText = @"正在提交注册";

    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:telNum, @"tel", password, @"passwd", realName, @"name", email, @"mail", kAppDelegate.uuid, @"uuid", @"addInvestmentUser.json", @"path", nil];
    
    
    AddInfoViewController *addInfoVC = [[AddInfoViewController alloc] init];
    addInfoVC.registDict = dict;
    [self.navigationController pushViewController:addInfoVC animated:YES];
    [addInfoVC release];
    [hud hide:YES afterDelay:1];
    

}

- (void)viewDidUnload
{
    [self setMTableView:nil];
    [super viewDidUnload];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.leftArray count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"基本信息";
    } else if (section == 1) {
        return @"验证方式";
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.leftArray objectAtIndex:section] count];
}

- (void)configureCell:(ELCTextfieldCell *)cell atIndexPath:(NSIndexPath *)indexPath {

    cell.leftLabel.text = [[self.leftArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if (indexPath.section == 0 && (indexPath.row == 1 || indexPath.row == 2)) {
        cell.rightTextField.secureTextEntry = YES;
    } else {
        cell.rightTextField.secureTextEntry = NO;
    }
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        cell.rightTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    if (indexPath.section == 0 && indexPath.row == 4) {
        cell.rightTextField.keyboardType = UIKeyboardTypeEmailAddress;
    }
    cell.rightTextField.placeholder = [[self.rightArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.isEditable = YES;
    cell.indexPath = indexPath;
    cell.ELCDelegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSString *text = [[registInfo objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
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
        self.mTableView.frame = CGRectMake(0, 0, 320, 568 - 44 - keyBoardHeight);
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
        self.mTableView.frame = CGRectMake(0, 0, 320, 460 - 44);
    }
    [UIView commitAnimations];
}

- (void)updateText:(NSString *)text atIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *array = [self.registInfo objectAtIndex:indexPath.section];
    [array replaceObjectAtIndex:indexPath.row withObject:text];
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
