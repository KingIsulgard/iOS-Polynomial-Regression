//
//  ViewController.m
//  PolynomialRegression
//
//  Created by Gilles Lesire on 18/03/15.
//  GNU General Public License (GPL)
//  https://github.com/KingIsulgard/iOS-Polynomial-Regression
//

#import "ViewController.h"
#import "PolynomialRegression.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSMutableArray *x = [[NSMutableArray alloc] init];
    [x addObject: [NSNumber numberWithDouble: 0]];
    [x addObject: [NSNumber numberWithDouble: 9]];
    [x addObject: [NSNumber numberWithDouble: 13]];
    [x addObject: [NSNumber numberWithDouble: 15]];
    [x addObject: [NSNumber numberWithDouble: 19]];
    [x addObject: [NSNumber numberWithDouble: 20]];
    [x addObject: [NSNumber numberWithDouble: 26]];
    [x addObject: [NSNumber numberWithDouble: 26]];
    [x addObject: [NSNumber numberWithDouble: 29]];
    [x addObject: [NSNumber numberWithDouble: 30]];
    
    NSMutableArray *y = [[NSMutableArray alloc] init];
    
    [y addObject: [NSNumber numberWithDouble: 1]];
    [y addObject: [NSNumber numberWithDouble: -7]];
    [y addObject: [NSNumber numberWithDouble: 6]];
    [y addObject: [NSNumber numberWithDouble: 12]];
    [y addObject: [NSNumber numberWithDouble: -4]];
    [y addObject: [NSNumber numberWithDouble: -12]];
    [y addObject: [NSNumber numberWithDouble: -2]];
    [y addObject: [NSNumber numberWithDouble: 13]];
    [y addObject: [NSNumber numberWithDouble: 23]];
    [y addObject: [NSNumber numberWithDouble: 30]];
    
    int degree = 6;
    NSMutableArray *regression = [PolynomialRegression regressionWithXValues: x AndYValues: y PolynomialDegree: degree];
    
    NSLog(@"The result is the sum of");
    
    for(int i = 0; i < [regression count]; i++) {
        double value = [[regression objectAtIndex: i] doubleValue];
        NSLog(@"%f * x^%d", value, i);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
