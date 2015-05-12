//
//  2DMatrixOfDoubles.h
//  PolynomialRegression
//
//  Created by Gilles Lesire on 19/03/15.
//  GNU General Public License (GPL)
//  https://github.com/KingIsulgard/iOS-Polynomial-Regression
//

#import <Foundation/Foundation.h>

@interface DoublesMatrix : NSObject {
    NSMutableArray *values;
    int rows;
    int columns;
}

@property (nonatomic) int rows;
@property (nonatomic) int columns;

- (id) initWithSizeRows: (int) m columns: (int) n;
- (void) expandToRows: (int) m columns: (int) n;
- (void) setValueAtRow: (int) m column: (int) n value: (double) value;
- (double) getValueAtRow: (int) m column: (int) n;

- (DoublesMatrix *) transpose;
- (DoublesMatrix *) multiplyWithMatrix: (DoublesMatrix *) matrix;

- (void) rotateLeft;
- (void) rotateRight;

- (void) rotateTop;
- (void) rotateBottom;

- (double) determinant;

- (DoublesMatrix *) duplicate;

@end
