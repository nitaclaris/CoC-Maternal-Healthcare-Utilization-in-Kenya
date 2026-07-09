*PROJECT:		Socioeconomic and Sociodemographic Predictors of Continuum of Maternal Healthcare Utilization in Kenya: Evidence from the 2022 KDHS 


*PURPOSE: 		Multinomial Regression  Analysis

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


***************************

save Continuum_MHU_Clean_Final.dta,replace