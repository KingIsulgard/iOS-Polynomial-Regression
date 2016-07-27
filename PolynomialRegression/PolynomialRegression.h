//
//  PolynomialRegression.h
//  PolynomialRegression
//
//  Created by Gilles Lesire on 18/03/15.
//  GNU General Public License (GPL)
//  https://github.com/KingIsulgard/iOS-Polynomial-Regression
//

#define kPolynomialRegressionSolutionCoefficientArrayKey @"kPolynomialRegressionSolutionCoefficientArrayKey"
#define kPolynomialRegressionSolutionRSquaredKey @"kPolynomialRegressionSolutionRSquaredKey"
#define kPolynomialRegressionSolutionPolyDegreeKey @"kPolynomialRegressionSolutionPolyDegreeKey"

#import <Foundation/Foundation.h>
#import "DoublesMatrix.h"

@interface PolynomialRegression : NSObject
+ (NSMutableDictionary *) regressionWithPoints:(NSArray *)points polynomialDegree: (int) p;
+ (NSMutableArray *) regressionWithXValues: (NSMutableArray *) xvals AndYValues: (NSMutableArray *) yvals PolynomialDegree: (int) p;
@end