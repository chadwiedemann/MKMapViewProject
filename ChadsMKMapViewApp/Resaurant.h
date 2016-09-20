//
//  Resaurant.h
//  ChadsMKMapViewApp
//
//  Created by Chad Wiedemann on 9/16/16.
//  Copyright © 2016 Chad Wiedemann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "WebSiteViewController.h"

#import <Foundation/Foundation.h>

@interface Resaurant : NSObject <MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) NSString *restaurantWebsite;
@property (nonatomic, strong) NSString *imageString;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *name;

- (id)initWithLocation:(CLLocationCoordinate2D)coord title:(NSString*) title;
-(MKPinAnnotationView*)annotationView;
@end
