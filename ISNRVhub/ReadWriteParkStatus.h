//
//  ReadWriteParkStatus.h
//  ISNRVhub
//
//  Created by Ahmed Osman on 5/7/14.
//  Copyright (c) 2014 ISNRV. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Firebase/Firebase.h>

@interface ReadWriteParkStatus : NSObject


@property(nonatomic,readonly) Firebase *dataref;
@property(nonatomic,strong) NSMutableString *status;

-(NSString *)getStatus;

-(void)setStatus: (NSMutableString *) currentStatus;

@end
