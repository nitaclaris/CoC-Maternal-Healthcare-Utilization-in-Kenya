*PROJECT:		Socioeconomic and Sociodemographic Predictors of Continuum of Maternal Healthcare Utilization in Kenya: Evidence from the 2022 KDHS 


*PURPOSE: 		Bivariate  Analysis

*AUTHOR:  		NITA CLARIS

*CREATED: 		16 APR 2026


********************************************************************************

clear
clear matrix
set more off

set maxvar 10000

********************************************************************************

***Load the dataset

use Continuum_MHU_Clean_Final.dta

***Survey settings

svyset  v021 [pw=wt], strata (v022)


********************************************************************************
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



********************************************************************************


save Continuum_MHU_Clean_Final,replace

