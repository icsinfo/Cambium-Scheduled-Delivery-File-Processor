# --- Set variable to the name of the .zip file received from Cambium
$zipfile = ".\<DISTRICT>_StudentData.zip"
# --- Set Source folder. This is where the .zip file will be extracted to, and where the script will look for files to process (for manual runs)
$source = ".\Unzipped"
# --- Set Output folder for the processed (converted) files.
$dest = ".\Converted"
# --- Set Output folder to store any files that were not in groups. So they can be reviewed and configured later.
$ungrouped = ".\Ungrouped"
# --- Set Output folder for the archived .zip files.
$archive = ".\Archive"

# --- Configure groups of test files based on filename, and where they should be output
$groupConfigs = @(
	@{
		Pattern = "Algebra1EOC"
		OutputFile = "BST-Algebra.csv"
		columns = 23
	},
	@{
		Pattern = "GeometryEOC"
		OutputFile = "BST-Geometry.csv"
		columns = 23
	},
	@{
		Pattern = "Biology1EOC"
		OutputFile = "NGS-Biology.csv"
		columns = 23
	},
	@{
		Pattern = "CivicsEOC"
		OutputFile = "NGS-Civics.csv"
		columns = 24
	},
	@{
		Pattern = "U.S.HistoryEOC"
		OutputFile = "NGS-History.csv"
		columns = 23
	},
	@{
		Pattern = "FloridaCivicLiteracyExam"
		OutputFile = "FCLE.csv"
		columns = 25
	},
	@{
		Pattern = "FASTELAReadingRetake"
		OutputFile = "FAST-ELA-Retake.csv"
		columns = 23
	},
	@{
		Pattern = "FASTELAReading_PM1"
		OutputFile = "FAST-ELA-PM1.csv"
		columns = 24
	},
	@{
		Pattern = "FASTELAReading_PM2"
		OutputFile = "FAST-ELA-PM2.csv"
		columns = 24
	},
	@{
		Pattern = "FASTELAReading_PM3"
		OutputFile = "FAST-ELA-PM3.csv"
		columns = 24
	},
	@{
		Pattern = "Grade3FASTMathematics_PM1"
		OutputFile = "FAST-Math-PM1-03.csv"
		columns = 25
	},
	@{
		Pattern = "Grade4FASTMathematics_PM1"
		OutputFile = "FAST-Math-PM1-04.csv"
		columns = 24
	},
	@{
		Pattern = "Grade5FASTMathematics_PM1"
		OutputFile = "FAST-Math-PM1-05.csv"
		columns = 25
	},
	@{
		Pattern = "Grade6FASTMathematics_PM1"
		OutputFile = "FAST-Math-PM1-06.csv"
		columns = 24
	},
	@{
		Pattern = "Grade7FASTMathematics_PM1"
		OutputFile = "FAST-Math-PM1-07.csv"
		columns = 25
	},
	@{
		Pattern = "Grade8FASTMathematics_PM1"
		OutputFile = "FAST-Math-PM1-08.csv"
		columns = 25
	},
	@{
		Pattern = "Grade3FASTMathematics_PM2"
		OutputFile = "FAST-Math-PM2-03.csv"
		columns = 25
	},
	@{
		Pattern = "Grade4FASTMathematics_PM2"
		OutputFile = "FAST-Math-PM2-04.csv"
		columns = 24
	},
	@{
		Pattern = "Grade5FASTMathematics_PM2"
		OutputFile = "FAST-Math-PM2-05.csv"
		columns = 25
	},
	@{
		Pattern = "Grade6FASTMathematics_PM2"
		OutputFile = "FAST-Math-PM2-06.csv"
		columns = 24
	},
	@{
		Pattern = "Grade7FASTMathematics_PM2"
		OutputFile = "FAST-Math-PM2-07.csv"
		columns = 25
	},
	@{
		Pattern = "Grade8FASTMathematics_PM2"
		OutputFile = "FAST-Math-PM2-08.csv"
		columns = 25
	},
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
	@{
		Pattern = "Grade5FASTMathematics_PM3"
		OutputFile = "FAST-Math-PM3-05.csv"
		columns = 25
	},
	@{
		Pattern = "Grade6FASTMathematics_PM3"
		OutputFile = "FAST-Math-PM3-06.csv"
		columns = 24
	},
	@{
		Pattern = "Grade7FASTMathematics_PM3"
		OutputFile = "FAST-Math-PM3-07.csv"
		columns = 25
	},
	@{
		Pattern = "Grade8FASTMathematics_PM3"
		OutputFile = "FAST-Math-PM3-08.csv"
		columns = 25
	},
	@{
		Pattern = "GradeKFASTMathematics_PM1"
		OutputFile = "FAST-STAR-Math-PM1-KG.csv"
		columns = 22
	},
	@{
		Pattern = "Grade1FASTMathematics_PM1"
		OutputFile = "FAST-STAR-Math-PM1-01.csv"
		columns = 22
	},
	@{
		Pattern = "Grade2FASTMathematics_PM1"
		OutputFile = "FAST-STAR-Math-PM1-02.csv"
		columns = 22
	},
	@{
		Pattern = "GradeKFASTMathematics_PM2"
		OutputFile = "FAST-STAR-Math-PM2-KG.csv"
		columns = 22
	},
	@{
		Pattern = "Grade1FASTMathematics_PM2"
		OutputFile = "FAST-STAR-Math-PM2-01.csv"
		columns = 22
	},
	@{
		Pattern = "Grade2FASTMathematics_PM2"
		OutputFile = "FAST-STAR-Math-PM2-02.csv"
		columns = 22
	},
	@{
		Pattern = "GradeKFASTMathematics_PM3"
		OutputFile = "FAST-STAR-Math-PM3-KG.csv"
		columns = 22
	},
	@{
		Pattern = "Grade1FASTMathematics_PM3"
		OutputFile = "FAST-STAR-Math-PM3-01.csv"
		columns = 22
	},
	@{
		Pattern = "Grade2FASTMathematics_PM3"
		OutputFile = "FAST-STAR-Math-PM3-02.csv"
		columns = 22
	},
	@{
		Pattern = "FASTReading_PM1"
		OutputFile = "FAST-STAR-Read-PM1.csv"
		columns = 22
	},
	@{
		Pattern = "FASTReading_PM2"
		OutputFile = "FAST-STAR-Read-PM2.csv"
		columns = 22
	},
	@{
		Pattern = "FASTReading_PM3"
		OutputFile = "FAST-STAR-Read-PM3.csv"
		columns = 22
	},
	@{
		Pattern = "FASTEarlyLiteracy_PM1"
		OutputFile = "FAST-STAR-SEL-PM1.csv"
		columns = 22
	},
	@{
		Pattern = "FASTEarlyLiteracy_PM2"
		OutputFile = "FAST-STAR-SEL-PM2.csv"
		columns = 22
	},
	@{
		Pattern = "FASTEarlyLiteracy_PM3"
		OutputFile = "FAST-STAR-SEL-PM3.csv"
		columns = 22
	},
	@{
		Pattern = "Science"
		OutputFile = "NGS-Science.csv"
		columns = 24
	}
)

Write-Host "Begin processing test score files." -BackgroundColor Cyan -ForegroundColor Black
Write-Host "Looking for Zip file..." -ForegroundColor Cyan -NoNewline

# Ensure source exists
if (-not (Test-Path $source)) { New-Item -ItemType Directory -Path $source | Out-Null }
# Ensure default destination exists
if (-not (Test-Path $dest)) { New-Item -ItemType Directory -Path $dest | Out-Null }
# Ensure destination for files not in a group exists
if (-not (Test-Path $ungrouped)) { New-Item -ItemType Directory -Path $ungrouped | Out-Null }
# Ensure destination for Archived .zip files exists
if (-not (Test-Path $archive)) { New-Item -ItemType Directory -Path $archive | Out-Null }
# Unzip file if it exists, otherwise check for previously unzipped files
if (Test-Path $zipfile) {
	Write-Host "Found: Unzipping '$zipfile'..." -ForegroundColor Cyan -NoNewline
	
	Expand-Archive -Path $zipfile -DestinationPath .\Unzipped -Force
	
	Write-Host " Done" -ForegroundColor Green
	
	Write-Host "Making sure '$zipfile' was not empty..." -ForegroundColor Cyan -NoNewline
	
	if ((Get-ChildItem -Path $source -File).Count -eq 0) {
		Write-Host "STOP: '$zipfile' was empty, nothing to process." -ForegroundColor Red
		return
	}
	
	Write-Host "Files found to process." -ForegroundColor Green
} else {
	Write-Host "No Zip Found, checking for previous files..." -ForegroundColor Yellow -NoNewline
	
	if ((Get-ChildItem -Path $source -File).Count -eq 0) {
		Write-Host "STOP: No previous files to process." -ForegroundColor Red
		return
	}
	
	Write-Host "Previous files found: " -ForegroundColor Cyan -NoNewline
	Write-Host "Continue with old files." -ForegroundColor Green
}

# --- Function generate Unique Headers ---
function Get-UniqueHeaders {
	param ($Path, $Columns)
	
	# Get the raw headers Import ONLY the first row, using-NoHeader
	$firstRowObj = Import-Excel -Path $Path -NoHeader -StartRow 1 -EndRow 1 -EndColumn $Columns
	if (-not $firstRowObj) { return $null }

	# Extract values from first row to get an array of header names
	# Sort by default Property names (P1, P2) to keep columns in correct order
	$rawHeaders = $firstRowObj.PSObject.Properties |
		Sort-Object { [int]($_.Name -replace 'P','') } |
		Select-Object -ExpandProperty Value
		
	# --- DEDUPLICATION LOGIC ---
	$headerCounts = @{}
	$uniqueHeaders = @()
	
	foreach ($header in $rawHeaders) {
		if ($headerCounts.ContainsKey($header)) {
			$headerCounts[$header]++
			$uniqueHeaders += "$header$($headerCounts[$header])"
		} else {
			$headerCounts[$header] = 0 # Initialize count
			$uniqueHeaders += $header
		}
	}
	return $uniqueHeaders
}

# Put all files into a list so we can keep track of which ones have been processed
$allFiles = [System.Collections.ArrayList]@(Get-ChildItem -Path $source -Filter *.xlsx)

# --- PROCESS CONFIGURED GROUPS ---
foreach ($config in $groupConfigs) {
	Write-Host "Processing Group: '$($config.Pattern)'" -BackgroundColor Cyan -ForegroundColor Black -NoNewline
	
	# Filter complete file list for matches
	$matches = $allFiles | Where-Object { $_.Name -match $config.Pattern}
	
	if ($matches) {
		$outFile = "$dest\$($config.OutputFile)"
		$outDir = Split-Path -Path $outFile -Parent
		
		Write-Host " -> '$outFile'" -BackgroundColor Cyan -ForegroundColor Black
		
		# Make sure output directory exists
		if (-not (Test-Path $outDir)) { New-Item -ItemType Directory -Path $outDir | Out-Null }
		
		# Clean up previous run if exists
		if (Test-Path $outFile) { Remove-Item $outFile }
		
		# Get headers from the first matching file
		$masterHeaders = Get-UniqueHeaders -Path $matches[0].FullName -Columns $config.columns
		
		foreach ($file in $matches) {
			Write-Host " Merging $($file.Name)..." -NoNewline
			
			Import-Excel -Path $file.FullName -StartRow 2 -EndColumn $config.columns -HeaderName $masterHeaders |
			#Import-Excel -Path $file.FullName -NoHeader -StartRow 2 |
				Select-Object *, @{Name='filename'; Expression={$file.Name}} |
				Export-Csv -Path $outFile -NoTypeInformation -Append -Force
			
			Write-Host " Done." -ForegroundColor Green
			
			# Remove from list of all files
			$allFiles.Remove($file)
		}
	} else {
		Write-Host " No Files in Group, Skipping..." -ForegroundColor Yellow -NoNewline
		Write-Host " Done." -ForegroundColor Green
	}
}

# --- Process any files that were not in a Group
if ($allFiles.Count -gt 0) {
	Write-Host "`nMoving remaining $($allFiles.Count) ungrouped files into folder for future processing..." -BackgroundColor Cyan -ForegroundColor Black
	# Create folder in ungrouped location to store todays ungrouped files
	$ungroupedOutput = $ungrouped + "\" + (Get-Date -Format "yyyy-MM-dd")
	if (-not (Test-Path $ungroupedOutput)) { New-Item -ItemType Directory -Path $ungroupedOutput | Out-Null }
	
	foreach ($file in $allFiles) {
		Write-Host " Moving $($file.Name)..." -NoNewline
		Move-Item -Path $file.FullName -Destination $ungroupedOutput
		Write-Host " Done." -ForegroundColor Green
	}
}

#If zipfile exists, append date to it
if (Test-Path $zipfile) {
	Write-Host "All Files Written, archiving .zip file..." -BackgroundColor Cyan -ForegroundColor Black

	Get-Item $zipfile | Rename-Item -NewName { $_.BaseName + "_" + (Get-Date -Format "yyyy-MM-dd") + $_.Extension } -PassThru |
		Move-Item -Destination $archive
}

# Delete the unzipped Files
Write-Host "Deleting un-zipped files..." -BackgroundColor Cyan -ForegroundColor Black

Get-ChildItem -Path ($source + "\*") -File | Remove-Item

Write-Host "All test files processed." -BackgroundColor Green -ForegroundColor Black
