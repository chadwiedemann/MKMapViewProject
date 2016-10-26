//
//  WebSiteViewController.m
//  ChadsMKMapViewApp
//
//  Created by Chad Wiedemann on 9/16/16.
//  Copyright © 2016 Chad Wiedemann. All rights reserved.
//

#import "WebSiteViewController.h"

@interface WebSiteViewController ()

@end

@implementation WebSiteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WKWebViewConfiguration *theConfig = [[WKWebViewConfiguration alloc]init];
    
   
    self.webViewForWebSite = [[WKWebView alloc]init];
    [self.subViewForWebSite addSubview:self.webViewForWebSite];
    
    self.webViewForWebSite.navigationDelegate = self;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    NSURL *url  = [NSURL URLWithString:self.webSite];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [self.webViewForWebSite loadRequest:request];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.webViewForWebSite.frame = self.subViewForWebSite.bounds;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)backButton:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
@end
