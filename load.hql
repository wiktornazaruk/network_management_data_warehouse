LOAD DATA LOCAL INPATH 'data/dim_user_admin.csv' OVERWRITE INTO TABLE Dim_User PARTITION (access_rights='admin');
LOAD DATA LOCAL INPATH 'data/dim_user_user.csv' OVERWRITE INTO TABLE Dim_User PARTITION (access_rights='user');
LOAD DATA LOCAL INPATH 'data/dim_user_moderator.csv' OVERWRITE INTO TABLE Dim_User PARTITION (access_rights='moderator');
LOAD DATA LOCAL INPATH 'data/dim_user_guest.csv' OVERWRITE INTO TABLE Dim_User PARTITION (access_rights='guest');

LOAD DATA LOCAL INPATH 'data/dim_device.csv' OVERWRITE INTO TABLE Dim_Device;

CREATE TABLE Dim_Report_txt (
    id INT,
    id_user_reporting INT,
    id_time_start INT,
    id_time_end INT,
    report_description STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE;
LOAD DATA LOCAL INPATH 'data/dim_report.csv' OVERWRITE INTO TABLE Dim_Report_txt;
INSERT INTO Dim_Report SELECT * FROM Dim_Report_txt;
DROP TABLE Dim_Report_txt;

CREATE TABLE Dim_Bug_report_txt (
    id INT,
    id_user_reporting INT,
    id_time_created INT,
    bug_type STRING,
    report_description STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE;
LOAD DATA LOCAL INPATH 'data/dim_bug_report.csv' OVERWRITE INTO TABLE Dim_Bug_report_txt;
INSERT INTO Dim_Bug_report SELECT * FROM Dim_Bug_report_txt;
DROP TABLE Dim_Bug_report_txt;


CREATE TABLE Dim_Known_issue_txt (
    id INT,
    id_user_reporting INT,
    id_user_solving INT,
    id_time_published INT,
    id_time_resolved INT,
    associated_bugs MAP<INT, INT>,
    issue_description STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
COLLECTION ITEMS TERMINATED BY '$'
MAP KEYS TERMINATED BY '#'
STORED AS TEXTFILE;

LOAD DATA LOCAL INPATH 'data/dim_known_issue.csv' OVERWRITE INTO TABLE Dim_Known_issue_txt;
INSERT INTO Dim_known_issue SELECT * FROM Dim_known_issue_txt;
DROP TABLE Dim_Known_issue_txt;



CREATE TABLE Dim_Failure_txt (
    id INT,
    start_timestamp INT,
    end_timestamp INT,
    failure_description STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE;
LOAD DATA LOCAL INPATH 'data/dim_failure.csv' OVERWRITE INTO TABLE Dim_Failure_txt;
INSERT INTO Dim_Failure SELECT * FROM Dim_Failure_txt;
DROP TABLE Dim_Failure_txt;


CREATE TABLE Dim_Time_txt (
    id INT,
    year INT,
    month INT,
    day INT,
    hour INT,
    minute INT
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

LOAD DATA LOCAL INPATH 'data/dim_time.csv' OVERWRITE INTO TABLE Dim_Time_txt;
INSERT INTO Dim_Time SELECT * FROM Dim_Time_txt;
DROP TABLE Dim_Time_txt;

set hive.exec.dynamic.partition=true;
set hive.exec.dynamic.partition.mode=nonstrict;
CREATE TABLE ft_report_result_txt (
    id_report INT,
    id_device INT,
    id_time_ping_ms INT,
    reported_state STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE;
LOAD DATA LOCAL INPATH 'data/ft_report_result.csv' OVERWRITE INTO TABLE ft_report_result_txt;
INSERT INTO ft_report_result PARTITION(reported_state)
SELECT
    id_report,
    id_device,
    id_time_ping_ms,
    reported_state
FROM ft_report_result_txt;
DROP TABLE ft_report_result_txt;

CREATE TABLE FT_Session_txt (
    id INT,
    id_device INT,
    id_user INT,
    id_time_start INT,
    id_time_end INT,
    data_upload_kb DOUBLE,
    data_download_kb DOUBLE,
    failures ARRAY<INT>
)
CLUSTERED BY (id_time_start) INTO 10 BUCKETS
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
COLLECTION ITEMS TERMINATED BY '$'
STORED AS TEXTFILE;
LOAD DATA LOCAL INPATH 'data/ft_session.csv' OVERWRITE INTO TABLE FT_Session_txt;

INSERT INTO ft_session SELECT * FROM ft_session_txt;
DROP TABLE ft_session_txt;
