The goal of this project is to find the micro average and macro average precision
of my implementation of k-nearest neighbor.

calculateAccuracy() from project1 is supplemented with the ability to count
the number of true positives for each fruit. It also outputs the micro average 
by dividing the total number of true positives by the total number of instances.

calculateMacro() finds the precision of the fruit predictions by dividing the
true positives counted by calculateAccuracy() and dividing it by the number
of instances of a given fruit. The macro average is then calulcated by adding
the precisions and dividing it by the number of fruit categories, which is 4.
This function then ouputs the precision scores and the macro average.