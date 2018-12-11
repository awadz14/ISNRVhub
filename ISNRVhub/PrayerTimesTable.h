//
//  PrayerTimesTable.h
//  ISNRVhub
//
//  Created by Ahmed Osman on 4/17/14.
//  Copyright (c) 2014 ISNRV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PrayerTimesTable : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *adhanFajr;
@property (weak, nonatomic) IBOutlet UILabel *iqamaFajr;

@property (weak, nonatomic) IBOutlet UILabel *adhanDuhr;
@property (weak, nonatomic) IBOutlet UILabel *iqamaDuhr;

@property (weak, nonatomic) IBOutlet UILabel *adhanAsr;
@property (weak, nonatomic) IBOutlet UILabel *iqamaAsr;

@property (weak, nonatomic) IBOutlet UILabel *adhanMaghrib;
@property (weak, nonatomic) IBOutlet UILabel *iqamaMaghrib;

@property (weak, nonatomic) IBOutlet UILabel *adhanIsha;
@property (weak, nonatomic) IBOutlet UILabel *iqamaIsha;

@end
