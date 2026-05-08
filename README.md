# Cambium-Scheduled-Delivery-File-Processor

## Description

Cambium/TIDE is the vendor that FLDOE uses to process state testing. They have an API called *Scheduled Delivery* that outputs test scores nightly for any tests a districts students took that day to an SFTP server.
This project is a powershell script that processes those output files into something that can be automatically imported into a Student Information System (SIS).
This project was designed specifically for use with [Focus](https://focusschoolsoftware.com/) and will contain the File Parsers I have for use with the default File Groups  (see below) within the powershell script.

## Order of Events (What the Script Does)
> [!NOTE]
> References to folders will be done using the variables found in the script. For information on what these variables are, check the **Installation -> 3. Powershell Script** section of this README.

1. Check to see if **\$zipfile** exists. If so extract it's contents into **\$source**.
2. Make sure there are files located in **\$source**. If so continue, otherwise *exit*.
3. Go through each File Group, combine all files from **\$source** that match the group and output the resulting file to **\$dest**.
4. Check for any remaining files in **\$source** that do not belong to any File Group. If found create a folder inside **\$ungrouped** for todays date (yyyy-MM-dd) and move those files to that folder.
5. If **\$zipfile** exists and contains data append todays date to the end of it, and move it into **\$archive**.
6. Delete all files from **\$source** to prepare for next run.

## Usage
There are two ways to use this script.
1. Use windows *Task Schedular* to run the script nightly after the file is received, and before Focus tries to import the scores.
2. Either create a **\$zipfile** that you want run, or place the files you want processed inside of **\$source** and manually run the script (make sure that a **\$zipfile** does not exist if placing files inside of **\$source**.)

## Installation

### 1. Scheduled Delivery
> [!NOTE]
> See the [Scheduled Delivery Administrator Guide](Scheduled_Delivery_Administrator_Guide.pdf) for more information.

To setup new connections reach out to FloridaHelpDesk@cambiumassessment.com

To manage existing connections reach out to FloridaHelpDesk@cambiumassessment.com and have them add the *CRS API Dist Admin* role to the user in the [Florida Report System (FRS)](https://fl.reporting.cambiumast.com/) that you want to be able to manage what tests get sent to you nightly via SFTP.

### 2. SFTP
You will need a windows SFTP server in order for this project to work. Along with a user that is able to upload via SFTP to the server. This user and password must be given to Cambium for use in the Scheduled Delivery system.
They will connect to this user and setup a directory structure within the home folder that looks like this:

```bash
Cambium
├── Test
└── Prod
```
- *Test* folder is used during initial setup to make sure their SFTP connection is good.
- *Prod* folder is where the nightly sends will end up.

> [!NOTE]
> You may also need to get a list of ip addresses from cambium for your network firewall to be able to connect to the SFTP server.

### 3. Powershell Script

> [!IMPORTANT]
> **Variables are file locations**  
> Folder variables like **\$source** are pointing to the location of a file and by default are *relative* locations. So they start with ```.\``` If you are changing those make sure to leave this if using relative locations.

> [!NOTE]
> The version of powershell that comes installed on windows servers by default may not contain all the packages required to run the script.
> You may either need to install the latest version of powershell, or figure out the missing packages by googling the errors. (It's not pretty but it works). 

You will need to copy the [Process_Files.ps1](Process_Files.ps1) powershell script into the *Cambium/Prod* folder created by the Scheduled Delivery system in the SFTP server.

#### Check File & Folder Variables in File
Open the [Process_Files.ps1](Process_Files.ps1) that is within the *Cambium/Prod* folder and verify the **\$zipfile** variable is set to the location/name of the .zip file that Cambium will send you nightly. By default this is *.\<DISTRICT>_StudentData.zip* if it is not correct change it.

Update the other variables as desired to control where files are output when processing is completed or leave them as defaults. The folders will automatically be created inside the *Cambium/Prod* folder the first time the script is run.

|Variable|Default|Purpose|
|:---|:---|:---|
|\$source|.\Unzipped|This is where the .zip file will be extracted to, and where the script will look for files to process (for manual runs)|
|\$dest|.\Converted|Output folder where the processed (converted) files will be written to.|
|\$ungrouped|.\Ungrouped|Output folder to store any files that are not matched to any file groups. So they can be reviewed and configured later.|
|\$archive|.\Archive|Set Output folder for the archived .zip files.|

#### Configure File Groups
Tests files from cambium can have slightly different names at different times of the year do to testing windows or can be split across multiple files because of gradelevels. These files will need to be grouped together so that the system can output a single file for each test that has a consistent filename for Focus to import.

After the file and folder variables at the top of the [Process_Files.ps1](Process_Files.ps1) is a variable called **\$groupConfigs**. This variable is an array of objects that creates File Groups, which control how the script groups the files sent to you by Cambium.

Each object in the array must have 3 properties:
- **Pattern**: The string to look for in the filename. If the filename contains this string it will be considered part of this File Group and it's contents will be appended to the **OutputFile**.  
*Note: The match is case-insensitive.*
- **OutputFile**: The filename that the generated file for this group will have, that will end up in the **\$dest** folder.
- **columns**: The number of columns, starting from the first column, to extract from each file in the group.
  - This is because the number of columns in the files Cambium sends is not always the same. There are columns that are always in the files, that come first, so extracting just these allows us to ignore the columns that may or may not be in the file every time. Preventing issues in processing the File Group and importing into Focus.

> [!warning]
> ⚠️ It is very important that the **Pattern** string is unique for the files you want to group. It is possible, if you are not careful, for a file to end up in multiple groups and insert data into the incorrect tests in Focus. See comments in the example for a demonstration of the risk.

> [!warning]
> ⚠️ Changing the **columns** property of a File Group will require validating the importer within Focus. Changes to the number of columns in the file can break Focus imports.

**Example**:
```powershell
$groupConfigs = @(
	@{
		Pattern = "Algebra1EOC"
		OutputFile = "BST-Algebra.csv"
		columns = 23
	},
	@{
		Pattern = "GeometryEOC"
		OutputFile = "BST-Geometry.csv"
		columns = 25
	},
# -- Make Sure Patterns are Unique! -- 
# FAST Math is split by gradelevel because of the differing subdomains.
	@{
		Pattern = "Grade3FASTMathematics_PM3"
		OutputFile = "FAST-Math-PM3-03.csv"
		columns = 25
	},
	@{
		Pattern = "Grade4FASTMathematics_PM3"
		OutputFile = "FAST-Math-PM3-04.csv"
		columns = 24
	},
# - DANGER FAST K-2 Math has a similar filename to FAST Math
# Even though K-2 Math doesn't need to be split on gradelevel just using "FASTMathematics_PM1" as the Pattern would pull in all the Grade 3-8 math test files.
# Because of this K-2 FAST Math also needs to be split by Gradelevel.
	@{
		Pattern = "GradeKFASTMathematics_PM1"
		OutputFile = "FAST-STAR-Math-PM1-KG.csv"
		columns = 22
	}
# - This issue doesn't exist with FAST K-2 Reading because the filenames are different enough to have unique patterns.
)
```

In this example:
- any file containing *Algebra1EOC* will have it's first 23 columns appended to the *BST-Algebra.csv* file.
- any file containing *GeometryEOC* will have it's first 25 columns appended to the *BST-Geometry.csv* file.
- any file cintaining *Grade3FASTMathematics_PM3* will have it's first 25 columns appended to the *FAST-Math-PM3-03.csv* file.
- any file cintaining *Grade4FASTMathematics_PM3* will have it's first 24 columns appended to the *FAST-Math-PM3-04.csv* file.
- any file cintaining *GradeKFASTMathematics_PM1* will have it's first 22 columns appended to the *FAST-STAR-Math-PM1-KG.csv* file.
