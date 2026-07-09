


*PROJECT:		Socioeconomic and Sociodemographic Predictors of Continuum of Maternal Healthcare Utilization in Kenya
* 				Evidence from the 2022 KDHS 


*PURPOSE: 		Data Analysis for a Manuscript 

*AUTHOR:  		NITA CLARIS

*CREATED: 		16 APR 2026


********************************************************************************

clear
clear matrix
set more off

set maxvar 10000

cd "C:\Users\Administrator\Desktop\Manuscripts\Continuum of Maternal Healthcare Utilization\KE_2022_DHS_04082026_1327_164971\KEIR8CDT"

********************DATA CLEANING & MANIPULATION********************************
********************************************************************************

***Load the dataset

use KEIR8CFL.DTA

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

********************************RECODING & RENAMING  PREDICTORS

rename v013 AgeCat
rename v190 WealthIndex
rename v157 Read_Newspaper
rename v159 Watch_TV
rename v158 Listen_radio
rename v467d Distance_Facility
rename v025 Residence


recode v501 (0 3 4 5 = 0 ) (1 2 = 1 )
rename v501 MaritalStatus

label define MaritalStatus 0 "Not in Union" 1 "In a Union"
label values MaritalStatus MaritalStatus

recode v731 (0 = 0) (1 2 3 =1)
rename v731 Occupation

label define Occupation 0 "Unemployed" 1 "Employed"
label values Occupation Occupation


recode v106 (0=0 ) (1=1 ) (2 3 =2 )
rename v106 Educationlevel

label define Educationlevel 0 "No Education" 1 "Primary Education" 2 "Secondary Education or Higher"
label values Educationlevel Educationlevel


gen FamilySize =0 if v136<=5
replace FamilySize=1 if v136>5

label variable FamilySize "Size of the household"
label define FamilySize 0 "<= 5 Members" 1 "> 5 Members"
label values FamilySize FamilySize

gen Woman_HH_head= 0 if v151==1
replace Woman_HH_head=2 if Woman_HH_head==.

label variable Woman_HH_head "Household head is a woman"
label define Woman_HH_head 0 "No" 1 "Yes"
label values Woman_HH_head Woman_HH_head

gen Planned_pregnancy= 1 if (v225== 0|v225==1 ) | (m10_1 ==0 | m10_1==1)
replace Planned_pregnancy=0 if Planned_pregnancy==.

label variable Planned_pregnancy "Planned pregnancy"
label define Planned_pregnancy 0 "No" 1 "Yes"
label values Planned_pregnancy Planned_pregnancy

gen first_anc= 0 if m13_1<4
replace first_anc=1 if m13_1>=4 & m13_1<=6
replace first_anc=2 if m13_1>=7 & m13_1<=10 & m13_1!=.

label variable first_anc "Timing of first anc visit"
label define first_anc 0 "< 4 Months" 1 "4 - 6 Months" 2 "7+ Months"
label values first_anc first_anc

gen Birth_Order=0 if bord_01==1
replace Birth_Order=1 if bord_01==2
replace Birth_Order=2 if bord_01>2

label variable Birth_Order "Birth_Order"
label define Birth_Order 0 "1" 1 "2" 2 ">2"
label values Birth_Order Birth_Order

********************************************************************************

save Continuum_MHU_Clean.dta, replace

********************************************************************************
******************************DESCRIPTIVE STATISTICS****************************

**Proportions in each service 

svy: tab ANC4
svy: tab SBA
svy: tab PNC


*******Prevalence of Continuum of Maternal Healthcare Utilization\KE_2022_DHS_04082026_1327_164971\KEIR8CDT

svy: proportion Continuum,  percent 
svy: tab Continuum, percent format (%9.1f)

*svy: tab Continuum, count col percent format (%9.2f) //weighted prevalence


******Table 1 Description of the population


svy: tab AgeCat, col count percent format(%9.1f)
svy: tab MaritalStatus , col count percent format(%9.1f)
svy: tab Educationlevel , col count percent format(%9.1f)
svy: tab Occupation , col count percent format(%9.1f)
svy: tab FamilySize , col count percent format(%9.1f)
svy: tab Woman_HH_head , col count percent format(%9.1f)
svy: tab WealthIndex , col count percent format(%9.1f)
svy: tab Birth_Order , col count percent format(%9.1f)
svy: tab Planned_pregnancy , col count percent format(%9.1f)
svy: tab Read_Newspaper , col count percent format(%9.1f)
svy: tab Watch_TV , col count percent format(%9.1f)
svy: tab Listen_radio , col count percent format(%9.1f)
svy: tab Residence , col count percent format(%9.1f)

****Test for Mutlicollinearity

gen complete = (Continuum==2)
label define complete 0 "No/Partial" 1 "Complete"
label values complete complete
melogit complete || v021:
estat icc


********Table 2 Bivariate analysis

svy: tab AgeCat Continuum, row count pearson  percent format (%9.2f)
svy: tab MaritalStatus Continuum, row count pearson  percent format (%9.2f)
svy: tab Educationlevel Continuum, row count pearson percent format (%9.2f)
svy: tab Occupation Continuum, row count pearson percent format (%9.2f)
svy: tab FamilySize Continuum, row count pearson percent format (%9.2f)
svy: tab Woman_HH_head Continuum, row count pearson percent format (%9.2f)
svy: tab WealthIndex Continuum, row count pearson percent format (%9.2f)
svy: tab Birth_Order Continuum, row count pearson percent format (%9.2f)
svy: tab Planned_pregnancy Continuum, row count pearson percent format (%9.2f)
svy: tab Read_Newspaper Continuum, row count pearson percent format (%9.2f)
svy: tab Watch_TV Continuum, row count pearson percent format (%9.2f)
svy: tab Listen_radio Continuum, row count pearson percent format (%9.2f)
svy: tab Residence Continuum, row count pearson percent format (%9.2f)


****Test for Multicollinearity using VIF


reg Continuum ///
    i.AgeCat ///
    i.MaritalStatus ///
    i.Educationlevel ///
    i.Occupation ///
    i.FamilySize ///
    i.Woman_HH_head ///
    i.WealthIndex ///
    i.Birth_Order ///
    i.Planned_pregnancy ///
    i.Read_Newspaper ///
    i.Watch_TV ///
    i.Listen_radio ///
    i.Residence
	
estat vif


***Multinomial Logistic Regression Model

estimates store m1

svy: mlogit Continuum i.AgeCat i.MaritalStatus i.Educationlevel ///
    i.Occupation i.FamilySize i.Woman_HH_head ///
    i.WealthIndex i.Birth_Order i.Planned_pregnancy ///
    i.Read_Newspaper i.Watch_TV i.Listen_radio i.Residence, ///
    baseoutcome(0) rrr

estimates store m1_rrr

ereturn list

