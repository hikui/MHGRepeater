//
//  FileListViewController.m
//  MHGRepeater
//
//  Created by 缪 和光 on 13-11-4.
//  Copyright (c) 2013年 Hokuang. All rights reserved.
//

#import "FileListViewController.h"
#import "PlayerViewController.h"
#import "WebImporterViewController.h"

@interface FileListViewController ()

@property (nonatomic ,strong) NSMutableArray *fileList;

@end

@implementation FileListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _fileList = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"文件列表";
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addFiles)];
    UIBarButtonItem *refreshItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(scanFiles)];
    self.navigationItem.rightBarButtonItems = @[refreshItem, addItem];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self scanFiles];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scanFiles
{
    [self.fileList removeAllObjects];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *dirPath = USER_DOCUMENT_PATH;
    NSArray *directoryContent = [fm contentsOfDirectoryAtPath:dirPath error:NULL];
    
    for (NSString *fileName in directoryContent) {
        [self.fileList addObject:fileName];
    }
    
    [self.tableView reloadData];
}

- (void)addFiles
{
    WebImporterViewController *vc = [[WebImporterViewController alloc]initWithNibName:@"WebImporterViewController" bundle:nil];
    [self presentViewController:vc animated:YES completion:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.fileList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"FileListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = self.fileList[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PlayerViewController *pvc = [[PlayerViewController alloc]initWithFileName:self.fileList[indexPath.row]];
    [self.navigationController pushViewController:pvc animated:YES];
}

@end
