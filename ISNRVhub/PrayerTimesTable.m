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


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self CreatePlistPath];
    [self ParsePrayerTimes];
    //[self SavePrayerTimeToPlist:plistPath];
    [self LoadPrayerTimeFromPlist:plistPath];

    timeFormatter = [[NSDateFormatter alloc] init];
    timeFormatter.dateFormat = @"hh:mm";
    
    [self updateTime];
    
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
    
}


-(void)ParsePrayerTimes {
    
    // create plist to save data locally
    //[self CreatePlistPath];
    
    // 1
    NSError* error = nil;
    
    NSURL *isnrvUrl = [NSURL URLWithString:@"http://www.isnrv.org/prayerCalendar.php"];
    NSData *isnrvHtmlData = [NSData dataWithContentsOfURL:isnrvUrl options:NSDataReadingUncached error:&error];
    if (error) {
        NSLog(@"error in loading data: %@", [error localizedDescription]);
    } else {
        NSLog(@"Data has loaded successfully.");
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
            
            // 8
            //_times = newISNRV;
            [self.tableView reloadData];
        }
        
        [self SavePrayerTimeToPlist:plistPath];
    }
    
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
    
    NSError *error = nil;
    
    NSData *plistData = [NSPropertyListSerialization dataWithPropertyList:plistDict format:NSPropertyListXMLFormat_v1_0 options:NSPropertyListImmutable error:&error];
    
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
}

-(void)LoadPrayerTimeFromPlist:(NSString*) path
{
    // read property list into memory as an NSData object
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:path];
    NSError *errorDesc = nil;
    NSPropertyListFormat format;
    // convert static property list into dictionary object
    NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization propertyListWithData:plistXML options:NSPropertyListMutableContainersAndLeaves format:&format error:&errorDesc];
    
    if (!temp)
    {
        NSLog(@"Error reading plist: %@, format: %lu at  path: %@", errorDesc, (unsigned long)format,path);
    }else{
        adhanPlist = [NSMutableArray arrayWithArray:[temp objectForKey:@"Adhan"]];
        iqamaPlist = [NSMutableArray arrayWithArray:[temp objectForKey:@"Iqama"]];
        
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
}


- (void)updateTime {
    timestamp = [NSDate date];
    tempTime = [timeFormatter stringFromDate: timestamp];
}


@end
