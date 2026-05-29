SELECT
    student_data_source.{col_2} AS fleid
    ,student_data_source.{col_18} AS administration_date
    ,SUBSTRING(student_data_source.{col_15} FROM '(\d{4})-\d{2}') AS syear
    ,LEFT(RIGHT(TRIM(student_data_source.{col_10}),5),4) AS school
    ,LEFT(RIGHT(TRIM(student_data_source.{col_11}),3),2) AS district
    ,RIGHT(CONCAT('0',TRIM(student_data_source.{col_5})),2) AS gradelevel
    ,CASE
        WHEN student_data_source.filename ILIKE '%grade3%' THEN '03'
        WHEN student_data_source.filename ILIKE '%grade4%' THEN '04'
        WHEN student_data_source.filename ILIKE '%grade5%' THEN '05'
        WHEN student_data_source.filename ILIKE '%grade6%' THEN '06'
        WHEN student_data_source.filename ILIKE '%grade7%' THEN '07'
        WHEN student_data_source.filename ILIKE '%grade8%' THEN '08'
        WHEN student_data_source.filename ILIKE '%grade9%' THEN '09'
        WHEN student_data_source.filename ILIKE '%grade10%' THEN '10'
    END AS test_level
    ,CASE
        -- Check if the column contains anything that is NOT a digit (or is an empty string)
        WHEN student_data_source.{col_19} ~ '[^0-9]' OR student_data_source.{col_19} = '' THEN NULL
        -- If it contains only digits, output it
        ELSE student_data_source.{col_19}
    END AS scale_score
    ,CASE student_data_source.{col_20}
        WHEN 'Level 1' THEN '1'
        WHEN 'Level 2' THEN '2'
        WHEN 'Level 3' THEN '3'
        WHEN 'Level 4' THEN '4'
        WHEN 'Level 5' THEN '5'
        ELSE NULL
    END AS achievement_level
    ,CASE student_data_source.{col_22}
        WHEN 'Above the Standard' THEN '3'
        WHEN 'At/Near the Standard' THEN '2'
        WHEN 'Below the Standard' THEN '1'
        ELSE NULL
    END AS NUMBER_SENSE_AND_OPERATIONS
    ,CASE student_data_source.{col_23}
        WHEN 'Above the Standard' THEN '3'
        WHEN 'At/Near the Standard' THEN '2'
        WHEN 'Below the Standard' THEN '1'
        ELSE NULL
    END AS ALGEBRAIC_REASONING
    ,CASE student_data_source.{col_24}
        WHEN 'Above the Standard' THEN '3'
        WHEN 'At/Near the Standard' THEN '2'
        WHEN 'Below the Standard' THEN '1'
        ELSE NULL
    END AS GEOMETRIC_REASONING_DATA_ANALYSIS_AND_PROBABILITY
    ,CASE student_data_source.{col_19}
        WHEN 'Invalidated' THEN 'I'
        WHEN 'Insufficient to Score/No Response' THEN 'I'
    END AS test_status
    ,CASE student_data_source.{col_19}
        WHEN 'Invalidated' THEN '3'
        WHEN 'Insufficient to Score/No Response' THEN '2'
    END AS score_flag
FROM {source_file} AS student_data_source