create database FundRaised;
use FundRaised;

select * from Global_fund;

describe Global_fund;

-- find primary key
Show keys from Global_fund
where key_name = "Primary";

-- change column name
alter table global_fund
rename column `ï»¿Fund_ID` to fund_id;


-- find duplicates in fund_id 
select fund_id , count(*)
from global_fund
group by fund_id
having count(*)>1;


-- Check Null values
select * from global_fund
where fund_id is null;

-- make fund_id as primary key
Alter table global_fund
Add primary key (Fund_id);

Show keys from global_fund
where key_name ="Primary";


-- Check if column has null values or blanks

SELECT *
FROM Global_fund
WHERE Fund_Name IS NULL
   OR Fund_Name = ''
   OR Category IS NULL
   OR Amount_Raised_USD IS NULL;


select fundraising_goal_usd from global_fund
where fundraising_goal_usd is null or fundraising_goal_usd = " " ;

Alter table global_fund
modify fundraising_goal_usd decimal(15,2);

describe global_fund;

select Amount_raised_usd from global_fund
where amount_raised_usd is null or amount_raised_usd = " " ;

alter table global_fund
modify amount_raised_usd decimal(15,2);

select Average_donation_usd from global_fund
where average_donation_usd is null or average_donation_usd =" " ;

alter table global_fund
modify average_donation_usd decimal(10,2);

select * from global_fund;

Alter table Global_fund 
modify Top_donor_amount_usd decimal(10,2);

Select Marketing_spend_usd from global_fund
where Marketing_spend_usd is not null or Marketing_spend_usd = " " ;

Alter table Global_fund
modify Marketing_spend_usd decimal(12,2);

describe Global_fund;

alter table Global_fund
modify Media_coverage_score decimal(5,2),
modify Fund_transparency_score decimal(5,2),
modify Repeat_Donors_percentage decimal(5,2),
modify Fundraising_cost_percent decimal(5,2);

-- Covert start_date & End_date datatype text into Date Datatype
select Start_date,end_date from global_fund
limit 5;

-- start_date
select count(*) from global_fund
where start_date like "%/%";

select fund_id , start_date from global_fund
where start_date like "%/%";

update Global_fund
set start_date = str_to_date(start_date, "%m/%d/%Y")
where start_date like "%/%"
and fund_id = 0;

set SQl_Safe_Updates = 0;

-- Convert text -Proper date format of start_date
update Global_fund
set Start_date = str_to_date(start_date,"%m/%d/%Y" )
where Fund_id >0 
And Start_date like "%/%" ;

-- Convert text proper date format of end_date 
Update Global_fund
set End_date = str_to_date(end_date,"%m/%d/%Y")
where Fund_id >0
and end_date like "%/%" ;

select fund_id , end_date from global_fund
where end_date like "%/%";

update Global_fund
set end_date = str_to_date(end_date, "%m/%d/%Y")
where end_date like "%/%"
and fund_id = 0;

Alter table global_fund
modify Start_date date,
modify End_date date;

-- Covert Text into boolean data type
select distinct is_tax_exempt from global_fund;
select distinct mobile_Donations_allowed from global_fund;
select distinct External_funding_Received from Global_fund;

set sql_safe_updates = 0;

-- change datatype text into boolean
update Global_fund
set is_tax_exempt = if(is_tax_exempt = "yes",1,0);

Select * from Global_fund;

update Global_fund
set mobile_Donations_allowed = if(mobile_donations_allowed = "yes",1,0);

update Global_fund
set external_funding_Received = if(external_funding_received = "yes" , 1 ,0);

set sql_safe_updates = 1;

Alter table Global_fund
modify is_tax_exempt tinyint,
modify mobile_donations_allowed tinyint,
modify external_funding_received tinyint;

describe Global_fund;


--  KPI
-- Goal Achivement %
select count(Fund_id) as Total_Campaigns,
sum(Amount_Raised_usd) as Total_fund_raised,
sum(fundraising_Goal_usd) as Total_Goal,
round(sum(amount_raised_usd)/sum(fundraising_goal_usd) * 100,2) as Goal_Achivement_Percentage
from Global_fund;

Select * from Global_fund;

-- Funding Gap Analysis
Select fund_id,Fund_name,Amount_raised_usd,Fundraising_goal_usd ,
(Amount_raised_usd - Fundraising_goal_usd) as Funding_gap 
from global_fund
order by Funding_gap desc;

-- Top Performing Campaign
select Fund_id,Fund_name,Amount_raised_usd from global_fund
order by Amount_raised_usd desc
limit 10;

Select * from Global_fund;

-- Campaign Duration days
select Fund_id,fund_name,datediff(end_date,start_date) as Campaign_duration_days
from global_fund
order by Campaign_duration_days desc;

-- Success rate by Category
SELECT
 Category,
    COUNT(*) AS Total_Campaigns,
    SUM(IF(Status = 'Successful', 1, 0)) AS Successful_Campaigns,
    ROUND(
        SUM(IF(Status = 'Successful', 1, 0)) 
        / COUNT(*) * 100, 2
    ) AS Success_Rate_Percentage
FROM Global_fund
GROUP BY Category
ORDER BY Success_Rate_Percentage DESC;

-- Average Donation Analysis
SELECT 
    Category,
    ROUND(AVG(Average_Donation_USD), 2) AS Avg_Donation
FROM Global_fund
GROUP BY Category
ORDER BY Avg_Donation DESC;

-- Tax Exempt Impact Analysis
SELECT 
    Is_Tax_Exempt,
    COUNT(*) AS Campaign_Count,
    SUM(Amount_Raised_USD) AS Total_Raised
FROM Global_fund
GROUP BY Is_Tax_Exempt;

-- Business logic column
-- Goal Achivement
Select Fund_id ,Amount_raised_usd / fundraising_goal_usd  * 100 as Achivement_Percentage 
from Global_fund;

-- Toal Fund Raised by region
select Region , sum(amount_raised_usd) as Total_funds 
from global_fund
group by region
order by Total_funds desc;

-- Marketing ROI
select fund_name ,if(marketing_spend_usd is null or marketing_spend_usd = 0,null ,
amount_raised_usd / Marketing_spend_usd) as Marketing_ROI
from global_fund;

-- Organizer Experiance impact
SELECT 
    Organizer_Experience_Years,
    AVG(Amount_Raised_USD) AS Avg_Funds
FROM Global_fund
GROUP BY Organizer_Experience_Years
ORDER BY Organizer_Experience_Years;
-- Cost efficiency
SELECT 
    Fund_name,
    ROUND(
        marketing_spend_usd / NULLIF(amount_raised_usd,0) * 100,
        2
    ) AS Cost_Percentage
FROM Global_fund
ORDER BY Cost_Percentage;







