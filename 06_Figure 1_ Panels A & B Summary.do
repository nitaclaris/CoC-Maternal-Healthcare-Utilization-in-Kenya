PROJECT:		Socioeconomic and Sociodemographic Predictors of Continuum of Maternal Healthcare Utilization in Kenya: Evidence from the 2022 KDHS 

PURPOSE: 		Fig1 : Maternal healthcare utilization and Continuum of Care Distribution

AUTHOR:  		NITA CLARIS

CREATED: 		17 APR 2026

*****************************************************************************
cls
clear
clear matrix
clear mata


set maxvar 10000


use Continuum_MHU_Clean_Final.dta


* ── STEP 1: Set up postfile to store results ─────────────────────────────────

tempfile results
postfile handle str40 indicator float est float lo float hi ///
    using `results', replace

* ANC4+
svy: proportion ANC4
matrix m = r(table)
post handle ("ANC 4+ contacts") ///
    (m[1,2]*100) (m[5,2]*100) (m[6,2]*100)

* SBA
svy: proportion SBA
matrix m = r(table)
post handle ("Skilled birth attendance") ///
    (m[1,2]*100) (m[5,2]*100) (m[6,2]*100)

* PNC
svy: proportion PNC
matrix m = r(table)
post handle ("Postnatal care within 48h") ///
    (m[1,2]*100) (m[5,2]*100) (m[6,2]*100)

postclose handle

* ── STEP 2: Load results and add order variable ───────────────────────────────

preserve
use `results', clear

gen order = .
replace order = 3 if indicator == "ANC 4+ contacts"
replace order = 2 if indicator == "Skilled birth attendance"
replace order = 1 if indicator == "Postnatal care within 48h"

* Verify data looks correct before plotting
list

* ── STEP 3: Draw Panel A ──────────────────────────────────────────────────────

twoway ///
    (bar est order, ///
        horizontal barwidth(0.6) ///
        color("29 158 117") base(0)) ///
    (rcap lo hi order, ///
        horizontal lcolor("8 80 65") lwidth(medthin)) ///
    (scatteri 3.5 2 "Panel A", ///
        msymbol(none) mlabformat("%s") mlabcolor(black) ///
        mlabsize(medium) mlabposition(0)) , ///
    ylabel(1 "Postnatal care within 48h" ///
           2 "Skilled birth attendance" ///
           3 "ANC 4+ contacts", ///
           angle(0) labsize(small) nogrid) ///
    xlabel(0(20)100, labsize(small) format(%2.0f)) ///
    xtitle("Coverage (%)", size(small)) ///
    ytitle("") ///
    xscale(range(0 110)) ///
    plotregion(fcolor(white) lcolor(white)) ///
    graphregion(fcolor(white) lcolor(white)) ///
    legend(off) ///
    note("Error bars represent 95% confidence intervals", size(vsmall)) ///
    name(panel_a, replace)
	
restore

* ── PANEL B: CoC distribution ────────────────────────────────────────────────

tempfile coc_results
postfile handle2 str20 category float est float lo float hi float order ///
    using `coc_results', replace

svy: proportion Continuum
matrix m = r(table)

* Post each category — check your tab Continuum output:
* column 1 = No CoC, column 2 = Partial, column 3 = Complete
post handle2 ("No CoC")       (m[1,1]*100) (m[5,1]*100) (m[6,1]*100) (1)
post handle2 ("Partial CoC")  (m[1,2]*100) (m[5,2]*100) (m[6,2]*100) (2)
post handle2 ("Complete CoC") (m[1,3]*100) (m[5,3]*100) (m[6,3]*100) (3)

postclose handle2

* ── Load CoC results and calculate stacking positions ────────────────────────

* After loading coc_results, replace order with a constant
use `coc_results', clear
sort order
gen cum_end   = sum(est)
gen cum_start = cum_end - est

* Add this line — forces all segments onto one bar
gen ypos = 1

twoway ///
    (rbar cum_start cum_end ypos if order==1, ///
        horizontal barwidth(0.5) color("163 45 45")) ///
    (rbar cum_start cum_end ypos if order==2, ///
        horizontal barwidth(0.5) color("239 159 39")) ///
    (rbar cum_start cum_end ypos if order==3, ///
        horizontal barwidth(0.5) color("15 110 86")) ///
   (scatteri 1.5 2 "Panel B", ///
        msymbol(none) mlabformat("%s") mlabcolor(black) ///
        mlabsize(medium) mlabposition(0)) , ///
    ylabel(1 " ", nogrid noticks) ///
    xlabel(0(20)100, labsize(small) format(%2.0f)) ///
    xtitle("Proportion (%)", size(small)) ///
    ytitle("") ///
    xscale(range(0 100)) ///
    yscale(range(0.5 1.5)) ///
    plotregion(fcolor(white) lcolor(white)) ///
    graphregion(fcolor(white) lcolor(white)) ///
    legend(order( ///
        1 "No CoC (2.7%, 95% CI: 2.4-3.0%)" ///
        2 "Partial CoC (60.8%, 95% CI: 59.3-62.2%)" ///
        3 "Complete CoC (36.6%, 95% CI: 35.1-38.0%)") ///
        size(vsmall) rows(3) position(6) ///
        region(lcolor(none))) ///
    name(panel_b, replace)

* ── Combine Panel A and Panel B ──────────────────────────────────────────────
graph combine panel_a panel_b, ///
    cols(1) ///
    rows(2) ///
    imargin(0 0 3 3) ///
    hole(2) ///
    title("Figure 1. Maternal healthcare utilization and continuum of care," ///
          "Kenya 2022 KDHS", ///
          size(small) justification(left)) ///
    note("Source: 2022 Kenya Demographic and Health Survey (KDHS)." ///
         "Estimates are survey-weighted. ANC = antenatal care;" ///
         "SBA = skilled birth attendance; PNC = postnatal care." ///
         "Error bars in Panel A represent 95% confidence intervals.", ///
         size(vsmall)) ///
    graphregion(fcolor(white) lcolor(white)) ///
    name(figure1, replace)
	
	
* ── Export ───────────────────────────────────────────────────────────────────

* TIFF at 300 DPI for most journals
graph export "Figure1_CoC_Kenya2022.tif", ///
    name(figure1) replace width(2400)

* Uncomment below for PDF alternative (BMC, PLOS ONE etc.)
* graph export "Figure1_CoC_Kenya2022.pdf", name(figure1) replace
