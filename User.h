//
//  User.h
//  coredata
//
//  Created by Matthew Voss on 3/20/14.
//  Copyright (c) 2014 Matthew Voss. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Repo;

@interface User : NSManagedObject

@property (nonatomic, retain) NSSet *repos;
@property (nonatomic, strong) NSNumber *user_id;
@property (nonatomic, strong) NSString *name;


@end

@interface User (CoreDataGeneratedAccessors)

- (void)addReposObject:(Repo *)value;
- (void)removeReposObject:(Repo *)value;
- (void)addRepos:(NSSet *)values;
- (void)removeRepos:(NSSet *)values;

@end
