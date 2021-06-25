	clear
	version 9.0
	/*	Name: primary analysis for Peirong's data
		Description: multivariable model to test for association between surgeon experience and biochemical recurrence following
		eye surgury. Plots adjusted 7-days predicted probability of freedom from SRI against surgeon experience */

	global work_dir     "C:\Users\jiju6002\data"

	* change directory
	cd "$work_dir\Stata_input"

	set more off

	global output_dir   "$work_dir\Stata_output"
	global filename     "predictive_learning_curve"
	global import_name  "$filename.csv"
	global output_img   "$output_dir/$filename.png"
	global output_data  "$output_dir/Stata_Output_Data.csv"

	* load deidentified data set for analysis

	import delimited using "$import_name"

	* create variables used in the model (will be manipulated later to plug in the mean values for all covariates)

	foreach v of varlist pbs_alu  {
		quietly g model`v' = `v'
		* obtain mean values of the covariates
		quietly sum model`v'
		scalar mean`v' = r(mean)
		}

	quietly centile number, c(33, 66)
	local k1 = r(c_1)
	local k2 = r(c_2)

	* create restricted cubic splines
	spbase number, gen(spnumber) knots(`k1' `k2' )

	* stset data
	stset recurrence, f(is_failure)

	* multivariable model, with survival times assumed to follow a log-logistic distribution; 
	* covariates are surgeon experiences, usage of drugs(PBS/ALU), complications
	* specify cluster option using surgeon, since patients treated by the same surgeon are not independent

	* modelpbs_alu
	* modelcataract modelbleeding modelother_complications
	* spnumber1 spnumber2 spnumber3
	* cluster(surgeon) 
	streg  ///
		number spnumber1 spnumber2 , dist(llog) cluster(surgeon)  nolog


	* calculate adjusted 7-days predicted recurrence-free probability

	* save out parameter from model (estimated by data), which is a constant for all patients
	scalar gamma = e(gamma)

	* set covariates to mean values

	foreach v of varlist pbs_alu  {
		quietly replace model`v' = scalar(mean`v')
		}

	* calculate the linear prediction and the standard error of the linear prediction
	predict xb, xb
	predict se, stdp

	* calculate predicted survival probability and 95% confidence intervals
	* obtain prediction for 7 days
	local time = 7
	g s = ( 1 + ( exp(-xb) * `time' ) ^ ( 1 / gamma ) ) ^ -1 
	g slb = ( 1 + ( exp(-xb + invnorm(0.975)*se) * `time' ) ^ ( 1 / gamma ) ) ^ -1 
	g sub = ( 1 + ( exp(-xb - invnorm(0.975)*se) * `time' ) ^ ( 1 / gamma ) ) ^ -1 

	* multiply by 100 to obtain estimates in percentages rather than proportions
	local vars s slb sub
	foreach v of local vars {
		quietly replace `v' = `v' * 100
		}

	* plot of predicted 7-days probability of freedom from biochemical recurrence against surgeon experience
	twoway (line s slb sub number, sort clpat(solid dash dash) clwidth(medthick thin thin) clcolor(gs0 gs5 gs5)), ///
		  ytitle(Probability of freedom from failure (%), margin(medium)) ylabel(0(10)100, angle(horizontal) nogrid) ///
			xtitle(Surgeon experience (cases), margin(medium)) xlabel(0(50)450) ///
			legend(off) scheme(s2mono) graphregion(fcolor(white)) 

	graph export "$output_img", as(png) replace

	export delimited using "$output_data",  replace
