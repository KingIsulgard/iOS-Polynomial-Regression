# iOS-Polynomial-Regression
Objective-C function for calculation the polynomial regression of a given dataset.

There are no mathematical data analysis functions in Objective-C and I couldn't find a suitable math framework for this task. For my thesis I require a function to calculate the polynomial regression of a give data set. Since this function didn't exist I had to write it myself. Problem was that other programming languages usually have this implemented by default as some kind of "polyfit" function so I dind't really had an example to base myself on.

So I had to go into the math and figure out how to turn it into an algorithm. A hellish job I wouldn't recommend to anyone. I programmed an Objective-C function for the calculation the polynomial regression of a given dataset which is extremely easy to use.

You have to give an array of NSNumber for the x values and y values and the desired degree of polynomial you would like to aquire. The function will return an NSMutableArray containing the polynomial constants. 

Example usage

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
    
    NSMutableArray *regression = [PolynomialRegression regressionWithXValues: x AndYValues: y PolynomialDegree: 6];
    
    NSLog(@"The result is the sum of");
    
    for(int i = 0; i < 6; i++) {
        double value = [[regression objectAtIndex: i] doubleValue];
        NSLog(@"%f * x^%d", value, i);
    }

Generates the following output in console

2015-03-22 19:41:13.727 PolynomialRegression[2261:103071] The result is the sum of
2015-03-22 19:41:13.736 PolynomialRegression[2261:103071] 1.011300 * x^0
2015-03-22 19:41:13.736 PolynomialRegression[2261:103071] -23.964676 * x^1
2015-03-22 19:41:13.736 PolynomialRegression[2261:103071] 4.546635 * x^2
2015-03-22 19:41:13.736 PolynomialRegression[2261:103071] -0.236831 * x^3
2015-03-22 19:41:13.736 PolynomialRegression[2261:103071] -0.000581 * x^4
2015-03-22 19:41:13.736 PolynomialRegression[2261:103071] 0.000309 * x^5
