//
//  MapViewController.h
//  ChadsMKMapViewApp
//
//  Created by Chad Wiedemann on 9/15/16.
//  Copyright © 2016 Chad Wiedemann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "WebSiteViewController.h"
#import "Resaurant.h"
#import "RestaurantWithNoCoordinate.h"




@interface MapViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate, UISearchBarDelegate, UIScrollViewDelegate>
{
    CLLocationCoordinate2D turnToTech2DLocation;
}
@property (retain, nonatomic) UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIImageView *turnToTechLogoImageView;
@property(nonatomic, strong) NSMutableArray *nearByRestaurantsPlacemarks;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong)NSMutableArray *nearByRestaurants;
@property (nonatomic, strong) NSMutableArray *localSearchResults;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;


#pragma mark - IBAction method
- (IBAction)setMap:(id)sender;


@end
