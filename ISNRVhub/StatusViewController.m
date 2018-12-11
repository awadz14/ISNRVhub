//
//  StatusViewController.m
//  ISNRVhub
//
//  Created by Ahmed Osman on 5/4/14.
//  Copyright (c) 2014 ISNRV. All rights reserved.
//

#import "StatusViewController.h"
#import "SWRevealViewController.h"

@interface StatusViewController ()

@end

@implementation StatusViewController

@synthesize available, isnrvCarPool, full, sidebarButton = _sidebarButton, statusRW = _statusRW;

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
    statusTable.backgroundColor = [UIColor clearColor];
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _statusRW = [[ReadWriteParkStatus alloc] init];

    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"Masjid Al-Ihsan.jpg"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    statusTable  = [[UITableView alloc] initWithFrame:CGRectMake(25,50, 270,250) style:UITableViewStyleGrouped];
    statusTable.dataSource = self;
    [self.view addSubview:statusTable];
    
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 40.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    
    
    tableView.separatorStyle= UITableViewCellSeparatorStyleSingleLine;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Available";
            available =  [UIButton buttonWithType:UIButtonTypeSystem];
            [available addTarget:self
                       action:@selector(click:)
             forControlEvents:UIControlEventTouchDown];
            [available setTitle:@"\u2610" forState:UIControlStateNormal];
            [available setTitle:@"\u2611" forState:UIControlStateHighlighted];
            [available setTitle:@"\u2610" forState:UIControlStateDisabled];
            [available setTitle:@"\u2611" forState:UIControlStateSelected];
            available.frame = CGRectMake(115,12, 180, 25);
            [cell.contentView addSubview:available];
            break;
        case 1:
            cell.textLabel.text = @"ISNRV Car Pool";
             isnrvCarPool =  [UIButton buttonWithType:UIButtonTypeSystem];
             [isnrvCarPool addTarget:self
             action:@selector(click:)
             forControlEvents:UIControlEventTouchDown];
             [isnrvCarPool setTitle:@"\u2610" forState:UIControlStateNormal];
             [isnrvCarPool setTitle:@"\u2611" forState:UIControlStateHighlighted];
             [isnrvCarPool setTitle:@"\u2610" forState:UIControlStateDisabled];
             [isnrvCarPool setTitle:@"\u2611" forState:UIControlStateSelected];
             isnrvCarPool.frame = CGRectMake(115,12, 180, 31);
             [cell.contentView addSubview:isnrvCarPool];
            
            break;
            
        case 2:
            cell.textLabel.text = @"Full";
            full =  [UIButton buttonWithType:UIButtonTypeSystem];
            [full addTarget:self
                             action:@selector(click:)
                   forControlEvents:UIControlEventTouchDown];
            [full setTitle:@"\u2610" forState:UIControlStateNormal];
            [full setTitle:@"\u2611" forState:UIControlStateHighlighted];
            [full setTitle:@"\u2610" forState:UIControlStateDisabled];
            [full setTitle:@"\u2611" forState:UIControlStateSelected];
            full.frame = CGRectMake(115,12, 180, 31);
            [cell.contentView addSubview:full];
        default:
            break;
    }
    
    
    return cell;
    
}

- (IBAction) click:(UIButton*)sender
{
    if (sender == available) {
        available.selected = !available.selected;
        isnrvCarPool.selected = FALSE;
        full.selected = FALSE;
        [_statusRW setStatus:[[NSMutableString alloc] initWithString:@"Available"] ];
        
    }else if (sender == isnrvCarPool)
    {
        isnrvCarPool.selected = !isnrvCarPool.selected;
        available.selected = FALSE;
        full.selected = FALSE;
        [_statusRW setStatus:[[NSMutableString alloc] initWithString:@"ISNRV Carpooling"] ];

    }else if (sender == full)
    {
        full.selected = !full.selected;
        available.selected = FALSE;
        isnrvCarPool.selected = FALSE;
        [_statusRW setStatus:[[NSMutableString alloc] initWithString:@"Full"] ];

        
    }
    
    //[self performSegueWithIdentifier:@"returnToStepOne" sender:self];
    //NSLog(@"we are not back.");


}

/*

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
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
*/

@end
