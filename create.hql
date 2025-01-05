CREATE EXTERNAL TABLE Dim_User (
id INT,
login STRING,
password STRING,
email STRING
)
PARTITIONED BY (access_rights STRING)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
     STORED AS COMMENT undefined
    ,STORED AS COMMENT undefined
LOCATION 'hdfs:///user/andb30/database/device';
CREATE TABLE Dim_Time (
id INT,
year INT,
month INT,
day INT,
hour INT,
minute INT
)
STORED AS PARQUET;
CREATE TABLE Dim_Report (
id INT,
id_user_reporting INT,
id_time_start INT,
id_time_end INT,
report_description STRING
)
STORED AS PARQUET;
CREATE TABLE Dim_Bug_report (
id INT,
id_user_reporting INT,
id_time_created INT,
bug_type STRING,
report_description STRING
)
STORED AS PARQUET;
CREATE TABLE Dim_Known_issue (
id INT,
id_user_reporting INT,
id_user_solving INT,
id_time_published INT,
id_time_resolved INT,
associated_bugs MAP<INT, INT>,
-- id_bug : id_time_associated
issue_description STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
COLLECTION ITEMS TERMINATED BY '$'
MAP KEYS TERMINATED BY '#'
STORED AS PARQUET;
CREATE TABLE Dim_Failure (
id INT,
id_time_start INT,
id_time_end INT,
failure_description STRING
)
STORED AS PARQUET;
CREATE TABLE FT_Report_result (
id_report INT,
id_device INT,
time_ping_ms INT
)
PARTITIONED BY (reported_state STRING)
STORED AS AVRO;
CREATE TABLE FT_Session (
id INT,
id_device INT,
id_user INT,
id_time_start INT,
id_time_end INT,
data_upload_kb DOUBLE,
data_download_kb DOUBLE,
failures ARRAY<INT> -- id_failure
)
CLUSTERED BY (id_time_start) INTO 10 BUCKETS
STORED AS AVRO;
SHOW TABLES;