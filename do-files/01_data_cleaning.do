PROJECT:		Socioeconomic and Sociodemographic Predictors of Continuum of Maternal Healthcare Utilization in Kenya: Evidence from the 2022 KDHS 

PURPOSE: 		Data Cleaning and Manipulation

AUTHOR:  		NITA CLARIS

CREATED: 		16 APR 2026


********************************************************************************

clear
clear matrix
set more off

set maxvar 10000

cd "C:\KEIR8CDT"

********************DATA CLEANING & MANIPULATION********************************
********************************************************************************

***Load the dataset

use KEIR8CFL.DTA

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

save Continuum_MHU_Clean_1.dta, replace

**********
