# Activity Data

## Dependencies
- plyr 1.8.1
- reshape2 1.4.1

## Data Summary Procedure
All mean and standard deviation calculations for experimental measurements are kept (along with subject and position data).

The variables that are kept are then averaged according to which position and subject they correspond to, i.e. for every variable there is a row for every combination of subject and position.

To run the program:
```R
source('run_analysis.R')
```

> NB: The script should be in the same folder as the test and train folders.
