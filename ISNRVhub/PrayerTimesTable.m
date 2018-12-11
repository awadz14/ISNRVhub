//
//  PrayerTimesTable.m
//  ISNRVhub
//
//  Created by Ahmed Osman on 4/17/14.
//  Copyright (c) 2014 ISNRV. All rights reserved.
//

#import "PrayerTimesTable.h"
#import "hpple/TFHpple.h"
#import "ISNRV.h"

@interface PrayerTimesTable (){
    
    NSMutableArray *newISNRV;
    NSMutableArray *adhanPlist;
    NSMutableArray *iqamaPlist;
    NSDateFormatter *timeFormatter;
    NSDate *timestamp;
    NSString *tempTime;
    NSString *plistPath;
}

@end



@implementation PrayerTimesTable

@synthesize adhanFajr;
@synthesize iqamaFajr;

@synthesize adhanDuhr;
@synthesize iqamaDuhr;

@synthesize adhanAsr;
@synthesize iqamaAsr;

@synthesize adhanMaghrib;
@synthesize iqamaMaghrib;

@synthesize adhanIsha;
@synthesize iqamaIsha;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)CreatePlistPath
{
    // PrayerTimes.plist code
    /*
     1) Create a list of paths.
     2) Get a path to your documents directory from the list.
     3) Create a full file path.
     4) Check if file exists.
     5) Get a path to your plist created before in bundle directory (by Xcode).
     6) Copy this plist to your documents directory.
     */
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    // get documents path
    NSString *documentsPath = [paths objectAtIndex:0];
    // get the path to our PrayerTimes/plist file
    //path = [documentsPath stringByAppendingPathComponent:@"PrayerTimes.plist"];
    plistPath = [documentsPath stringByAppendingPathComponent:@"PrayerTimes.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // check to see if PrayerList.plist exists in documents
    if (![fileManager fileExistsAtPath:plistPath])
    {
        // if not in documents, get property list from main bundle
        NSString *bundle  = [[NSBundle mainBundle] pathForResource:@"PrayerTimes" ofType:@"plist"];
        [fileManager copyItemAtPath:bundle toPath:plistPath error:&error];
    }
    
    
    //NSLog(@"Inside Create method, path is: %@", path);
    //NSLog(@"Inside Create method, plistPath is: %@", plistPath);

    
    

}


-(void)ParsePrayerTimes {
    // 1
    NSURL *isnrvUrl = [NSURL URLWithString:@"http://www.isnrv.org/prayerCalendar.php"];
    NSData *isnrvHtmlData = [NSData dataWithContentsOfURL:isnrvUrl];
    
    // 2
    TFHpple *isnrvParser = [TFHpple hppleWithHTMLData:isnrvHtmlData];
    
    // 3
    NSString *isnrvXpathQueryString = @"//div[@class='prayer-time']";
    NSArray *isnrvNodes = [isnrvParser searchWithXPathQuery:isnrvXpathQueryString];
    
    // 4
    newISNRV = [[NSMutableArray alloc] initWithCapacity:0];
    for (TFHppleElement *element in isnrvNodes) {
        // 5
        ISNRV *isnrv = [[ISNRV alloc] init];
        [newISNRV addObject:isnrv];
        
        // 6
        isnrv.adhanTime = [[element firstChild] content];
        
        // 7
        //isnrv.adhanTime = [element objectForKey:@"class"];
    }
    
    // 8
    //_times = newISNRV;
    [self.tableView reloadData];
}


-(void)SavePrayerTimeToPlist:(NSString*) path
{
    NSMutableArray *adhans = [[NSMutableArray alloc] init];
    NSMutableArray *iqamas = [[NSMutableArray alloc] init];
    ISNRV *prayerTimes = [[ISNRV alloc] init];
    int j = 0;
    for (int i = 0; i<10; i=i+2) {
        prayerTimes = newISNRV[i];
        adhans[j]= prayerTimes.adhanTime;
        
        prayerTimes = newISNRV[i+1];
        iqamas[j]= prayerTimes.adhanTime;
        
        j++;
    }
    
    
    // create dictionary with values in UITextFields
    NSDictionary *plistDict = [NSDictionary dictionaryWithObjects: [NSArray arrayWithObjects: adhans, iqamas, nil] forKeys:[NSArray arrayWithObjects: @"Adhan", @"Iqama", nil]];
    
    //NSError *error = nil;
    NSString *error = nil;
    // create NSData from dictionary
    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:plistDict format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];
    //NSData *plistData = [NSPropertyListSerialization dataWithPropertyList:plistDict format:NSPropertyListXMLFormat_v1_0 options:NSPropertyListImmutable error:&error];
    
    // check is plistData exists
    if(plistData)
    {
        // write plistData to our Data.plist file
        [plistData writeToFile:path atomically:YES];
    }
    else
    {
        NSLog(@"Error in saveData: %@", error);
        
    }
    
    //NSLog(@"Path is: %@", path);
    
}

-(void)LoadPrayerTimeFromPlist:(NSString*) path
{
    // read property list into memory as an NSData object
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:path];
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    // convert static property list into dictionary object
    NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization propertyListFromData:plistXML mutabilityOption:NSPropertyListMutableContainersAndLeaves format:&format errorDescription:&errorDesc];
    if (!temp)
    {
        NSLog(@"Error reading plist: %@, format: %lu at  path: %@", errorDesc, (unsigned long)format,path);
    }
    
    //adhanPlist = [[NSMutableArray alloc] init];
    //iqamaPlist = [[NSMutableArray alloc] init];
    
    adhanPlist = [NSMutableArray arrayWithArray:[temp objectForKey:@"Adhan"]];
    iqamaPlist = [NSMutableArray arrayWithArray:[temp objectForKey:@"Iqama"]];
    
    NSString *readAdhan = adhanPlist[0];
    NSString *readIqama = iqamaPlist[0];

    
    //NSLog(@"Test adhan is %@ and iqama is %@", readAdhan, readIqama);
    
    adhanFajr.text = adhanPlist[0];
    iqamaFajr.text = iqamaPlist[0];
    
    adhanDuhr.text = adhanPlist[1];
    iqamaDuhr.text = iqamaPlist[1];
    
    adhanAsr.text = adhanPlist[2];
    iqamaAsr.text = iqamaPlist[2];
    
    adhanMaghrib.text = adhanPlist[3];
    iqamaMaghrib.text = iqamaPlist[3];
    
    adhanIsha.text = adhanPlist[4];
    iqamaIsha.text = iqamaPlist[4];

    
    
}




- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self CreatePlistPath];
    
    //NSLog(@"Outside Create method, path is: %@", plistPath);

    
    [self ParsePrayerTimes];
    
    [self SavePrayerTimeToPlist:plistPath];
    
    [self LoadPrayerTimeFromPlist:plistPath];

    
    timeFormatter = [[NSDateFormatter alloc] init];
    timeFormatter.dateFormat = @"hh:mm";
    
    [self updateTime];
                     

    
    /*ISNRV *prayerTime = newISNRV[0];
    adhanFajr.text = prayerTime.adhanTime;
    prayerTime = newISNRV[1];;
    iqamaFajr.text = prayerTime.adhanTime;

    prayerTime = newISNRV[2];
    adhanDuhr.text = prayerTime.adhanTime;
    prayerTime = newISNRV[3];;
    iqamaDuhr.text = prayerTime.adhanTime;
    
    prayerTime = newISNRV[4];
    adhanAsr.text = prayerTime.adhanTime;
    prayerTime = newISNRV[5];;
    iqamaAsr.text = prayerTime.adhanTime;
    
    prayerTime = newISNRV[6];
    adhanMaghrib.text = prayerTime.adhanTime;
    prayerTime = newISNRV[7];;
    iqamaMaghrib.text = prayerTime.adhanTime;
    
    prayerTime = newISNRV[8];
    adhanIsha.text = prayerTime.adhanTime;
    prayerTime = newISNRV[9];;
    iqamaIsha.text = prayerTime.adhanTime;*/
    
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 6;
}



- (void)updateTime {
    
    timestamp = [NSDate date];
    tempTime = [timeFormatter stringFromDate: timestamp];
    //NSLog(@"Current date is %@", timestamp);
    //NSLog(@"Current time is %@", tempTime);
    
    //NSDate* date = [NSDate date];
    //NSCalendar* cal = [NSCalendar currentCalendar];
    //NSInteger dow = [cal ordinalityOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:date];
    //NSLog(@"Current Day Of month %ld", (long)dow);
    
//    if(dow >= 1 && dow <= 10)
//    {
//
//    }else if(dow > 10 && dow <= 20)
//    {
//
//    }else if (dow > 20)
//    {
//
//    }


}



/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
