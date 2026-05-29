# Cambium TIDE Nightly Test Focus File Parsers

## Description

This folder contains all the Focus File Parsers for importing tests from the nightly Cambium extracts.
This document will explain the similarities between all the parsers and the reasons for some of the decisions that were made.

## File Parser Query Columns

### Columns that Exist in Every Parser

* **fleid/student\_id**: The students FLEID exists in all the Cambium extracts to this is what is used to match the students in Focus.
* **administration\_date**: Pulled from the *Test Completion Date* column that exists in all the Cambium extracts.
* **syear**: Pulled from the *Test Reason* column that exists in all the Cambium extracts.
* **custom\_2**: This is the School Administered field and the school number is extracted from the *Enrolled School* column that exists in all the Cambium extracts.
* **custom\_1**: This is the District Administered field and the district number is extracted from the *Enrolled District* column that exists in all the Cambium extracts.
* **gradelevel**: Pulled from the *Enrolled Grade* column that exists in all the Cambium extracts.

### For Assessments Where Students Can Test Above Their Gradelevel

* **testlevel**: Parsed from the name of the Cambium Extract file that was placed in the *Filename* column that was created when the [PowerShell script](../Process_Files.ps1) ran.

### For Assessments That Get Have a Test Status and Score Flag as Defined by FLDOE

* **test\_status**: Parsed from the *Scale Score* column in the Cambium Extracts. If the value of the column is *Invalidated* or Insufficient to Score/No Response then test\_status will be an I, otherwise it will be *NULL*.
* **score\_flag**: Parsed from the *Scale Score* column in the Cambium extracts. If the value of the column is *Invalidated* then score\_flag will be a 3, if the value of the column is *Insufficient to Score/No Response* then score\_flag will be a 2, otherwise it will be NULL.
  
> [!IMPORTANT]
> **Only Invalidations are Loaded**  
> There are values to represent a *completed* score but these are left out because the imports are set to **Insert Only** if we put the test_status of C and the score_flag of 1 then if a score was invalidated in a later Cambium file, after scores were entered by an earlier Cambium file, Focus would not import the new test_status or score_flag.
> Only loading these when a test is invalidated allows us to insert invalidations that happen after scores are initially released. These invalidations can then be processed and the invalid scores deleted by using the **Invalidated Tests - Passed Dates Cleanup** Managed Integration (will be added to repository soon).

## Test Score Columns
Most test parts are specific to the individual test but I would like to point out 2 that exist in a lot of File Parsers:
* **scale_score**: This score is parsed from the Cambium extract and will only output integers. So if "Invalidated" is in the Cambium file, it will be parsed by the File Parsers as *NULL*.
* **achievement_level**: This score is parsed from the Cambium extract to output the appropriate value of 1-5 or *NULL* if it's "Invalidated".