select * from health_data.ocd_patient_dataset;

-- 1.count and percent of F vs M that have ocd and avg obsession score by Gender 

select count(Gender) as Female
from health_data.ocd_patient_dataset
where Gender ='Female';

select count(Gender) as Male
from health_data.ocd_patient_dataset
where Gender ='Male';

select Gender,
count(`Patient ID`) as Patient_Count,
round(avg(`Y-BOCS Score (Obsessions)`),2) as Obsession_Score
 from health_data.ocd_patient_dataset
 group by 1
 order by 2;
 
with data as(
select Gender,
count(`Patient ID`) as Patient_Count,
round(avg(`Y-BOCS Score (Obsessions)`),2) as Obsession_Score
 from health_data.ocd_patient_dataset
 group by 1
 order by 2
 )
 select 
 sum(case when Gender = 'Female' then Patient_Count else 0 end) as Count_Female,
  sum(case when Gender = 'Male' then Patient_Count else 0 end) as Count_Male,
  
   round(sum(case when Gender = 'Female' then Patient_Count else 0 end) /
   (sum(case when Gender = 'Female' then Patient_Count else 0 end) + 
   sum(case when Gender = 'Male' then Patient_Count else 0 end))* 100,2)
   as Pct_Female,
   round(sum(case when Gender = 'Male' then Patient_Count else 0 end) /
   (sum(case when Gender = 'Male' then Patient_Count else 0 end) + 
   sum(case when Gender = 'Female' then Patient_Count else 0 end))* 100,2)
   as Pct_Male
 from data;

-- 2.Count of patients by ethnicities and their respective avg obsession score

select Ethnicity,
count(`Patient ID`) as patient_count,
avg(`Y-BOCS Score (Obsessions)`) as Obsession_Score
from health_data.ocd_patient_dataset
group by 1
order by 2;

-- 3.Number of people gets ocd Month of Month

alter table health_data.ocd_patient_dataset
modify `OCD Diagnosis Date` date;

select date_format(`OCD Diagnosis Date`, '%Y-%m-01') as `date`,
-- `OCD Diagnosis Date`,
count(`Patient ID`) as Patient_count
from health_data.ocd_patient_dataset
group by 1
order by 1;

-- 4. What is the most common obsession type (count) and its respective avg obsession count

select `Obsession Type`,
count(`Patient ID`) as Patient_count,
round(avg(`Y-BOCS Score (Obsessions)`),2) Obsession_Score
from health_data.ocd_patient_dataset
group by 1
order by 2 desc; 

-- 5.What is the moct common Compulssion Type (count) and its respective avg obsession score

select `Compulsion Type`,
count(`Patient ID`) as Patient_count,
round(avg(`Y-BOCS Score (Obsessions)`),2) Obsession_Score
from health_data.ocd_patient_dataset
group by 1
order by 2 desc; 





