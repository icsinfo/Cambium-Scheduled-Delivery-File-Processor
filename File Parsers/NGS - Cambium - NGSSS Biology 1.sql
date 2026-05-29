SELECT
    student_data_source.{col_2} AS student_id
    ,student_data_source.{col_18} AS administration_date
    ,SUBSTRING(student_data_source.{col_15} FROM '(\d{4})-\d{2}') AS syear
    ,LEFT(RIGHT(TRIM(student_data_source.{col_10}),5),4) AS custom_2 --School Administered
    ,LEFT(RIGHT(TRIM(student_data_source.{col_11}),3),2) AS custom_1 --District Administered
    ,RIGHT(CONCAT('0',TRIM(student_data_source.{col_5})),2) AS gradelevel
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
    ,CASE student_data_source.{col_21}
        WHEN 'Above the Standard' THEN '3'
        WHEN 'At/Near the Standard' THEN '2'
        WHEN 'Below the Standard' THEN '1'
        ELSE NULL
    END AS MOLECULAR_AND_CELLULAR_BIOLOGY
    ,CASE student_data_source.{col_22}
        WHEN 'Above the Standard' THEN '3'
        WHEN 'At/Near the Standard' THEN '2'
        WHEN 'Below the Standard' THEN '1'
        ELSE NULL
    END AS CLASSIFICATION_HEREDITY_AND_EVOLUTION
    ,CASE student_data_source.{col_23}
        WHEN 'Above the Standard' THEN '3'
        WHEN 'At/Near the Standard' THEN '2'
        WHEN 'Below the Standard' THEN '1'
        ELSE NULL
    END AS ORGANISMS_POPULATIONS_AND_ECOSYSTEMS
    ,CASE student_data_source.{col_19}
        WHEN 'Invalidated' THEN 'I'
        WHEN 'Insufficient to Score/No Response' THEN 'I'
    END AS test_status
    ,CASE student_data_source.{col_19}
        WHEN 'Invalidated' THEN '3'
        WHEN 'Insufficient to Score/No Response' THEN '2'
    END AS score_flag
FROM {source_file} AS student_data_source