//
//  LoginViewController.m
//  paopao
//
//  Created by TsaoLipeng on 15/1/30.
//  Copyright (c) 2015年 TsaoLipeng. All rights reserved.
//

#import "LoginViewController.h"
#import "InputText.h"
#import "UIView+XD.h"
#import "NormalNavigationBar.h"
#import "HyperlinksButton.h"
#import "Verifier.h"
#import <AVOSCloud/AVOSCloud.h>
#import "SVProgressHUD.h"
#import "SignUpViewController.h"
#import "SMSVerifyViewController.h"
#import "Defines.h"

@interface LoginViewController()<UITextFieldDelegate, NormalNavigationDelegate>

@property (nonatomic, strong) NormalNavigationBar *navigationBar;

@property (nonatomic, weak) UITextField *userText;
@property (nonatomic, weak) UILabel *userTextName;
@property (nonatomic, weak) UITextField *passwordText;
@property (nonatomic, weak) UILabel *passwordTextName;
@property (nonatomic, weak) UIButton *signInBtn;
@property (nonatomic, weak) UILabel *signUpLabel;
@property (nonatomic, assign) BOOL chang;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupInputRectangle];
}

- (void)setupInputRectangle
{
    self.navigationBar = [[NormalNavigationBar alloc] initWithTitle:@"登陆"];
    self.navigationBar.delegate = self;
    [self.view addSubview:self.navigationBar];
    
    CGFloat centerX = self.view.width * 0.5;
    InputText *inputText = [[InputText alloc] init];
    CGFloat userY = 100;
    UITextField *userText = [inputText setupWithIcon:nil textY:userY centerX:centerX point:nil];
    userText.delegate = self;
    self.userText = userText;
    [userText setKeyboardType:UIKeyboardTypeNumberPad];
    [userText setReturnKeyType:UIReturnKeyNext];
    [self.view addSubview:userText];
    
    UILabel *userTextName = [self setupTextName:@"手机号码" frame:userText.frame];
    self.userTextName = userTextName;
    [self.view addSubview:userTextName];
    
    CGFloat passwordY = CGRectGetMaxY(userText.frame) + 30;
    UITextField *passwordText = [inputText setupWithIcon:nil textY:passwordY centerX:centerX point:nil];
    [passwordText setReturnKeyType:UIReturnKeyDone];
    [passwordText setSecureTextEntry:YES];
    passwordText.delegate = self;
    self.passwordText = passwordText;
    [self.view addSubview:passwordText];
    UILabel *passwordTextName = [self setupTextName:@"密码" frame:passwordText.frame];
    self.passwordTextName = passwordTextName;
    [self.view addSubview:passwordTextName];
    
    UIButton *signInBtn = [[UIButton alloc] init];
    signInBtn.width = 200;
    signInBtn.height = 40;
    signInBtn.centerX = self.view.width * 0.5;
    signInBtn.y = CGRectGetMaxY(passwordText.frame) + 30;
    [signInBtn setTitle:@"登录" forState:UIControlStateNormal];
    [signInBtn setBackgroundColor:MAIN_COLOR];
    self.signInBtn = signInBtn;
    [signInBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:signInBtn];
    
    HyperlinksButton *retrievePasswordButton = [[HyperlinksButton alloc] init];
    retrievePasswordButton.width = 120;
    retrievePasswordButton.height = 44;
    retrievePasswordButton.centerX = self.view.width * 0.25;
    retrievePasswordButton.y = CGRectGetMaxY(signInBtn.frame) + 20;
    [retrievePasswordButton setTitle:@"忘记密码 ?" forState:UIControlStateNormal];
    [retrievePasswordButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [retrievePasswordButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [retrievePasswordButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [retrievePasswordButton setUnderLineColor:[UIColor grayColor]];
    [retrievePasswordButton addTarget:self action:@selector(doRetrievePassword) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:retrievePasswordButton];
    
    HyperlinksButton *signUpButton = [[HyperlinksButton alloc] init];
    signUpButton.width = 120;
    signUpButton.height = 44;
    signUpButton.centerX = self.view.width * 0.75;
    signUpButton.y = CGRectGetMaxY(signInBtn.frame) + 20;
    [signUpButton setTitle:@"新用户注册" forState:UIControlStateNormal];
    [signUpButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [signUpButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [signUpButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [signUpButton setUnderLineColor:[UIColor grayColor]];
    [signUpButton addTarget:self action:@selector(doSignUp) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:signUpButton];
}

- (UILabel *)setupTextName:(NSString *)textName frame:(CGRect)frame
{
    UILabel *textNameLabel = [[UILabel alloc] init];
    textNameLabel.text = textName;
    textNameLabel.font = [UIFont systemFontOfSize:16];
    textNameLabel.textColor = [UIColor grayColor];
    textNameLabel.frame = frame;
    return textNameLabel;
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.userText) {
        [self diminishTextName:self.userTextName];
        [self restoreTextName:self.passwordTextName textField:self.passwordText];
    } else if (textField == self.passwordText) {
        [self diminishTextName:self.passwordTextName];
        [self restoreTextName:self.userTextName textField:self.userText];
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.userText) {
        return [self.passwordText becomeFirstResponder];
    } else {
        [self restoreTextName:self.passwordTextName textField:self.passwordText];
        return [self.passwordText resignFirstResponder];
    }
}
- (void)diminishTextName:(UILabel *)label
{
    [UIView animateWithDuration:0.5 animations:^{
        label.transform = CGAffineTransformMakeTranslation(0, -16);
        label.font = [UIFont systemFontOfSize:9];
    }];
}
- (void)restoreTextName:(UILabel *)label textField:(UITextField *)textFieled
{
    [self textFieldTextChange:textFieled];
    if (self.chang) {
        [UIView animateWithDuration:0.5 animations:^{
            label.transform = CGAffineTransformIdentity;
            label.font = [UIFont systemFontOfSize:16];
        }];
    }
}
- (void)textFieldTextChange:(UITextField *)textField
{
    if (textField.text.length != 0) {
        self.chang = NO;
    } else {
        self.chang = YES;
    }
}

- (void)doReturn {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - touchesBegan
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    [self restoreTextName:self.userTextName textField:self.userText];
    [self restoreTextName:self.passwordTextName textField:self.passwordText];
}

- (void)loginBtnClick
{
    if (![Verifier isMobileNumber:_userText.text]) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"手机号码格式有误"
                              message:nil
                              delegate:nil
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil];
        
        [alert show];
    } else if ([_passwordText.text isEqual: @""]){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"密码不能为空"
                              message:nil
                              delegate:nil
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil];
        
        [alert show];
    } else {
        [self AVOSSignIn:self.userText.text password:self.passwordText.text];
    }
}

- (void)AVOSSignIn:(NSString *)username password:(NSString *)password {
    [SVProgressHUD showWithStatus:@"正在登陆"];
    [AVUser logInWithUsernameInBackground:username password:password block:^(AVUser *user, NSError *error) {
        if (user != nil) {
            [SVProgressHUD dismissWithSuccess:@"登陆成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:self];
            [self.navigationController popToRootViewControllerAnimated:YES];
        } else {
            NSInteger errorCode = error.code;
            if (errorCode == 215) {
                [SVProgressHUD dismissWithError:@"您尚未验证手机，现在进行验证" afterDelay:2];
                SMSVerifyViewController *SMSVerifyVC = [[SMSVerifyViewController alloc] init];
                [SMSVerifyVC regetVerifySMS:username];
                [self.navigationController pushViewController:SMSVerifyVC animated:YES];
            }
        }
    }];
}

-(void)doRetrievePassword {
    NSLog(@"找回密码");
}

-(void)doSignUp {
    SignUpViewController *signUpVC = [[SignUpViewController alloc] init];
    [self.navigationController pushViewController:signUpVC animated:YES];
}

@end
