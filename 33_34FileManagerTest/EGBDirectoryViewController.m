//
//  EGBDirectoryViewController.m
//  33_34FileManagerTest
//
//  Created by Eduard Galchenko on 2/6/19.
//  Copyright © 2019 Eduard Galchenko. All rights reserved.
//

#import "EGBDirectoryViewController.h"
#import "EGBFileCell.h"
#import "UIView+UITableViewCell.h"

@interface EGBDirectoryViewController ()

@property (strong, nonatomic) NSArray *contents;
@property (strong, nonatomic) NSString *selectedPath;

@end

@implementation EGBDirectoryViewController

- (id) initWithFolderPath:(NSString*) path {
 
    self = [super initWithStyle:UITableViewStyleGrouped];
    
    if (self) {
       
        self.path = path;
        
//        NSError *error = nil;
//        
//        self.contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.path error:&error];
//        
//        if (error) {
//            NSLog(@"%@", [error localizedDescription]);
//        }
    }
    
    return self;
}

- (void) setPath:(NSString *)path {
    
    _path = path;
    
    NSError *error = nil;
    
    self.contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.path error:&error];
    
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
    
    [self.tableView reloadData];
    
    self.navigationItem.title = [self.path lastPathComponent];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    if (!self.path) {
        
        self.path = @"/Users/eddie/Documents/IOSDevCourse";
    }
}

- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
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

- (IBAction)actionInfoCell:(id)sender {
    
    UITableViewCell *cell = [sender superCell];
    
    if (cell) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        
//       [[[UIAlertView alloc] initWithTitle:@"Yahho" message:[NSString stringWithFormat:@"action %ld %ld", indexPath.section, indexPath.row] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Yahoo" message:[NSString stringWithFormat:@"action %ld %ld", indexPath.section, indexPath.row] preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];

        [alert addAction:alertAction];
        [self presentViewController:alert animated:YES completion:nil];
        
     
        
        NSLog(@"action %ld %ld", indexPath.section, indexPath.row);
    }
 
    NSLog(@"actionInfoCell");
}

- (NSString*) fileSizeFromValue:(unsigned long long) size {
 
    static NSString *units[] = {@"B", @"KB", @"MB", @"GB", @"TB"};
//    NSArray *units = [[NSArray alloc] initWithObjects:@"B", @"KB", @"MB", @"GB", @"TB", nil];
    static int unitsCount = 5;
    
    int index = 0;
    
    double fileSize = (double) size;
    
    while (fileSize > 1024 && index < unitsCount) {
        
        fileSize /= 1024;
        index++;
    }
    
    return [NSString stringWithFormat:@"%.2f %@", fileSize, units[index]];
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
    
    static NSString *fileIdentifier = @"FileCell";
    static NSString *folderIdentifier = @"FolderCell";
    
    NSString *fileName = [self.contents objectAtIndex:indexPath.row];
    
    if ([self isDirectoryAtIndexPath:indexPath]) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:folderIdentifier];
        cell.textLabel.text = fileName;
        
        return cell;
        
    } else {
        
        NSString *path = [self.path stringByAppendingPathComponent:fileName];
        
        NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
        
        EGBFileCell *cell = [tableView dequeueReusableCellWithIdentifier:fileIdentifier];
        
        cell.nameLabel.text = fileName;
        cell.sizeLabel.text = [self fileSizeFromValue:[attributes fileSize]];
        
        static NSDateFormatter *dateFormatter = nil;
        
        if (!dateFormatter) {
            
            dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm a"];
        }
        
        cell.dateLabel.text = [dateFormatter stringFromDate:[attributes fileModificationDate]];
        
        return cell;
    }
    
    return nil;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    if ([self isDirectoryAtIndexPath:indexPath]) {
        
        return 44.f;
        
    } else {
     
        return 80.f;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self isDirectoryAtIndexPath:indexPath]) {
        
        NSString *fileName = [self.contents objectAtIndex:indexPath.row];
        
        NSString *filePath = [self.path stringByAppendingPathComponent:fileName];
        
//        EGBDirectoryViewController *viewController = [[EGBDirectoryViewController alloc]
//                                                      initWithFolderPath:filePath];
//        [self.navigationController pushViewController:viewController animated:YES];
        
//        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Storyboard_iPhone" bundle:nil];
        
//        EGBDirectoryViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EGBDirectoryViewController"];
//        viewController.path = filePath;
//        [self.navigationController pushViewController:viewController animated:YES];
        
        self.selectedPath = filePath;
        
        [self performSegueWithIdentifier:@"navigateDeep"  sender:nil];
    }
}

#pragma mark - Segue

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    
    NSLog(@"shouldPerformSegueWithIdentifier: %@", identifier);
 
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 
    NSLog(@"prepareForSegue: %@", segue.identifier);
    
    EGBDirectoryViewController *vc = segue.destinationViewController;
    vc.path = self.selectedPath;
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
