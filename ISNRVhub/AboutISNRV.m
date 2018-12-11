//
//  AboutISNRV.m
//  ISNRVhub
//
//  Created by Ahmed Osman on 4/20/14.
//  Copyright (c) 2014 ISNRV. All rights reserved.
//

#import "AboutISNRV.h"
#import "SWRevealViewController.h"

@interface AboutISNRV ()

@end

@implementation AboutISNRV

@synthesize aboutWebView;


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
    // Do any additional setup after loading the view.
    NSString *stringURL = @"http://www.isnrv.org/aboutus/index.php";
    NSURL *url = [NSURL URLWithString:stringURL];
    NSURLRequest *requestURL = [NSURLRequest requestWithURL:url];
    [aboutWebView loadRequest:requestURL];
    
    // Change button color
    _sidebarButton.tintColor = [UIColor colorWithWhite:1.60f alpha:1.6f];
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

@end
