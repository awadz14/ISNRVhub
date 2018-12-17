//
//  ParkingStatus.m
//  ISNRVhub
//
//  Created by Ahmed Osman on 4/26/14.
//  Copyright (c) 2014 ISNRV. All rights reserved.
//

#import "ParkingStatus.h"
#import "SWRevealViewController.h"


@interface ParkingStatus ()

@end

@implementation ParkingStatus

@synthesize parkStatus;

/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}*/

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getParkingStatus];
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"Masjid Al-Ihsan.jpg"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
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

- (void)getParkingStatus
{
   /* NSString* url = @"https://isnrvhub.firebaseio.com/parking";
    Firebase* dataRef = [[Firebase alloc] initWithUrl:url];
    __block NSString* status = [[NSString alloc] init];
    [dataRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        //NSLog(@"Parking status is: %@", snapshot.value);
        status = [NSString stringWithFormat:@"%@",snapshot.value];
        parkStatus.text = status;


    }];*/
    


}




@end
