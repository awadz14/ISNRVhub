//
//  AdminISNRV.m
//  ISNRVhub
//
//  Created by Ahmed Osman on 4/30/14.
//  Copyright (c) 2014 ISNRV. All rights reserved.
//

#import "AdminISNRV.h"
#import "SWRevealViewController.h"
#import "StatusViewController.h"
#import "ReadWriteParkStatus.h"
#import <QuartzCore/QuartzCore.h>

#ifdef __IPHONE_6_0
# define ALIGN_CENTER NSTextAlignmentCenter
#else
# define ALIGN_CENTER UITextAlignmentCenter
#endif

@interface AdminISNRV ()

@end

@implementation AdminISNRV

//@synthesize saveUser;
@synthesize userNameFeild,passWordFeild;
@synthesize login,sidebarButton = _sidebarButton;
@synthesize activityIndicatorView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    mainLoginInfo.backgroundColor = [UIColor clearColor];
    userNameFeild.text = @"";
    passWordFeild.text = @"";
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    validLogin = NO;
    
    // Do any additional setup after loading the view.
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"Masjid Al-Ihsan.jpg"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    
    mainLoginInfo  = [[UITableView alloc] initWithFrame:CGRectMake(25,50, 270,250) style:UITableViewStyleGrouped];
    mainLoginInfo.dataSource = self;
    
    
    [self.view addSubview:mainLoginInfo];
    
    // Change button color
    _sidebarButton.tintColor = [UIColor colorWithWhite:1.60f alpha:1.6f];
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    
    // Activity view
    
    // Do any additional setup after loading the view, typically from a nib.
    CGRect frame = CGRectMake (125, 200, 80, 80);
    
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:frame];
    self.activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    //[self.activityIndicatorView setColor:[UIColor colorWithRed:0.0f/255.0f green:55.0f/255.0f blue:152.0f/255.0f alpha:1.0]];
    [self.activityIndicatorView setColor:[UIColor greenColor]];
    [self.view addSubview:self.activityIndicatorView];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section. return 3 if the save user will be implemented
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    

    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    
    [cell.layer setCornerRadius:7.0f];
    [cell.layer setMasksToBounds:YES];
    [cell.layer setBorderWidth:2.0f];
    
    
    tableView.separatorStyle= UITableViewCellSeparatorStyleSingleLine;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"User Name";
            userNameFeild = [[UITextField alloc] initWithFrame:CGRectMake(115,12, 180, 31)];
            userNameFeild.textAlignment = ALIGN_CENTER;
            userNameFeild.textColor = [UIColor blueColor];
            userNameFeild.clearButtonMode  = UITextFieldViewModeAlways;
            userNameFeild.delegate = self;
            userNameFeild.font = [UIFont fontWithName:@"Helvetica" size:14.0];
            [cell.contentView addSubview:userNameFeild];
            break;
        case 1:
            cell.textLabel.text = @"Password";
            passWordFeild = [[UITextField alloc] initWithFrame:CGRectMake(115,12, 180, 31)];
            passWordFeild.textAlignment = ALIGN_CENTER;
            passWordFeild.textColor = [UIColor blueColor];
            passWordFeild.clearButtonMode = UITextFieldViewModeAlways;
            passWordFeild.secureTextEntry = YES;
            passWordFeild.delegate = self;
            passWordFeild.font = [UIFont fontWithName:@"Helvetica" size:14.0];
            [cell.contentView addSubview:passWordFeild];
            
            break;
       /* case 2:
            cell.textLabel.text = @"Remember User Name";
            saveUser = [[UISwitch alloc] initWithFrame:CGRectMake(216,10, 79, 27)];
            saveUser.on = YES;
            [cell.contentView addSubview:saveUser];
            break;*/
        default:
            break;
    }
    
    
    return cell;
    
}

-(void)loggingIn
{

    //Creating a FirebaseSimpleLogin
    
    NSString* url = @"https://isnrvhub.firebaseio.com/parking";
    Firebase* ref = [[Firebase alloc] initWithUrl:url];
    FirebaseSimpleLogin* authClient = [[FirebaseSimpleLogin alloc] initWithRef:ref];
    
    //Logging Users In - Email / Password Authentication
    
    [authClient loginWithEmail:userNameFeild.text andPassword:passWordFeild.text
           withCompletionBlock:^(NSError* error, FAUser* user) {
               if (error != nil) {
                   // There was an error logging in to this account
                   validLogin = NO;
                   [self showAlertForValidationFailure];

               } else {
                   validLogin = YES;
                   [self performSegueWithIdentifier:@"loginCheck" sender:self];

                   //NSLog(@"And now we are back.");
               }
           }];
    
    [self.activityIndicatorView stopAnimating];

    //return validLogin;
}


 #pragma mark - Navigation

 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
     // Pass the selected object to the new view controller.
     if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] ) {
         SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
 
         swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
 
             UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
             [navController setViewControllers: @[dvc] animated: NO ];
             [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
         };
 
     }      
 }

/*
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    
   // while (validLogin == FALSE) {
        [self loggingIn];
    //}
    
   if (validLogin == FALSE) {
        UIAlertView *alertOut = [[UIAlertView alloc] initWithTitle: @"Invalid Login!" message: @"The email or password you entered is incorrect!" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertOut show];
    }
    
    
    
        return validLogin;
 
}*/

-(void)showAlertForValidationFailure
{
    UIAlertView *alertOut = [[UIAlertView alloc] initWithTitle: @"Invalid Login!" message: @"The email or password you entered is incorrect!" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertOut show];
}

- (IBAction)clickToLogin:(id)sender {
    
    //[activityIndicatorView setHidden:FALSE];
    [activityIndicatorView startAnimating];
    [self loggingIn];
    //[self.activityIndicatorView stopAnimating];


    /*
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if (validLogin == YES) {
            [self.activityIndicatorView stopAnimating];
            [self performSegueWithIdentifier:@"loginCheck" sender:self];
            
            
        }else{
            [self.activityIndicatorView stopAnimating];
            [self showAlertForValidationFailure];
        }
    });*/
     

}


/*- (IBAction)returnToStepOne:(UIStoryboardSegue *)segue {
    NSLog(@"And now we are back.");
    
}*/

@end
