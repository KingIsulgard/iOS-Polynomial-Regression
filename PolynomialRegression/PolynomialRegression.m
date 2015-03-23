//
//  PolynomialRegression.m
//  PolynomialRegression
//
//  Created by Gilles Lesire on 22/03/15.
//  GNU General Public License (GPL)
//  https://github.com/KingIsulgard/iOS-Polynomial-Regression
//

#import "PolynomialRegression.h"

@implementation PolynomialRegression
+ (NSMutableArray *) regressionWithXValues: (NSMutableArray *) xvals AndYValues: (NSMutableArray *) yvals PolynomialDegree: (int) p {
    
    if(p < 1) {
        [NSException raise:@"Degree of polynomial must be at least 1. " format: @"Given polynomial degree of %d is invalid.", p];
        return nil;
    }
    
    if([xvals count] != [yvals count]) {
        [NSException raise:@"There should be as many x values as y values. " format: @"Given %d x values and %d y values.", (int) [xvals count], (int) [yvals count]];
        return nil;
    }
    
    DoublesMatrix *z = [[DoublesMatrix alloc] initWithSizeRows: (int) [xvals count] columns: (p + 1)];
    
    for(int i = 0; i < (int) [xvals count]; i++) {
        for(int j = 0; j <= p; j++) {
            double val = pow([[xvals objectAtIndex: i] doubleValue], (double) j);
            [z setValueAtRow: i column: j value: val];
        }
    }
    
    DoublesMatrix *y = [[DoublesMatrix alloc] initWithSizeRows: (int) [yvals count] columns: 1];
    
    for(int u = 0; u < (int) [yvals count]; u++) {
        [y setValueAtRow: u column: 0 value: [[yvals objectAtIndex: u] doubleValue]];
    }
    
    DoublesMatrix *z_transposed = [z transpose];
    DoublesMatrix *l = [z_transposed multiplyWithMatrix: z];
    DoublesMatrix *r = [z_transposed multiplyWithMatrix: y];
    
    DoublesMatrix *regression = [self solve_for: l andR: r];
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    for(int i = 0; i <= p; i++) {
        double value = [regression getValueAtRow:i column:0];
        [result addObject: [NSNumber numberWithDouble: value]];
    }
    
    return result;
}

+ (DoublesMatrix *) solve_for: (DoublesMatrix *) l andR: (DoublesMatrix *) r {
    
    DoublesMatrix *resultMatrix = [[DoublesMatrix alloc] initWithSizeRows: l.rows columns: 1];
    
    NSMutableArray *resDecomp = [self decompose: l];
    
    DoublesMatrix *nP = [resDecomp objectAtIndex: 2];
    DoublesMatrix *lMatrix = [resDecomp objectAtIndex: 1];
    DoublesMatrix *uMatrix = [resDecomp objectAtIndex: 0];
    
    for(int k = 0; k < r.rows; k++) {
        double sum = 0.0f;
        
        DoublesMatrix *dMatrix = [[DoublesMatrix alloc] initWithSizeRows: l.rows columns: 1];
        
        double val1 = [r getValueAtRow: (int) [nP getValueAtRow: 0 column: 0] column: k];
        double val2 = [lMatrix getValueAtRow: 0 column: 0];
        [dMatrix setValueAtRow: 0 column: 0 value: val1 / val2];
        
        for(int i = 1; i < l.rows; i++) {
            sum = 0.0f;
            for(int j = 0; j < i; j++) {
                sum += ([lMatrix getValueAtRow: i column: j] * [dMatrix getValueAtRow: j column: 0]);
            }
            
            double value = [r getValueAtRow: (int) [nP getValueAtRow: i column: 0] column: k];
            value -= sum;
            value /= [lMatrix getValueAtRow: i column: i];
            [dMatrix setValueAtRow: i column: 0 value: value];
        }
        
        [resultMatrix setValueAtRow: (l.rows - 1) column: k value: [dMatrix getValueAtRow: (l.rows - 1) column: 0]];
        
        for(int i = (l.rows - 2); i >= 0; i--) {
            sum = 0.0f;
            for(int j = i + 1; j < l.rows; j++) {
                sum += ([uMatrix getValueAtRow: i column: j] * [resultMatrix getValueAtRow: j column: k]);
            }
            [resultMatrix setValueAtRow: i column: k value: ([dMatrix getValueAtRow: i column: 0] - sum)];
        }
    }
    
    return resultMatrix;
}

+ (NSMutableArray *) decompose: (DoublesMatrix *) l {
    DoublesMatrix *uMatrix = [[DoublesMatrix alloc] initWithSizeRows: 1 columns: 1];
    DoublesMatrix *lMatrix = [[DoublesMatrix alloc] initWithSizeRows: 1 columns: 1];
    DoublesMatrix *workingUMatrix = [l duplicate];
    DoublesMatrix *workingLMatrix = [[DoublesMatrix alloc] initWithSizeRows: 1 columns: 1];
    
    DoublesMatrix *pivotArray = [[DoublesMatrix alloc] initWithSizeRows: l.rows columns: 1];
    
    for(int i = 0; i < l.rows; i++) {
        [pivotArray setValueAtRow: i column: 0 value: (double) i];
    }
    
    for(int i = 0; i < l.rows; i++) {
        double maxRowRatio = -2147483648;
        int maxRow = -1;
        int maxPosition = -1;
        
        for(int j = i; j < l.rows; j++) {
            double rowSum = 0.0f;
            
            for(int k = i; k < l.rows; k++) {
                rowSum += fabs([workingUMatrix getValueAtRow: (int) [pivotArray getValueAtRow: j column: 0] column: k]);
            }
            
            double dCurrentRatio = fabs([workingUMatrix getValueAtRow: (int) [pivotArray getValueAtRow: j column: 0] column: i]) / rowSum;
            
            if(dCurrentRatio > maxRowRatio) {
                maxRowRatio = (int) fabs([workingUMatrix getValueAtRow: (int) [pivotArray getValueAtRow: j column: 0] column: i]) / rowSum;
                maxRow = (int) [pivotArray getValueAtRow: j column: 0];
                maxPosition = j;
            }
        }
        
        if(maxRow != (int) [pivotArray getValueAtRow: i column: 0]) {
            
            double hold = [pivotArray getValueAtRow: i column: 0];
            
            [pivotArray setValueAtRow: i column: 0 value: (double) maxRow];
            
            [pivotArray setValueAtRow: maxPosition column: 0 value: hold];
        }
        
        double rowFirstElementValue = [workingUMatrix getValueAtRow: (int) [pivotArray getValueAtRow: i column: 0] column: i];
        
        for(int j = 0; j < l.rows; j++) {
            if(j < i) {
                [workingUMatrix setValueAtRow: (int) [pivotArray getValueAtRow: i column: 0] column: j value: 0.0f];
            } else if(j == i) {
                [workingLMatrix setValueAtRow: (int) [pivotArray getValueAtRow: i column: 0] column: j value: rowFirstElementValue];
                [workingUMatrix setValueAtRow: (int) [pivotArray getValueAtRow: i column: 0] column: j value: 1.0f];
            } else {
                double tempValue = [workingUMatrix getValueAtRow: (int) [pivotArray getValueAtRow: i column: 0] column: j];
                [workingUMatrix setValueAtRow: (int) [pivotArray getValueAtRow: i column: 0] column: j value: tempValue / rowFirstElementValue];
                [workingLMatrix setValueAtRow: (int) [pivotArray getValueAtRow: i column: 0] column: j value: 0.0f];
            }
        }
        
        for(int k = i + 1; k < l.rows; k++) {
            rowFirstElementValue = [workingUMatrix getValueAtRow: (int) [pivotArray getValueAtRow: k column: 0] column: i];
            
            for(int j = 0; j < l.rows; j++) {
                if(j < i) {
                    [workingUMatrix setValueAtRow: (int) [pivotArray getValueAtRow: k column: 0] column: j value: 0.0f];
                } else if(j == i) {
                    [workingLMatrix setValueAtRow: (int) [pivotArray getValueAtRow: k column: 0] column: j value: rowFirstElementValue];
                    [workingUMatrix setValueAtRow: (int) [pivotArray getValueAtRow: k column: 0] column: j value: 0.0f];
                } else {
                    double tempValue = [workingUMatrix getValueAtRow: (int) [pivotArray getValueAtRow: k column: 0] column: j];
                    double tempValue2 = [workingUMatrix getValueAtRow: (int) [pivotArray getValueAtRow: i column: 0] column: j];
                    [workingUMatrix setValueAtRow: (int) [pivotArray getValueAtRow: k column: 0] column: j value: tempValue - (rowFirstElementValue * tempValue2)];
                }
            }
        }
    }
    
    for(int i = 0; i < l.rows; i++) {
        for(int j = 0; j < l.rows; j++) {
            double uValue = [workingUMatrix getValueAtRow: (int) [pivotArray getValueAtRow: i column:0] column: j];
            double lValue = [workingLMatrix getValueAtRow: (int) [pivotArray getValueAtRow: i column:0] column: j];
            [uMatrix setValueAtRow: i column: j value: uValue];
            [lMatrix setValueAtRow: i column: j value: lValue];
        }
    }
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [result addObject: uMatrix];
    [result addObject: lMatrix];
    [result addObject: pivotArray];
    
    return result;
}
@end