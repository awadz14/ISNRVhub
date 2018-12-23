//
//  ParkingStatus.m
//  ISNRVhub
//
//  Created by Ahmed Osman on 4/26/14.
//  Copyright (c) 2014 ISNRV. All rights reserved.
//

#import "ParkingStatus.h"
#import "SWRevealViewController.h"

@import Firebase;

@interface ParkingStatus (){
    FIRDatabaseHandle _refHandle;
}

@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) NSMutableArray<FIRDataSnapshot *> *parkingStatus;


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
    
    
    // Firebase configuration
    [self getParkingStatus];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)getParkingStatus {
    _ref = [[FIRDatabase database] reference];
    // Listen for status in the Firebase database
    
    _refHandle = [[_ref child:@"parking/Status"] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot) {
        self->parkStatus.text = snapshot.value;
    }];
    
}

- (void)dealloc {
    [[_ref child:@"parking"] removeObserverWithHandle:_refHandle];
}




@end
