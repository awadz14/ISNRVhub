//
//  StatusViewController.h
//  ISNRVhub
//
//  Created by Ahmed Osman on 5/4/14.
//  Copyright (c) 2014 ISNRV. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReadWriteParkStatus.h"

@interface StatusViewController : UIViewController <UITextFieldDelegate, UITableViewDataSource>
{
    UITableView *statusTable;
    UIButton *available;
    UIButton *isnrvCarPool;
    UIButton *full;
    ReadWriteParkStatus *statusRW;

    
}

@property(nonatomic, retain) UIButton *available;
@property(nonatomic, retain) UIButton *isnrvCarPool;
@property(nonatomic, retain) UIButton *full;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property(nonatomic, retain) ReadWriteParkStatus *statusRW;


@end
