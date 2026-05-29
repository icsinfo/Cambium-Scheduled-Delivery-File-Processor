SELECT
	student_data_source.{col_2} AS fleid
	,student_data_source.{col_18} AS administration_date
	,SUBSTRING(student_data_source.{col_15} FROM '(\d{4})-\d{2}') AS syear
	,LEFT(RIGHT(TRIM(student_data_source.{col_10}),5),4) AS school
	,LEFT(RIGHT(TRIM(student_data_source.{col_11}),3),2) AS district
	,CASE
		WHEN student_data_source.{col_5} ILIKE 'K%' THEN 'KG'
		ELSE RIGHT(CONCAT('0',TRIM(student_data_source.{col_5})),2)
	END AS gradelevel
	,CASE
		WHEN student_data_source.filename ILIKE '%gradeK%' THEN 'KG'
		WHEN student_data_source.filename ILIKE '%grade1%' THEN '01'
		WHEN student_data_source.filename ILIKE '%grade2%' THEN '02'
	END AS testlevel
	,CASE
		-- Check if the column contains anything that is NOT a digit (or is an empty string)
		WHEN student_data_source.{col_19} ~ '[^0-9]' OR student_data_source.{col_19} = '' THEN NULL
		-- If it contains only digits, output it
		ELSE student_data_source.{col_19}
	END AS FAST_Equivalent_scale_score
	,CASE
		-- Check if the column contains anything that is NOT a digit (or is an empty string)
		WHEN student_data_source.{col_20} ~ '[^0-9]' OR student_data_source.{col_20} = '' THEN NULL
		-- If it contains only digits, output it
		ELSE student_data_source.{col_20}
	END AS unified_scale_score
	,CASE student_data_source.{col_22}
		WHEN 'Level 1' THEN '1'
		WHEN 'Level 2' THEN '2'
		WHEN 'Level 3' THEN '3'
		WHEN 'Level 4' THEN '4'
		WHEN 'Level 5' THEN '5'
		ELSE NULL
	END AS achievement_level
FROM {source_file} AS student_data_source
WHERE student_data_source.{col_19} NOT IN (
	'Invalidated',
	'Insufficient to Score/No Response'
)