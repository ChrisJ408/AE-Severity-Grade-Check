/*
AE_GradeChange_Chk.sas
     
CREATED BY: Christopher Ju
*/
     
/*** Import and Sort Raw AE CSV Dataset ***/
FILENAME REFFILE '/home/u64619502/ae_raw_sample.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	REPLACE
	OUT=WORK.AE_RAW;
	GETNAMES=YES;
RUN;

Proc sort data=AE_RAW out=AE1; by subject_id event_term start_date; run;



/*** Subset and Assign Severity Grade coding ***/
Data AE_Code (keep = study_id subject_id ae_number event_term start_date ongoing serious Grade severity);
	format Grade 8.;
	set AE1;
	if strip(upcase(ongoing))='YES' and strip(upcase(serious))='YES'
		then do;
			if strip(upcase(severity))="MILD" then Grade=1;
			else if strip(upcase(severity))="MODERATE" then Grade=2;
			else if strip(upcase(severity))="SEVERE" then Grade=3;
			output;
		end;
run;


/*** Subset for Ongoing AE records ***/
Data AE_Ongoing AE_Unique;
	set AE_Code;
	by subject_id event_term;
		if first.subject_id and last.subject_id then output AE_Unique;
		else output AE_Ongoing;
run;


/*** Establish relevant variables beore programming check ***/
Data AE_SevGrdChk;
	format prev_Grade 8. prev_date mmddyy10.;
	set AE_Ongoing;
	by subject_id event_term start_date;
	
	prev_Date=lag(start_date);
	if first.subject_id then prev_date= . ;
	
	prev_ae_number=lag(ae_number);
	if first.subject_id then prev_ae_number= 'NA' ;
	
	prev_severity=lag(severity);
	if first.subject_id then prev_severity= 'NA';

	prev_grade=lag(grade);
	if first.subject_id then prev_grade=grade; /*Done to avoid missing var and end up with a false positive */
	
run;

Data AE_SevGrdChk1;
	retain study_id 
		 subject_id 
		 ae_number
		 prev_ae_number
		 event_term
		 severity
		 grade
		 prev_severity
		 prev_grade
		 serious 
		 start_date
		 prev_date
		 ongoing; 
	set AE_SevGrdChk;
	
	if Grade - prev_Grade > 0 then output;
run;
