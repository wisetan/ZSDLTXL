//
//  LoginViewController.m
//  ZXCXBlyt
//
//  Created by zly on 12-3-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import "RegistViewController.h"
#import "CustomAlertView.h"
#import "UIAlertView+MKBlockAdditions.h"
#import "UserDetail.h"
#import "CityInfo.h"
#import "MyInfo.h"
#import "Pharmacology.h"
#import "AddInfoViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize mTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"登录";
    }
    return self;
}

- (void)registSucceedAction {
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setHidesBottomBarWhenPushed:YES];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registSucceedAction) name:kRegistSucceed object:nil];
    self.view.backgroundColor = bgGreyColor;
    self.mTableView.backgroundColor = bgGreyColor;
    [Utility addShadow:self.navigationController.navigationBar];
    
    
    //back button
    self.backBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backBarButton setImage:[UIImage imageNamed:@"retreat.png"] forState:UIControlStateNormal];
    [self.backBarButton addTarget:self action:@selector(backToRootVC:) forControlEvents:UIControlEventTouchUpInside];
    self.backBarButton.frame = CGRectMake(0, 0, 30, 30);
    
    UIBarButtonItem *lBarButton = [[[UIBarButtonItem alloc] initWithCustomView:self.backBarButton] autorelease];
    [self.navigationItem setLeftBarButtonItem:lBarButton];
    
//    UIBarButtonItem *button2 = [[[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"忘记密码"] style:UIBarButtonItemStyleBordered target:self action:@selector(forgotPasswordAction:)] autorelease];
//    self.navigationController.navigationBar.tintColor = RGBCOLOR(98, 148, 193);
//    self.navigationItem.rightBarButtonItem = button2;
    
    
    
    [self.loginButton setImage:[UIImage imageNamed:@"login"] forState:UIControlStateNormal];
    [self.loginButton setImage:[UIImage imageNamed:@"login_p"] forState:UIControlStateHighlighted];
    [self.loginButton addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *loginLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 132, 46)] autorelease];
    loginLabel.backgroundColor = [UIColor clearColor];
    loginLabel.text = @"登 录";
    loginLabel.textColor = [UIColor whiteColor];
    loginLabel.textAlignment = NSTextAlignmentCenter;
    [self.loginButton addSubview:loginLabel];
    
    [self.registButton setImage:[UIImage imageNamed:@"l_regist"] forState:UIControlStateNormal];
    [self.registButton setImage:[UIImage imageNamed:@"l_regsti_p"] forState:UIControlStateHighlighted];
    [self.registButton addTarget:self action:@selector(registAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *registLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 132, 46)] autorelease];
    registLabel.backgroundColor = [UIColor clearColor];
    registLabel.text = @"注 册";
    registLabel.textColor = [UIColor whiteColor];
    registLabel.textAlignment = NSTextAlignmentCenter;
    [self.registButton addSubview:registLabel];
    
}

- (void)backToRootVC:(UIButton *)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [self setMTableView:nil];
    [self setLoginButton:nil];
    [self setRegistButton:nil];
    [super viewDidUnload];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kRegistSucceed object:nil];
    [mTableView release];
    [_loginButton release];
    [_registButton release];
    [super dealloc];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (void)configureCell:(ELCTextfieldCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        userName = cell.rightTextField;
        cell.leftLabel.text = @"用户名";
        cell.rightTextField.placeholder = @"请输入用户名";
    } 
    
    if (indexPath.row == 1) {
        password = cell.rightTextField;
        cell.leftLabel.text = @"密码";
        cell.rightTextField.placeholder = @"请输入密码";
        cell.rightTextField.secureTextEntry = YES;
    }
    cell.isEditable = YES;
    cell.indexPath = indexPath;
    cell.ELCDelegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *kCellIdentifier = @"ELCCell";
    ELCTextfieldCell *cell = (ELCTextfieldCell *)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (cell == nil) {
        cell = [[[ELCTextfieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier] autorelease];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    
    if (indexPath.row == 0) {
//        [cell.rightTextField becomeFirstResponder];
    }
            
    return cell;
}

- (void)loginAction:(UIButton *)sender {
    
    NSString *name = [userName.text removeSpace];
    if (![name isValid]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"出错了" 
                                                        message:@"请输入有效的用户名" 
                                                       delegate:nil 
                                              cancelButtonTitle:@"知道了" 
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }

    NSString *pwd = [password.text removeSpace];
    if (![pwd isValid]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"出错了" 
                                                        message:@"请输入有效的密码" 
                                                       delegate:nil 
                                              cancelButtonTitle:@"知道了" 
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在登录";
    [userName resignFirstResponder];
    [password resignFirstResponder];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"zslogin.json", @"path",
                                                                    name, @"commusername",
                                                                    pwd, @"passwd",
                                                                    kAppDelegate.uuid, @"uuid", nil];
    
    
    NSLog(@"login dict: %@", dict);
    
    [DreamFactoryClient getWithURLParameters:dict success:^(NSDictionary *json) {
        if ([[[json objForKey:@"returnCode"] stringValue] isEqualToString:@"0"]) {
            
            self.userid = [[json objForKey:@"Userid"] stringValue];
            NSLog(@"my info %@", json);
            [PersistenceHelper setData:self.userid forKey:kUserId];
            
            
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"userDetail.userid == %@", self.userid];
            MyInfo *myInfo = [MyInfo findFirstWithPredicate:pred];
            if (!myInfo) {
                myInfo = [MyInfo createEntity];
            }
            
            if ([[[json objForKey:@"Detail"] stringValue] isEqualToString:@"0"]) {
                //信息未完善 跳到完善信息页面
                [MBProgressHUD hideHUDForView:kAppDelegate.window animated:YES];
                [kAppDelegate showWithCustomAlertViewWithText:@"请完善个人信息" andImageName:nil];
            
 
                UserDetail *userDetail = [UserDetail createEntity];
                userDetail.userid = self.userid;
                myInfo.userDetail = userDetail;
                
                DB_SAVE();
                AddInfoViewController *addInfoVC = [[AddInfoViewController alloc] init];
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:addInfoVC];
                [self presentModalViewController:nav animated:YES];
                [addInfoVC release];
                
                return ;
            }
            
            NSDictionary *getMyInfoDict = [NSDictionary dictionaryWithObjectsAndKeys:@"getMypageDetail.json", @"path", self.userid, @"userid", nil];
            [DreamFactoryClient getWithURLParameters:getMyInfoDict success:^(NSDictionary *myInfoJson) {
                NSLog(@"myinfojson %@", myInfoJson);
                if ([[[myInfoJson objectForKey:@"returnCode"] stringValue] isEqualToString:@"0"]) {
                    myInfo.account = [myInfoJson objForKey:@"Account"];
//                    myInfo.unreadCount = [myInfoJson objForKey:@"UnreadCount"];
//                    myInfo.unreadSMSCount = [myInfoJson objForKey:@"UnreadSMSCount"];
                    
                    
                    NSDictionary *userDetailDict = [myInfoJson objForKey:@"UserDetail"];
                    NSLog(@"user detail dict %@", userDetailDict);

                    
                    UserDetail *userDetail = [UserDetail createEntity];
                    userDetail.autograph = [userDetailDict objForKey:@"autograph"];
                    userDetail.col1 = [userDetailDict objForKey:@"col1"];
                    userDetail.col2 = [userDetailDict objForKey:@"col2"];
                    userDetail.col3 = [userDetailDict objForKey:@"col3"];
                    userDetail.userid = [[userDetailDict objForKey:@"id"] stringValue];
                    userDetail.invagency = [[userDetailDict objForKey:@"invagency"] stringValue];
                    userDetail.mailbox = [userDetailDict objForKey:@"mailbox"];
                    userDetail.picturelinkurl = [userDetailDict objForKey:@"picturelinkurl"];
                    userDetail.remark = [userDetailDict objForKey:@"remark"];
                    userDetail.tel = [userDetailDict objForKey:@"tel"];
                    userDetail.type = [[userDetailDict objForKey:@"type"] stringValue];
                    userDetail.username = [userDetailDict objForKey:@"username"];
                    
                    myInfo.userDetail = userDetail;
                    
                    NSArray *areaList = [myInfoJson objForKey:@"AreaList"];
                    NSMutableSet *areaSet = [[NSMutableSet alloc] init];
                    [areaList enumerateObjectsUsingBlock:^(NSDictionary *cityDict, NSUInteger idx, BOOL *stop) {

                        CityInfo *city = [CityInfo createEntity];
                        [city setValuesForKeysWithDictionary:cityDict];
                        [areaSet addObject:city];
                    }];
                    

                    
                    [myInfo addAreaList:areaSet];
                    NSLog(@"myinfo arealist %@", myInfo.areaList);
                    
                    NSArray *preferList = [myInfoJson objForKey:@"PreferList"];
                    NSMutableSet *preferSet = [[NSMutableSet alloc] init];
                    [preferList enumerateObjectsUsingBlock:^(NSDictionary *prefer, NSUInteger idx, BOOL *stop) {
//                        Pharmacology *phar = [NSEntityDescription insertNewObjectForEntityForName:@"Pharmacology" inManagedObjectContext:kAppDelegate.managedObjectContext];
                        Pharmacology *phar = [Pharmacology createEntity];
                        phar.content = [prefer objForKey:@"prefername"];
                        phar.pharid = [[prefer objForKey:@"id"] stringValue];
                        [preferSet addObject:phar];
                    }];
                    
                    [myInfo addPharList:preferSet];
                    [PersistenceHelper setData:userDetail.userid forKey:KUserName];
                    [PersistenceHelper setData:pwd forKey:KPassWord];
                    
                    DB_SAVE();
                    
                    [self backToRootVC:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:kLoginNotification object:nil];
                }
                
//             [[NSNotificationCenter defaultCenter] postNotificationName:kLoginNotification object:nil];
             
            } failure:^(NSError *myInfoError) {
                NSLog(@"error %@", myInfoError);
            }];
            
            
            
            

        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [kAppDelegate showWithCustomAlertViewWithText:GET_RETURNMESSAGE(json) andImageName:nil];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
    }];
}

- (AFJSONRequestOperation *)getUserDetailOp
{
    NSDictionary *getMyInfoDict = [NSDictionary dictionaryWithObjectsAndKeys:@"getMypageDetail.json", @"path", self.userid, @"userid", nil];
    NSURL *url = [NSURL URLWithString:[self getUrlWithPara:getMyInfoDict]];
    AFJSONRequestOperation *op = [AFJSONRequestOperation JSONRequestOperationWithRequest:[NSMutableURLRequest requestWithURL:url] success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"get User Detai succeed");
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
    }];
    return op;
}

//- (AFJSONRequestOperation *)getFriendInfoOp
//{
////    NSDictionary *paraDict = [NSDictionary dictionaryWithObjectsAndKeys:self.userid, @"userid",
////                              self.provinceid, @"provinceid",
////                              self.cityid, @"cityid",
////                              @"getZsAttentionUserByArea.json", @"path", nil];
////    
////    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[kAppDelegate window] animated:YES];
////    hud.labelText = @"获取好友";
////    [DreamFactoryClient getWithURLParameters:paraDict success:^(NSDictionary *json) {
////        if ([[json objectForKey:@"returnCode"] longValue] == 0) {
////            [MBProgressHUD hideHUDForView:[kAppDelegate window] animated:YES];
////            NSArray *friendArrayJson = [json objectForKey:@"DataList"];
////            NSMutableArray *friendArray = [[NSMutableArray alloc] init];
////            [friendArrayJson enumerateObjectsUsingBlock:^(NSDictionary *contactDict, NSUInteger idx, BOOL *stop) {
////                Contact *contact = [Contact new];
////                contact.userid = [contactDict objectForKey:@"id"];
////                contact.username = [contactDict objForKey:@"username"];
////                contact.tel = [contactDict objForKey:@"tel"];
////                contact.mailbox = [contactDict objectForKey:@"mailbox"];
////                contact.picturelinkurl = [contactDict objectForKey:@"picturelinkurl"];
////                contact.col1 = [contactDict objectForKey:@"col1"];
////                contact.col2 = [contactDict objectForKey:@"col2"];
////                contact.col2 = [contactDict objectForKey:@"col2"];
////                [friendArray addObject:contact];
////                [contact release];
////            }];
////            [self friendListRefreshed:friendArray];
////            [friendArray release];
////        }
////        else{
////            [MBProgressHUD hideHUDForView:[kAppDelegate window] animated:YES];
////            [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
////        }
////    } failure:^(NSError *error) {
////        [MBProgressHUD hideHUDForView:[kAppDelegate window] animated:YES];
////        [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
////    }];
//}

- (NSString *)getUrlWithPara:(NSDictionary *)paraDict
{
    NSMutableString *baseUrl = [NSMutableString stringWithFormat:@"http://www.boracloud.com:9101/BLZTCloud/%@?", [paraDict objectForKey:@"path"]];
    [paraDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSString *paraPair = [NSString stringWithFormat:@"%@=%@&", key, obj];
        [baseUrl appendFormat:@"%@", paraPair];
    }];
    baseUrl = [NSMutableString stringWithString:[baseUrl substringToIndex:baseUrl.length-1]];
    return baseUrl;
}



//- (AFJSONRequestOperation *)getChatRecordOp
//{
//    
//}
//
//- (AFJSONRequestOperation *)getHeadIconOp
//{
//    
//}

- (void)registAction:(UIButton *)sender {
    RegistViewController *regist = [[[RegistViewController alloc] initWithNibName:@"RegistViewController" bundle:nil] autorelease];
    [self.navigationController pushViewController:regist animated:YES];
}

- (IBAction)forgotPasswordAction:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"忘记密码提示"
                                                    message:@"请电话联系客服:010-84641808或登录宝来药通官网(www.baolaitong.com)进行修改"
                                                   delegate:nil 
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"知道了", nil];
    [alert show];
    [alert release];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"确认"]) {
        NSString *text = [((CustomAlertView *)alertView).textField.text removeSpace];
        if ([text isValid]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.labelText = @"正在发送请求";

            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"getPass.json", @"path", text, @"commusername", nil];
            [DreamFactoryClient getWithURLParameters:dict success:^(NSDictionary *json) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                if ([[[json objForKey:@"returnCode"] stringValue] isEqualToString:@"0"]) {
                    [kAppDelegate showWithCustomAlertViewWithText:@"密码激活联接已发送至您的邮箱中，请查收" andImageName:nil];
                }
            } failure:^(NSError *error) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
            }];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"出错了" message:@"您输入的用户名或者宝通号不合法，请重新输入" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
            alert.tag = 200;
            [alert show];
            [alert release];
        }
    }
}

@end
