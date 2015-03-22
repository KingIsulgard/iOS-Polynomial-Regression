//
//  2DMatrixOfDoubles.m
//  PolynomialRegression
//
//  Created by Gilles Lesire on 19/03/15.
//  GNU General Public License (GPL)
//

#import "TwoDimensionalMatrixOfDoubles.h"

@implementation TwoDimensionalMatrixOfDoubles

@synthesize rows;
@synthesize columns;

/**
 * Matrix init
 *
 * Create an empty matrix with zeros of size rowsxcolumns
 */
- (id) initWithSizeRows: (int) m columns: (int) n
{
    if ( self = [super init] )
    {
        rows = m;
        columns = n;
        values = [[NSMutableArray alloc] init];
        
        for(int i = 0; i < m; i++) {
            NSMutableArray *nValues = [[NSMutableArray alloc] init];
            
            for(int j = 0; j < n; j++) {
                [nValues addObject: [NSNumber numberWithDouble: 0]];
            }
            
            [values addObject: nValues];
        }
    }
    
    return self;
}

/**
 * Matrix expand
 *
 * Resize the array to a bigger size if needed
 */
- (void) expandToRows: (int) m columns: (int) n
{
    if(columns < n) {
        for(int i = 0; i < rows; i++) {
            int adder = n - columns;
            for(int j = 0; j < adder; j++) {
                [[values objectAtIndex: i] addObject: [NSNumber numberWithDouble: 0]];
            }
        }
        columns = n;
    }
    
    if(rows < m) {
        int adder = m - rows;
        for(int i = 0; i < adder; i++) {
            NSMutableArray *nValues = [[NSMutableArray alloc] init];
            for(int j = 0; j < n; j++) {
                [nValues addObject: [NSNumber numberWithDouble: 0]];
            }
            [values addObject: nValues];
            
        }
        rows = m;
    }
}

/**
 * Matrix setvalue
 *
 * Set the value at a certain row and column
 */
- (void) setValueAtRow: (int) m column: (int) n value: (double) value
{
    if(m >= rows || n >= columns) {
        [self expandToRows: (m + 1) columns: (n + 1)];
    }
    
    NSNumber *val = [NSNumber numberWithDouble: value];
    [[values objectAtIndex: m] setObject: val atIndex: n];
}

/**
 * Matrix getvalue
 *
 * Get the value at a certain row and column
 */
- (double) getValueAtRow: (int) m column: (int) n
{
    if(m >= rows || n >= columns) {
        [self expandToRows: (m + 1) columns: (n + 1)];
    }
    
    return [[[values objectAtIndex: m] objectAtIndex: n] doubleValue];
}

/**
 * Matrix transpose
 * Result is a new matrix created by transposing this current matrix
 *
 * Eg.
 * [1,2,3]
 * [4,5,6]
 * becomes
 * [1,4]
 * [2,5]
 * [3,6]
 *
 * @link http://en.wikipedia.org/wiki/Transpose Wikipedia
 */
- (TwoDimensionalMatrixOfDoubles *) transpose {
    TwoDimensionalMatrixOfDoubles *transposed = [[TwoDimensionalMatrixOfDoubles alloc] initWithSizeRows: self.columns columns: self.rows];
    
    for(int i = 0; i < self.rows; i++) {
        for(int j = 0; j < self.columns; j++) {
            double value = [self getValueAtRow: i column: j];
            [transposed setValueAtRow: j column: i value: value];
        }
        
    }
    
    return transposed;
}

/**
 * Matrix multiply
 * Result is a new matrix created by multiplying this current matrix with a given matrix
 * The current matrix A should have just as many columns as the given matrix B has rows
 * otherwise multiplication is not possible
 *
 * The result of a mxn matrix multiplied with an nxp matrix resulsts in a mxp matrix
 * (AB)_{ij} = \sum_{r=1}^n a_{ir}b_{rj} = a_{i1}b_{1j} + a_{i2}b_{2j} + \cdots + a_{in}b_{nj}.
 *
 * @link http://en.wikipedia.org/wiki/Matrix_multiplication Wikipedia
 */
- (TwoDimensionalMatrixOfDoubles *) multiplyWithMatrix: (TwoDimensionalMatrixOfDoubles *) matrix {
    if(self.columns != matrix.rows) {
        [NSException raise:@"There should be as many columns in matrix A (this matrix) as there are rows in matrix B (parameter matrix) to multiply. " format: @"Matrix A has %d columns and matrix B has %d rows.", self.columns, matrix.rows];
        return nil;
    }
    
    // The result of a mxn matrix multiplied with an nxp matrix resulsts in a mxp matrix
    TwoDimensionalMatrixOfDoubles *result = [[TwoDimensionalMatrixOfDoubles alloc] initWithSizeRows: rows columns: matrix.columns];
    
    for(int r_col = 0; r_col < matrix.columns; r_col++) {
        
        for(int l_row = 0; l_row < rows; l_row++) {
            // For field Rij we need to make the sum of AixBxj
            double value = 0.0f;
            for(int col = 0; col < columns; col++) {
                value += ([self getValueAtRow: l_row column: col] * [matrix getValueAtRow: col column: r_col]);
            }
            [result setValueAtRow: l_row column: r_col value: value];
        }
    }
    
    return result;
}

/**
 * Matrix determinant
 *
 * Calculates the determinant value of the matrix
 *
 * Eg.
 * [1,2,3]
 * [4,5,6]
 * calculates
 * 1*5*3 + 2*6*1 + 3*4*2 - 3*5*1 - 2*4*3 - 1*6*2
 * equals 0
 *
 * @link http://en.wikipedia.org/wiki/Determinant Wikipedia
 */
- (double) determinant {
    double det = 0;
    
    for(int i = 0; i < rows; i++) {
        double product = 1;
        
        for(int j = 0; j < columns; j++) {
            int column = (int) fmodf(i + j, columns);
            int row = (int) fmodf(j, rows);
            
            product *= [self getValueAtRow: row column: column];
        }
        
        det += product;
        
        product = 1;
        
        for(int j = 0; j < columns; j++) {
            int column = (int) fmodf(i - j + columns, columns);
            int row = (int) fmodf(j, rows);
            
            product *= [self getValueAtRow: row column: column];
        }
        
        det -= product;
    }
    
    return det;
}

/**
 * Matrix duplicate
 *
 * Creates a duplicate TwoDimensionalMatrixOfDoubles of the current matrix
 */
- (TwoDimensionalMatrixOfDoubles *) duplicate {
    TwoDimensionalMatrixOfDoubles *duplicate = [[TwoDimensionalMatrixOfDoubles alloc] initWithSizeRows: rows columns: columns];
    
    for(int i = 0; i < rows; i++) {
        for(int j = 0; j < columns; j++) {
            [duplicate setValueAtRow: i column: j value: [self getValueAtRow: i column: j]];
        }
    }
    
    return duplicate;
}
@end
