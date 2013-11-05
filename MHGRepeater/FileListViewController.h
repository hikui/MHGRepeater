//
//  FileListViewController.h
//  MHGRepeater
//
//  Created by 缪 和光 on 13-11-4.
//  Copyright (c) 2013年 Hokuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FileListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end
