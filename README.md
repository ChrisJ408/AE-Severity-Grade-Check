# AE Severity Grade Check
DESCRIPTION:
This repository contains a real world, personal project, involving an edit check that was requested from me a while back to be programmed in SAS. A Data Manager requested to flag and output records of ongoing AE events of the same Event Term but with progressing increase in severity grade from the previous event (our proprietary EDC System at the time had some limitations, hence the requested edit check in SAS).

INPUT FILE:
- AE (Adverse Event) CRF dataset. For the purpose of this project, a sample raw AE csv file was input to serve as a sample dataset.

SPECS:
- Current/most recent Ongoing = "Yes"
- Previous Ongoing = "Yes"
- Serious = "Yes"
- Flag and output if severity grade increased from the previous recorded event of the same AE Event.

OUTPUT (XLXS File, not included)
- Output Vars: study_id, subject_id, ae_number, prev_aenumber, ae_event, severity, grade, prev_severity, prev_grade, start_date, prev_startdate,  serious, ongoing.

