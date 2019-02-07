//
//  EGBDirectoryViewController.m
//  33_34FileManagerTest
//
//  Created by Eduard Galchenko on 2/6/19.
//  Copyright © 2019 Eduard Galchenko. All rights reserved.
//

#import "EGBDirectoryViewController.h"

@interface EGBDirectoryViewController ()

@property (strong, nonatomic) NSString *path;
@property (strong, nonatomic) NSArray *contents;

@end

@implementation EGBDirectoryViewController

- (id) initWithFolderPath:(NSString*) path {
 
    self = [super initWithStyle:UITableViewStyleGrouped];
    
    if (self) {
       
        self.path = path;
        
        NSError *error = nil;
        
        self.contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.path error:&error];
        
        if (error) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }
    
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.title = [self.path lastPathComponent];
    
    if ([self.navigationController.viewControllers count] > 1) {
        
        UIBarButtonItem *backToRoot = [[UIBarButtonItem alloc] initWithTitle:@"Back To Root"
                                                                        style:UIBarButtonItemStylePlain
                                                                        target:self
                                                                        action:@selector(actionBackToRoot:)];
        
        self.navigationItem.rightBarButtonItem = backToRoot;
    }
}

- (void) viewDidAppear:(BOOL)animated {
 
    [super viewDidAppear:animated];
    
    NSLog(@"");
    NSLog(@"path = %@", self.path);
    NSLog(@"view controllers on stack = %ld", [self.navigationController.viewControllers count]);
    NSLog(@"index on stack = %ld", [self.navigationController.viewControllers indexOfObject:self]);
}

- (void) dealloc {
 
    NSLog(@"controller with path = %@ has been deallocated", self.path);
}

#pragma mark - Button Actions

- (void) actionBackToRoot:(UIBarButtonItem*) sender {

    [self.navigationController popToRootViewControllerAnimated:YES];
}


#pragma mark - Private Methods

- (BOOL) isDirectoryAtIndexPath:(NSIndexPath*) indexPath {
 
    NSString *fileName = [self.contents objectAtIndex:indexPath.row];
    
    NSString *filePath = [self.path stringByAppendingPathComponent:fileName];
    
    BOOL isDirectory = NO;
    
    [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory];
    
    return  isDirectory;
}

#pragma mark - UITableViewDataSourse

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.contents count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    NSString *fileName = [self.contents objectAtIndex:indexPath.row];
    
    cell.textLabel.text = fileName;
    
    if ([self isDirectoryAtIndexPath:indexPath]) {
        
        cell.imageView.image = [UIImage imageNamed:@"folder.png"];
        
    } else {
        
        cell.imageView.image = [UIImage imageNamed:@"file.png"];
    }

    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self isDirectoryAtIndexPath:indexPath]) {
        
        NSString *fileName = [self.contents objectAtIndex:indexPath.row];
        
        NSString *filePath = [self.path stringByAppendingPathComponent:fileName];
        
        EGBDirectoryViewController *viewController = [[EGBDirectoryViewController alloc]
                                                      initWithFolderPath:filePath];
        
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//
//    return 1;
//}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
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
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
