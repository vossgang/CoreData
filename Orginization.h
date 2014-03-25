//
//  Orginization.h
//  coredata
//
//  Created by Matthew Voss on 3/20/14.
//  Copyright (c) 2014 Matthew Voss. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Orginization : NSManagedObject

@property (nonatomic, retain) NSString * login;
@property (nonatomic, retain) NSSet *repos;
@end

@interface Orginization (CoreDataGeneratedAccessors)

- (void)addReposObject:(NSManagedObject *)value;
- (void)removeReposObject:(NSManagedObject *)value;
- (void)addRepos:(NSSet *)values;
- (void)removeRepos:(NSSet *)values;

@end
