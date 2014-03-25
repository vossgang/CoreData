//
//  MVMasterViewController.m
//  coredata
//
//  Created by Matthew Voss on 3/18/14.
//  Copyright (c) 2014 Matthew Voss. All rights reserved.
//

#import "MVMasterViewController.h"

#import "MVDetailViewController.h"
#import "GitHubNetworkManager.h"
#import "Repo.h"
#import "User.h"
@interface MVMasterViewController () <gitHubNetworkManagerDelegate, UISearchBarDelegate>

@property (nonatomic, strong) GitHubNetworkManager *githubNetworkManager;

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation MVMasterViewController

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity2 = [NSEntityDescription
                                    entityForName:@"Repo" inManagedObjectContext:context];
    [fetchRequest setEntity:entity2];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    NSString *search = searchBar.text;
    
    for (Repo *seachRepo in fetchedObjects) {
        if ([search isEqualToString:seachRepo.name]) {
            NSLog(@"yeah");
        }
    }
    
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.githubNetworkManager = [GitHubNetworkManager new];
    self.githubNetworkManager.delegate = self;
    [self downloadReposForCurrentUser:@"candyforchris"];
    [self downloadReposForCurrentUser:@"vossgang"];
    [self downloadReposForCurrentUser:@"johnnyclem"];
    [self downloadReposForCurrentUser:@"plenipotentss"];
    [self downloadReposForCurrentUser:@"joewalnes"];

    
// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
//    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
//    self.navigationItem.rightBarButtonItem = addButton;
    UISearchBar *searchbar = [UISearchBar new];
    self.navigationItem.titleView = searchbar;
    searchbar.delegate = self;
    
    self.detailViewController = (MVDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
}


-(void)downloadReposForCurrentUser:(NSString *)userName
{
  
    [self.githubNetworkManager downloadReposForUser:userName];
    
}
     
-(void)insertDownloadedArrayToController:(NSArray *)json
{
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity2 = [NSEntityDescription
                                   entityForName:@"Repo" inManagedObjectContext:context];
    [fetchRequest setEntity:entity2];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    

    
    for (NSDictionary *dictionary in json) {
        bool addRepo = YES;
        for (Repo *currentRepo in fetchedObjects) {
            
            if ([currentRepo.repo_id isEqual:[dictionary objectForKey:@"id"]]) {
                addRepo = NO;
            }
        }
        if (addRepo) {
            NSNull *nothing = [NSNull new];
            Repo *repo = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:self.managedObjectContext];
            repo.name = [dictionary objectForKey:@"name"] ? [dictionary objectForKey:@"name"] : @" ";
            repo.repo_id = [dictionary objectForKey:@"id"] ? [dictionary objectForKey:@"id"] : @"";
            
            if ([dictionary objectForKey:@"description"] == nothing) {
                repo.repo_description = @" ";
            } else {
                repo.repo_description = [dictionary objectForKey:@"description"];
            }
            
            repo.html_url = [dictionary objectForKey:@"html_url"] ? [dictionary objectForKey:@"html_url"] : @" ";
//            [self addUserData:[dictionary objectForKey:@"owner"]
//                             :repo];
            
        }


        [context save:nil];
    }
}

//-(void)addUserData:(NSDictionary *)repoUser
//                  :(Repo *)thisRepo
//{
//    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//    NSEntityDescription *entity2 = [NSEntityDescription entityForName:@"User"
//                                               inManagedObjectContext:context];
//    [fetchRequest setEntity:entity2];
//    NSError *error;
//    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
//    
//    bool addUser = YES;
//    
//    for (User *user in fetchedObjects) {
//        if ([user.user_id isEqual:[repoUser objectForKey:@"id"]]) {
//            addUser = NO;
//        }
//    }
//    if (addUser) {
//        User *user = [NSEntityDescription insertNewObjectForEntityForName:[entity2 name] inManagedObjectContext:self.managedObjectContext];
//        user.user_id = [repoUser objectForKey:@"id"];
//        user.name = [repoUser objectForKey:@"login"];
//        [user addReposObject:thisRepo];
//    }
//    
//}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    
    Repo *repo = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:self.managedObjectContext];
    
    repo.name = @"Matthew Voss";
    
    
    
    // If appropriate, configure the new managed object.
    // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
    
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"%@", error);
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSError *error = nil;
        if (![context save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        }
    }   
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        Repo *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        self.detailViewController.detailItem = object;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Repo *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        [[segue destinationViewController] setDetailItem:object];
    }
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Repo" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
	     // Replace this implementation with code to handle the error appropriately.
	     // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	}
    
    return _fetchedResultsController;
}    

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

/*
// Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed. 
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // In the simplest, most efficient, case, reload the table view.
    [self.tableView reloadData];
}
 */

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Repo *repo = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = repo.name;
    cell.detailTextLabel.text = repo.repo_description;

}

@end
