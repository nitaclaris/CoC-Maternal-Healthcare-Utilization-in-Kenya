PROJECT:		Socioeconomic and Sociodemographic Predictors of Continuum of Maternal Healthcare Utilization in Kenya: Evidence from the 2022 KDHS 

PURPOSE: 		Generating the Outcome Variable

AUTHOR:  		NITA CLARIS

CREATED: 		16 APR 2026

********************************************************************************

clear
clear matrix
set more off

set maxvar 10000

********************DATA CLEANING & MANIPULATION********************************
********************************************************************************

***Load the dataset

use Continuum_MHU_Clean.dta

***Generate the weight variable

gen wt=v005/1000000

***Survey settings

svyset  v021 [pw=wt], strata (v022)


***Restrict the sample to births in the last five years

keep if v208 >=1

***keep only women with children <60 months

keep if b19_01 < 60 


********************************************************************************
********************GENERATE MY WORKING VARAIBLES*******************************

************************************OUTCOME VARIABLE

*Four or more ANC Visits
gen ANC4 = (m14_1 >= 4) if m14_1 < .
label variable ANC4 "Four ANC Visits or more"
label define M14 0 "No" 1 "Yes"
label values ANC4 M14

*Skilled Birth Attendance
//doctor , nurse or midwife, auxilliary midwife

gen SBA = 0
replace SBA =1 if m3a_1==1 | m3b_1==1 |m3c_1==1  
label variable SBA "Skilled Birth Attendance"
label define SBA 0 "No" 1 "Yes"
label values SBA SBA

*Postnatal care within 48 hours

gen PNC =0

*for facility deliveries
replace PNC=1 if m62_1==1 & ((m63_1>=100 & m63_1<=171) | (m63_1>=200 & m63_1<=202))

*for home deliveries
replace PNC=1 if m66_1==1 & ((m67_1>=100 & m67_1<=171) | (m67_1>=200 & m67_1<=202))

label variable PNC "Postnatal Check within 48 hours"
label define PNC 0 "No" 1 "Yes"
label values PNC PNC

***Final Outcome variable Continuum of Maternal Healthcare Utilization

gen Continuum=.

**complete continuum

replace Continuum=2 if ANC4==1 & SBA==1 & PNC==1

**partial continuum

replace Continuum=0 if ANC4==0 & SBA==0 & PNC==0

**no continuum

replace Continuum=1 if Continuum==.

label variable Continuum "Continuum of Maternal Health Utilization"
label define Continuum 0 "No Continuum" 1 "Partial Continuum" 2 "Complete Continuum"
label values Continuum Continuum

svy: tab ANC4
svy: tab PNC
svy: tab SBA
svy: tab Continuum

*******************


save Continuum_MHU_Clean_2.dta, clean  /// save the dataset
