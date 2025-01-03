use nft;

select count(*) from pricedata;

select name, eth_price, usd_price, event_date from pricedata
  order by usd_price desc limit 5; 
  
select transaction_hash, usd_price, 
avg(usd_price) over(order by event_date  rows between 49 preceding and current row )
as moving_avg_usd
from pricedata;

select name, avg(usd_price) as average_price
from pricedata
group by name
order by name desc;

select dayofweek(event_date), count(*), avg(eth_price)
 from pricedata
 group by dayofweek(event_date)
 order by count(*);
 
 select concat(name,' was sold for $ ', round(usd_price,-3), ' to ', 
 buyer_address, ' from ', seller_address, ' on ', event_date) as summary
 from pricedata;
 
 create view 1919_purchases as
 select seller_address from pricedata
 where buyer_address = '0x1919db36ca2fa2e15f9000fd9cdc2edcf863e685' ;

select round(eth_price,-2) as buck,
count(*) as count,
rpad('', count(*), '*') as bar
from pricedata
group by buck
order by buck;

select name, max(eth_price) as price, 'Highest' as status
 from pricedata
 group by name 
   union
select name, min(eth_price) as price, 'Lowest' as status
 from pricedata
 group by name
 order by name; 
 
 select name, usd_price, mnth, yr, rnk
 from
 
 ( select 
 name, max(usd_price) as usd_price,
 monthname(event_date) as mnth, year(event_date) as yr, count(*) as count,
 dense_rank() over(partition by year(event_date), 
 monthname(event_date) order by count(*) desc ) as rnk
 from pricedata
 group by name, year(event_date), monthname(event_date) ) as tb
 where rnk = 1;
 
 select year(event_date) as yr, monthname(event_date) as mnth,
 round(sum(usd_price),-2) as sum_sales
 from pricedata
 group by monthname(event_date), year(event_date)
 order by monthname(event_date), year(event_date);

select count(*) as cnt
 from pricedata
  where  seller_address = '0x1919db36ca2fa2e15f9000fd9cdc2edcf863e685' or
        buyer_address = '0x1919db36ca2fa2e15f9000fd9cdc2edcf863e685';
        
create temporary table daily_avg
select event_date, usd_price, avg(usd_price)
over(partition by date(event_date))  as avg_day  
from pricedata;     
   
select *,
avg(usd_price) over(partition by date(event_date))  as new_avg_day  
from daily_avg
where usd_price > (0.9 * avg_day);   
   
   
 
 
 

 