//
//  AdminISNRV.h
//  ISNRVhub
//
//  Created by Ahmed Osman on 4/30/14.
//  Copyright (c) 2014 ISNRV. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Firebase/Firebase.h>
#import <FirebaseSimpleLogin/FirebaseSimpleLogin.h>


@interface AdminISNRV : UIViewController<UITextFieldDelegate, UITableViewDataSource>{
    
    
    
    UITableView *mainLoginInfo;
    UITextField *userNameFeild;
    UITextField *passWordFeild;
    UISwitch *saveUser;
    
    BOOL validLogin;
}

@property (nonatomic, retain) UITextField *userNameFeild;
@property (nonatomic, retain) UITextField *passWordFeild;
//@property (nonatomic, retain) UISwitch *saveUser;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UIButton *login;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

- (IBAction)clickToLogin:(id)sender;

@end
