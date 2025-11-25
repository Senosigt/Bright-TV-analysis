
SELECT
  *
FROM
  "BRIGHT"."TV"."VIEWERSHIP";
  SELECT
  *
FROM
  "BRIGHT"."TV"."USERPROFILES";

  --CHECKING NULL VALUES
SELECT USERID
FROM
  "BRIGHT"."TV"."VIEWERSHIP"
  WHERE USERID IS NULL;
--CHECKING NULL VALUES
SELECT USERID
FROM
   "BRIGHT"."TV"."USERPROFILES"
  WHERE USERID IS NULL;
  --CHECKING NULL VALUES ON Gender
SELECT GENDER
FROM
  "BRIGHT"."TV"."USERPROFILES"
  WHERE GENDER IS NULL;
  --Checking all  channels
  SELECT DISTINCT CHANNEL2
FROM
  "BRIGHT"."TV"."VIEWERSHIP";
  --Checking names of provinces
  SELECT DISTINCT province
FROM
  "BRIGHT"."TV"."USERPROFILES";
  ----CHECKING NULL VALUES ON PROVINCE
  SELECT PROVINCE
FROM
  "BRIGHT"."TV"."USERPROFILES"
  WHERE PROVINCE IS NULL;
    ----CHECKING NULL VALUES ON Age
  SELECT AGE
FROM
  "BRIGHT"."TV"."USERPROFILES"
  WHERE AGE IS NULL;
    ----CHECKING NULL VALUES ON PROVINCE
  SELECT PROVINCE
FROM
  "BRIGHT"."TV"."USERPROFILES"
  WHERE PROVINCE IS NULL;
  --CHECKING NUMBER OF PROFILES REGISTERD
  SELECT
  COUNT (DISTINCT USERID) AS PROFILE_REGISTERED
FROM
  "BRIGHT"."TV"."USERPROFILES";
  -- counting NUMBER OF VIEWERS REGISTERED
  SELECT
  COUNT (DISTINCT USERID) AS VIEWERS_REGISTERED
FROM
  "BRIGHT"."TV"."VIEWERSHIP";
  --convert Recorddate column to timestamp, 
  --convert Recorddate column to South african timezone
  --to have date column and time column
  SELECT
    CAST (TRY_TO_TIMESTAMP_NTZ(recorddate2,'YYYY/MM/DD HH24:MI') AS timestamp) AS recorddate_original,
    CONVERT_TIMEZONE('UTC', 'Africa/Johannesburg', recorddate_original) AS CONVERTED_RECORDDATE,
    CONVERTED_RECORDDATE::DATE AS Recorddate,
    CONVERTED_RECORDDATE::TIME AS Recordtime
FROM
"BRIGHT"."TV"."VIEWERSHIP";
-- PROJECT 3 QUERY
SELECT
A.userid,
A.RACE,
B.CHANNEL2,
CAST (TRY_TO_TIMESTAMP_NTZ(recorddate2,'YYYY/MM/DD HH24:MI') AS timestamp) AS recorddate_original,
    CONVERT_TIMEZONE('UTC', 'Africa/Johannesburg', recorddate_original) AS CONVERTED_RECORDDATE,
    CONVERTED_RECORDDATE::DATE AS Recorddate,
    CONVERTED_RECORDDATE::TIME AS Recordtime,
    COALESCE(A.gender, 'None') AS gender,
    COALESCE(A.province, 'None') AS province,
    CASE
        WHEN A.age BETWEEN 0 AND 18 THEN '01 Junior'
        WHEN A.age BETWEEN 19 AND 30 THEN '02 Adults'
        WHEN A.age BETWEEN 31 AND 55 THEN '03 middle age adults'
        WHEN A.age > 55 THEN '04 Senior adults'
    END AS age_bucket,
    COUNT(DISTINCT A.USERID) AS total_profiles,
    COUNT(B.USERID) AS total_viewers,
    SUM(
        EXTRACT(HOUR FROM B.duration2) * 3600 +
        EXTRACT(MINUTE FROM B.duration2) * 60 +
        EXTRACT(SECOND FROM B.duration2)) AS total_viewing_seconds,
    AVG(EXTRACT(HOUR FROM B.duration2) * 3600 +
        EXTRACT(MINUTE FROM B.duration2) * 60 +
        EXTRACT(SECOND FROM B.duration2)) AS avg_viewing_seconds_per_viewer,
        TIME_FROM_PARTS((total_viewing_seconds / 3600),
        FLOOR((total_viewing_seconds % 3600) / 60),
        total_viewing_seconds % 60) AS Total_viewing_time,
    COUNT(DISTINCT B.channel2) AS unique_channels_accessed
FROM
    "BRIGHT"."TV"."USERPROFILES" AS A
FULL OUTER JOIN
    "BRIGHT"."TV"."VIEWERSHIP" AS B
    ON A.USERID = B.USERID
GROUP BY
    A.GENDER,A.RACE,A.PROVINCE,A.USERID,B.RECORDDATE2,A.age,B.channel2
ORDER BY
    total_viewing_seconds;
