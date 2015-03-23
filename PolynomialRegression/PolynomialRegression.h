//
//  PolynomialRegression.h
//  PolynomialRegression
//
//  Created by Gilles Lesire on 18/03/15.
//  GNU General Public License (GPL)
//  https://github.com/KingIsulgard/iOS-Polynomial-Regression
//

#import <Foundation/Foundation.h>
#import "DoublesMatrix.h"

@interface PolynomialRegression : NSObject
+ (NSMutableArray *) regressionWithXValues: (NSMutableArray *) xvals AndYValues: (NSMutableArray *) yvals PolynomialDegree: (int) p;
@end