The finalobs.csv file (check LinkforCSV.md file) contain all the raw data generated from SQL query. columns of this table are:
block, obsdate, observation, temper, precip, category, roadlength, geom.
this table has been used for EDA and regression analysis.


traintest_5.csv (check LinkforCSV.md file) = This csv file containes the data for training and test tasks for the Regression model. 
The timeline of the data is from 01012017-30062017. 


validate_1.csv = This csv file containes the data for validating tasks for the Regression model. 
The timeline of the data is for the complete month of June 2017
columns, respectively:
0 - observation per block per day(sum) - (response)
1 - block number
2 - longit
3 - latit
4 - observation date 
5 - temperature
6 - precipitation
7 - road length
8 - area of predominant land use
9 - Bebouwd
10 - Bedrijfsterrein
11 - Bos
12 - Coastal Water
13 - Droog Natuurlijk terrein
14 - Glastuinbouw
15 - Hoofdweg
16 - Landbouw
17 - Nat natuurlijk terrein
18 - Nature Reserves
19 - Recreatie
20 - SemiBebouwd
21 - Vliegveld
22 - Water(1-22 used as predictor variables)


predicted.csv = This file containes the observed data and the predicted data for all days of June 2017 as the output from the Regression model, 
it also contains block information.
columns, repectively:
blocknumber
longit
latit
observation(recorded for june)
predicted observation from Regression model
geom
