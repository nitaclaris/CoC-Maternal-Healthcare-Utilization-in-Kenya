*PROJECT:		Socioeconomic and Sociodemographic Predictors of Continuum of Maternal Healthcare Utilization in Kenya: Evidence from the 2022 KDHS 


*PURPOSE: 		Descriptive Statistics

*AUTHOR:  		NITA CLARIS

*CREATED: 		16 APR 2026


********************************************************************************

clear
clear matrix
set more off

set maxvar 10000

********************************************************************************

***Load the dataset

use Continuum_MHU_Clean_2.dta

***Survey settings

svyset  v021 [pw=wt], strata (v022)

******************************DESCRIPTIVE STATISTICS****************************

**Proportions in each service 

svy: tab ANC4
svy: tab SBA
svy: tab PNC


*******Prevalence of Continuum of Maternal Healthcare Utilization

svy: proportion Continuum,  percent 
svy: tab Continuum, percent format (%9.1f)


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

*******************************************

save Continuum_MHU_Clean_Final.dta,replace
