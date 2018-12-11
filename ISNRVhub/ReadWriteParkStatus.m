//
//  ReadWriteParkStatus.m
//  ISNRVhub
//
//  Created by Ahmed Osman on 5/7/14.
//  Copyright (c) 2014 ISNRV. All rights reserved.
//

#import "ReadWriteParkStatus.h"

@implementation ReadWriteParkStatus

@synthesize dataref = __dataref;
@synthesize status = __status;


-(Firebase *)dataref
{
    if (!__dataref)
    {
        NSString* url = @"https://isnrvhub.firebaseio.com/parking";
        __dataref = [[Firebase alloc] initWithUrl:url];
    }
    
    return __dataref;
}

-(NSString *)getStatus
{
    
    [[self dataref] observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        //NSLog(@"Parking status is: %@", snapshot.value);
        __status = [NSMutableString stringWithFormat:@"%@",snapshot.value];
        
        
    }];
    
    return __status;
}

-(void)setStatus: (NSMutableString *) currentStatus
{
    //[self dataref];
    [[self dataref] setValue:currentStatus withCompletionBlock:^(NSError *error, Firebase* ref) {
        if(error) {
            //NSLog(@"Data could not be saved: %@", error);
        } else {
            //NSLog(@"Data saved successfully.");
        }
    }];
}

@end
