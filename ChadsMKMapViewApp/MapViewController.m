//
//  MapViewController.m
//  ChadsMKMapViewApp
//
//  Created by Chad Wiedemann on 9/15/16.
//  Copyright © 2016 Chad Wiedemann. All rights reserved.
//

#import "MapViewController.h"
#define OFFSET_FOR_KEYBOARD 80

@interface MapViewController ()

@end

@implementation MapViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    self.locationManager = [[CLLocationManager alloc]init];
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager setDelegate:self];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    return self;
}

#pragma mark - Set different type of map

- (IBAction)setMap:(id)sender
{
    switch (((UISegmentedControl*) sender).selectedSegmentIndex) {
        case 0:
            self.mapView.mapType = MKMapTypeStandard;
            break;
        case 1:
            self.mapView.mapType = MKMapTypeHybrid;
            break;
        case 2:
            self.mapView.mapType = MKMapTypeSatellite;
            break;
        default:
            break;
    }





}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    turnToTech2DLocation = CLLocationCoordinate2DMake(40.74143697008403, -73.99011969566345);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];

    self.searchBar.delegate = self;
    self.mapView.showsUserLocation = YES;
    self.nearByRestaurantsPlacemarks = [[NSMutableArray alloc]init];
    self.nearByRestaurants = [[NSMutableArray alloc]init];
    self.localSearchResults = [[NSMutableArray alloc] init];
    [self loadHardCodedPlaces];
//    [self searchForRestaurants:@"restaurant"];
}

-(void)loadHardCodedPlaces
{
    RestaurantWithNoCoordinate *turnToTech = [[RestaurantWithNoCoordinate alloc]init];
    turnToTech.address1 = @"184 5th Avenue New York";
    turnToTech.imageString = @"logo";
    turnToTech.name = @"TurnToTech";
    turnToTech.restaurantWebsite = @"http://www.turntotech.io";
    
    RestaurantWithNoCoordinate *maisonKayser = [[RestaurantWithNoCoordinate alloc]init];
    maisonKayser.address1 = @"921 broadway new york";
    maisonKayser.imageString = @"coffee";
    maisonKayser.name = @"Maison Kayser";
    maisonKayser.restaurantWebsite = @"http://www.maison-kayser.usa.com";
    
    RestaurantWithNoCoordinate *ilBastardo = [[RestaurantWithNoCoordinate alloc]init];
    ilBastardo.address1 = @"191 7th Avenue new york";
    ilBastardo.imageString = @"burger";
    ilBastardo.name = @"Il Bastardo";
    ilBastardo.restaurantWebsite = @"http://nycrg.com/il-bastardo/";
    
    [self.nearByRestaurants addObject:turnToTech];
    [self.nearByRestaurants addObject:maisonKayser];
    [self.nearByRestaurants addObject:ilBastardo];
    for(RestaurantWithNoCoordinate *r in self.nearByRestaurants)
    {
        [self placeAnnotation:r.address1 logo:r.imageString name:r.name website:r.restaurantWebsite];
    }
    
}

-(void)placeAnnotation:(NSString*) location logo:(NSString*) logoString name:(NSString*) name website: (NSString*) website
{

    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString: location
                 completionHandler:^(NSArray* placemarks, NSError* error){
                     if (placemarks && placemarks.count > 0) {
                         CLPlacemark *topResult = [placemarks objectAtIndex:0];
                         MKPlacemark *placemark = [[MKPlacemark alloc] initWithPlacemark:topResult];
                         
                         Resaurant *newRestaurant = [[Resaurant alloc]initWithLocation:placemark.coordinate title:name];
                         newRestaurant.address = location;
                         newRestaurant.imageString = logoString;
                         newRestaurant.restaurantWebsite = website;
                        
                         [self.mapView selectAnnotation:newRestaurant animated:YES];
                         [self.mapView addAnnotation:newRestaurant];
                         [self.nearByRestaurantsPlacemarks addObject:newRestaurant];
                         [self.mapView showAnnotations:self.nearByRestaurantsPlacemarks animated:YES];
                     }
                 }
     ];

}
-(MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    
    if([annotation isKindOfClass:[Resaurant class]])
    {
    
        Resaurant *tempRestaurant = (Resaurant*)annotation;
        MKPinAnnotationView *annotationView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"identifier"];
        if(annotationView == nil)
        {
            annotationView = [tempRestaurant annotationView];
        }else
            annotationView.annotation = annotation;
        
        return annotationView;
    }else
    {
        return nil;
    }
}





-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    NSLog(@"annotationtapped");
}


-(void)zoomIn:(NSArray*) localPlaces
{
    [self.mapView showAnnotations:localPlaces animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    NSLog(@"Location: %f, %f",
          userLocation.location.coordinate.latitude,
          userLocation.location.coordinate.longitude);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.location.coordinate, 250, 250);
    [self.mapView setRegion:region animated:YES];
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    WebSiteViewController *websiteVC = [[WebSiteViewController alloc]init];
    Resaurant *tempRestaurant = [[Resaurant alloc]init];
    tempRestaurant = view.annotation;
    websiteVC.webSite = tempRestaurant.restaurantWebsite;
    [self presentViewController:websiteVC animated:YES completion:nil];
}

-(void)searchForRestaurants: (NSString*) restaurant
{
    
    MKLocalSearchRequest *foodSearch = [[MKLocalSearchRequest alloc]init];
    foodSearch.naturalLanguageQuery = restaurant;
    
    
    MKCoordinateRegion turnToTechRegion = MKCoordinateRegionMakeWithDistance(turnToTech2DLocation, 1500, 1500);
    [foodSearch setRegion:turnToTechRegion];
    
    MKLocalSearch *search = [[MKLocalSearch alloc]initWithRequest:foodSearch];
    [search startWithCompletionHandler:^(MKLocalSearchResponse * _Nullable response, NSError * _Nullable error) {
        if(!error){
            self.localSearchResults = [[response mapItems] mutableCopy];
            for (MKMapItem *mapItem in [response mapItems]) {
                NSLog(@"Name: %@, Placemark title: %@", [mapItem url], [[mapItem placemark] title]);
                RestaurantWithNoCoordinate *tempRestaurant = [[RestaurantWithNoCoordinate alloc]init];
                tempRestaurant.address1 = mapItem.placemark.title;
                tempRestaurant.name = mapItem.name;
                tempRestaurant.restaurantWebsite = [mapItem.url absoluteString];
                [self placeAnnotation:tempRestaurant.address1 logo:nil name:tempRestaurant.name website: tempRestaurant.restaurantWebsite];
            }
            
        }else{
            NSLog(@"%@",error.localizedDescription);
        }
    }];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self searchForRestaurants:searchBar.text];
}

# pragma mark - get the view to move up when keyboard shows up

-(void)keyboardWillShow {
    // Animate the current view out of the way
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)keyboardWillHide {
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)sender
{
    if ([sender isEqual:self.searchBar])
    {
        //move the main view, so that the keyboard does not hide it.
        if  (self.view.frame.origin.y >= 0)
        {
            [self setViewMovedUp:YES];
        }
    }
}

//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= OFFSET_FOR_KEYBOARD;
        rect.size.height += OFFSET_FOR_KEYBOARD;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += OFFSET_FOR_KEYBOARD;
        rect.size.height -= OFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

#pragma mark - dissmisses keyboard
-(void)dismissKeyboard {
    [self.searchBar resignFirstResponder];
}


@end
