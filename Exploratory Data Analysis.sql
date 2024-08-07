-- Exploratory Data Analysis

select * from layoffs_staging2;

select max(total_laid_off), max(percentage_laid_off)
from layoffs_staging2;

select * 
from layoffs_staging2
where percentage_laid_off =1
order by funds_raised_millions desc ;

select country, sum(total_laid_off)
from layoffs_staging2
group by country
order by 2 desc;

select min(`date`), max(`date`)
from layoffs_staging2;

select industry, sum(total_laid_off)
from layoffs_staging2
group by industry
order by 2 desc;

select year(`date`), sum(total_laid_off)
from layoffs_staging2
group by year(`date`)
order by 2 desc;

select stage, sum(total_laid_off)
from layoffs_staging2
group by stage
order by 2 desc;

select company, sum(percentage_laid_off)
from layoffs_staging2
group by company
order by 2 desc;

select substring(`date`, 1,10) as `Month` , sum(total_laid_off) Sum_laid_off
from layoffs_staging2
where substring(`date`, 1,10) is not null
group by `Month`
order by 1 asc;

with Rolling_Total as
(
select substring(`date`, 1,10) as `Month` , sum(total_laid_off) as Sum_laid_off
from layoffs_staging2
where substring(`date`, 1,10) is not null
group by `Month`
order by 1 asc
) 
select `Month`, Sum_laid_off, sum(Sum_laid_off) over(order by`Month`) as Rolling_total
from Rolling_Total;

select company, year(`date`), sum(total_laid_off) Sum_Total
from layoffs_staging2
group by company, year(`date`)
order by company asc;	

with Company_Year (company, years, total_laid_off) as
(
select company, year(`date`), sum(total_laid_off) Sum_Total
from layoffs_staging2
group by company, year(`date`)
),
Company_Year_Rank as
(
select *, dense_rank() over(partition by years order by total_laid_off desc) as `Rank`
 from Company_Year
 where years is not null
)
select * from Company_Year_Rank
where `Rank` <= 5;