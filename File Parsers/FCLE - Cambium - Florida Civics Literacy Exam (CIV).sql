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
    END AS raw_score
    ,CASE student_data_source.{col_21}
        WHEN 'Passed' THEN 'Y'
        ELSE 'N'
    END AS pass
FROM {source_file} AS student_data_source
WHERE COALESCE(student_data_source.{col_19}, '') <> ''
    AND student_data_source.{col_19} NOT IN (
    'Invalidated',
    'Insufficient to Score/No Response'
)