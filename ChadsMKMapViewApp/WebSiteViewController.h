//
//  WebSiteViewController.h
//  ChadsMKMapViewApp
//
//  Created by Chad Wiedemann on 9/16/16.
//  Copyright © 2016 Chad Wiedemann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface WebSiteViewController : UIViewController <WKNavigationDelegate>



- (IBAction)backButton:(id)sender;

@property (nonatomic,strong) NSString *webSite;
@property (nonatomic, strong) WKWebView *webViewForWebSite;
@property (weak, nonatomic) IBOutlet UIView *subViewForWebSite;

@end
