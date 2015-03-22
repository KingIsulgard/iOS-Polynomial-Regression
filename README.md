# iOS-Polynomial-Regression
Objective-C function for calculation the polynomial regression of a given dataset.

There are no mathematical data analysis functions in Objective-C and I couldn't find a suitable math framework for this task. For my thesis I require a function to calculate the polynomial regression of a give data set. Since this function didn't exist I had to write it myself. Problem was that other programming languages usually have this implemented by default as some kind of "polyfit" function so I dind't really had an example to base myself on.

So I had to go into the math and figure out how to turn it into an algorithm. A hellish job I wouldn't recommend to anyone. I programmed an Objective-C function for the calculation the polynomial regression of a given dataset which is extremely easy to use.

You have to give an array of NSNumber for the x values and y values and the desired degree of polynomial you would like to aquire. The function will return an NSMutableArray containing the polynomial constants. 
