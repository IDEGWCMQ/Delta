
use Dataset
tab VariantbyPCR
keep if VariantbyPCR=="Other"
gen CaseControl=1 if PCRresult==1
replace CaseControl=0 if PCRresult==0
label define CaseControl 1"PCR positive" 0"PCR negative"
label values CaseControl CaseControl
ccmatch Sex Age Nationality ReasonforPCRTesting WeekInterval, cc(CaseControl) id(id)
keep if match~=.
merge 1:1 id using Vaccine
drop if _merge==2
gen diff=PCRDate-ImmDate
gen Vaccination=1 if (diff>=14 & diff~=.)
replace Vaccination=0 if Vaccination==.
cc CaseControl Vaccination
bys CaseControl: summ Age if Vaccination~=., detail
tab AgeCat CaseControl if Vaccination~=., col 
tab Sex CaseControl if Vaccination~=., col 
tab Nationality CaseControl if Vaccination~=., col
tab ReasonforPCRTesting CaseControl if Vaccination~=., col
gen Natr2=1 if (Nationality==2 | Nationality==3 | Nationality==4 | Nationality==5 | Nationality==7)
replace Natr2=2 if (Nationality==1 | Nationality==6 | Nationality==8 | Nationality==9)
replace Natr2=3 if Natr==10
label define Natr2 1"Worker pop" 2"Urban pop" 3"Qatari"
label values Natr2 Natr2
gen Age2=1 if Age<50
replace Age2=2 if Age>=50
label define Age2 1"<50" 2">=50"
label values Age2 Age2
xi: logistic CaseControl i.Vaccination i.Sex i.Age2 i.Nationality i.ReasonforPCRTesting i.WeekInterval 
bys CaseControl: summ PCRDate, detail
save Dataset, replace






