//
//  WebImporterViewController.m
//  MHGRepeater
//
//  Created by Henry Heguang Miao on 17/3/17.
//  Copyright © 2017 Hokuang. All rights reserved.
//

#import "WebImporterViewController.h"

@import GCDWebServers;

@interface WebImporterViewController ()

@property (weak, nonatomic) IBOutlet UILabel *urlLabel;

@property (strong, nonatomic) GCDWebUploader *webUploader;

@end

@implementation WebImporterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString* documentsPath = USER_DOCUMENT_PATH;
    _webUploader = [[GCDWebUploader alloc] initWithUploadDirectory:documentsPath];
    [_webUploader start];
    self.urlLabel.text = _webUploader.serverURL.absoluteString;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)finish:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
