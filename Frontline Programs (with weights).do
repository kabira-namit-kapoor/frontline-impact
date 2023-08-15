
********************************************************************************
* Multiple Select (with weights)
********************************************************************************

capture program drop w_select_mul
program w_select_mul
	  	   
qui count if !(missing($mr))
local N `r(N)'
if(`r(N)' > 0){  
	   
local mr2 : variable label ${mr}

putdocx paragraph , font(,14) halign(center) style(Heading2)
putdocx text ("`mr2'"), bold underline

putdocx paragraph
putdocx text ("Number of valid observations = `N'")

	* table
	foreach v of varlist $ml {
		replace `v' = `v' * 100
	}
	
	table () () [aw=sample_wt], stat(mean $ml) nformat(%9.1f)
	collect style putdocx, layout(autofitcontents)
	putdocx collect 
	
		foreach v of varlist $ml {
		replace `v' = `v' / 100
	}

	mrgraph hbar $ml [aw=sample_wt], //// 
	title("`mr2'", size(small) span) /// 
	subtitle("Number of observations = `N'", size(small)) ///
	stat(column) include ///
	blabel(bar, format(%9.1f) pos(out) size(vsmall))  ///
	`graphopts' ///
	ytitle("Percent", height(5)) ylabel(0(20)100) intensity(50) legend(pos(6) row(1))
	graph export "${mr}.png", as(png) replace 
	
	putdocx paragraph, halign(center)
	putdocx image "$mr.png"
	erase "$mr.png"
	putdocx pagebreak
	
	capture macro drop ml mr mr2

}


end	





********************************************************************************
* Integer (with weights)
********************************************************************************

cap program drop w_integer
program w_integer
syntax varlist(min=1 numeric) 

local check : word 1 of `varlist'

qui count if !(missing(`check'))
qui local N `r(N)'
if `N' > 0 {	
 
putdocx paragraph , font(,14) halign(center) style(Heading2)
putdocx text ("Table of Means"), bold underline
putdocx paragraph
putdocx text ("Number of valid observations = `N'") 

table () () [aw=sample_wt], stat(mean `varlist') nformat(%9.1f)
collect style putdocx, layout(autofitcontents)
putdocx collect 

}
end





********************************************************************************
* Select one (with weights)
********************************************************************************

cap program drop w_select_one
program w_select_one
syntax varlist

qui count if !(missing(`varlist'))
local N `r(N)'
if(`r(N)' > 0){  

putdocx paragraph , font(,14) halign(center) style(Heading2)
putdocx text ("`: var la `varlist''"), bold underline	
putdocx paragraph
putdocx text ("Number of valid observations = `N'")
	 
table	(`varlist') [aw = sample_wt], statistic(freq) statistic(percent) nformat(%9.1f percent)
collect label dim `varlist' 	"Responses", modify

/*
Need to check this bit of code because it isn't working
collect label dim freq 			"Simple frequencies", modify
collect label dim percent 		"Weighted percentages", modify
*/

collect style putdocx, layout(autofitcontents)
putdocx collect

graph hbar (percent) [aw = sample_wt], over(`varlist', label(labsize(small))) title("`: var la `varlist''", size(medsmall)) subtitle("Number of observations = `N'", size(small) ) ///
	blabel(bar, format(%9.1f)) ytitle("Percent", height(5)) intensity(50) ylabel(0(20)100) 
	graph export `varlist'.png, as(png) replace 

	putdocx paragraph, halign(center)
	putdocx image `varlist'.png
	erase `varlist'.png
	putdocx pagebreak
}
end

