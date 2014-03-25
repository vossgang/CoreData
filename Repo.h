//
//  Repo.h
//  coredata
//
//  Created by Matthew Voss on 3/20/14.
//  Copyright (c) 2014 Matthew Voss. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Orginization;

@interface Repo : NSManagedObject

@property (nonatomic, retain) NSNumber * repo_id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * repo_description;
@property (nonatomic, retain) NSString * html_url;
@property (nonatomic, retain) Orginization *orginization;
@property (nonatomic, retain) NSManagedObject *owner;

@end
