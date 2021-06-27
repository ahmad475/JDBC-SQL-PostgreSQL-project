SET search_path TO A2;
-- Add below your SQL statements. 
-- For each of the queries below, your final statement should populate the respective answer table (queryX) with the correct tuples. It should look something like:
-- INSERT INTO queryX (SELECT … <complete your SQL query here> …)
-- where X is the correct index [1, …,10].
-- You can create intermediate views (as needed). Remember to drop these views after you have populated the result tables query1, query2, ...
-- You can use the "\i a2.sql" command in psql to execute the SQL commands in this file.
-- Good Luck!
----------------------------------------------------------------
--Query 1 statements



INSERT INTO query1(select p.pname as pname, co.cname as cname, t.tname as tname 
from player p, tournament t, champion c, country co
where p.pid = c.pid AND t.tid = c.tid and t.cid = p.cid
and co.cid = p.cid
order by p.pname asc) ;

 


----------------------------------------------------------------

--Query 2 statements

DROP VIEW IF EXISTS s1 CASCADE;


create view s1 as
select t.tid as tid, sum(c.capacity)as sum1
from court c, tournament t
where t.tid = c.tid
group by t.tid ;

INSERT INTO query2(
select t.tname as tname, max(s1.sum1)as totalcapacity 
from s1, tournament t
where s1.tid = t.tid
group by t.tname
order by t.tname asc);

DROP VIEW IF EXISTS s1 CASCADE;

--INSERT INTO query2

----------------------------------------------------------------
--Query 3 statements

-- WHETHER TO USE MAX OR MIN IN GLOBAL RANK???
DROP VIEW IF EXISTS p1 CASCADE;
DROP VIEW IF EXISTS p2 CASCADE;
DROP VIEW IF EXISTS p3 CASCADE;

create view p1 as
select *
from player p, event e
where p.pid = e.winid or p.pid = e.lossid;

create view p2 as
select *
from player p, event e
where p.pid = e.winid or p.pid = e.lossid;

create view p3 as
select p1.pid as p1id, p1.pname as p1name,p2.pid as p2id, p2.pname as p2name, max(p2.globalrank)
from p1,p2
where p1.winid = p2.winid and p1.lossid = p2.lossid
and p1.pid <> p2.pid
group by p1.pid,p1.pname,p2.pid,p2.pname;


INSERT INTO query3 (select p3.p1id as p1id, p3.p1name as p1name, p3.p2id as p2id, p3.p2name as p2name
from p3
order by p1name asc);


DROP VIEW IF EXISTS p1 CASCADE;
DROP VIEW IF EXISTS p2 CASCADE;
DROP VIEW IF EXISTS p3 CASCADE;



--INSERT INTO query3
----------------------------------------------------------------


--Query 4 statements
--INSERT INTO query4


----------------------------------------------------------------
--Query 5 statements
--INSERT INTO query5

DROP VIEW IF EXISTS y1 CASCADE;

create view y1 as
select p.pid as pid , p.pname as pname , avg(r.wins) as avgwins
from player p, record r
where p.pid =  r.pid and r.year>=2011 and r.year<=2014
group by p.pid
order by avgwins desc;

INSERT INTO query5(
select y1.pid as pid, y1.pname as pname, 
y1.avgwins as avgwins
from y1
limit 10);

DROP VIEW IF EXISTS y1 CASCADE;
----------------------------------------------------------------
--Query 6 statements
--INSERT INTO query6
DROP VIEW IF EXISTS y2011 CASCADE;
DROP VIEW IF EXISTS y2012 CASCADE;
DROP VIEW IF EXISTS y2013 CASCADE;
DROP VIEW IF EXISTS y2014 CASCADE;

create view y2011 as
select p.pid as pid , p.pname as pname , r.wins as wins
from player p, record r
where p.pid =r.pid and r.year=2011;

create view y2012 as
select p.pid as pid , p.pname as pname , r.wins as wins
from player p, record r
where p.pid =r.pid and r.year=2012;


create view y2013 as
select p.pid as pid , p.pname as pname , r.wins as wins
from player p, record r
where p.pid =r.pid and r.year=2013;

create view y2014 as
select p.pid as pid , p.pname as pname , r.wins as wins
from player p, record r
where p.pid =r.pid and r.year=2014;


INSERT INTO query6(
select y2011.pid as pid, y2011.pname as pname 
from y2011,y2012,y2013,y2014
where y2011.wins<y2012.wins and y2012.wins<y2013.wins and  y2013.wins<y2014.wins and y2011.pid=y2012.pid and y2012.pid=y2013.pid and  y2013.pid=y2014.pid
order by y2011.pname asc);


DROP VIEW IF EXISTS y2011 CASCADE;
DROP VIEW IF EXISTS y2012 CASCADE;
DROP VIEW IF EXISTS y2013 CASCADE;
DROP VIEW IF EXISTS y2014 CASCADE;


----------------------------------------------------------------
--Query 7 statements
--INSERT INTO query7

DROP VIEW IF EXISTS v1 CASCADE;

create view v1 as
select c1.pid as pid , c1.year as year
from champion c1, champion c2
where c1.pid=c2.pid and c1.tid <> c2.tid and c1.year = c2.year;


INSERT INTO query7(
select p.pname as pname, v1.year as year
from v1, player p
where v1.pid = p.pid
order by pname desc, year desc);


DROP VIEW IF EXISTS v1 CASCADE;

----------------------------------------------------------------
--Query 8 statements
--INSERT INTO query8


DROP VIEW IF EXISTS p1 CASCADE;
DROP VIEW IF EXISTS p2 CASCADE;

create view p1 as
select *
from player p, event e
where p.pid = e.winid or p.pid = e.lossid;

create view p2 as
select *
from player p, event e
where p.pid = e.winid or p.pid = e.lossid;

INSERT INTO query8
(select p1.pname as p1name, p2.pname as p2name, c.cname as cname
from p1,p2,country c
where p1.winid = p2.winid and p1.lossid = p2.lossid
and p1.pid <> p2.pid and p1.cid=p2.cid and p1.cid=c.cid
order by c.cname asc, p1.pname desc);

DROP VIEW IF EXISTS p1 CASCADE;
DROP VIEW IF EXISTS p2 CASCADE;

----------------------------------------------------------------	
--Query 9 statements
--INSERT INTO query9

DROP VIEW IF EXISTS a1 CASCADE;
DROP VIEW IF EXISTS a2 CASCADE;


create view a1 as
select c.pid as pid, count(c.tid) as tc
from champion c
group by c.pid
order by tc desc;

create view a2 as
select a1.pid as pid, a1.tc as tc
from a1
limit 1;

INSERT INTO query9
(select c.cname as cname, a2.tc as champions
from a2, player p, country c
where a2.pid = p.pid and p.cid = c.cid);

DROP VIEW IF EXISTS a1 CASCADE;
DROP VIEW IF EXISTS a2 CASCADE;


----------------------------------------------------------------

--Query 10 statements



DROP VIEW IF EXISTS w1 CASCADE;
DROP VIEW IF EXISTS w2 CASCADE;
DROP VIEW IF EXISTS w3 CASCADE;

create view w1 as
select r.pid as pid
from record r
where r.wins>r.losses and year = 2014;


create view w2 as
select lossid
from(select e.lossid as lossid , avg(e.duration)as avgd
from event e
group by e.lossid
having avg(e.duration)>200) as im1;

create view w3 as
select winid 
from(select e.winid as winid , avg(e.duration)as avgd
from event e
group by e.winid
having avg(e.duration)>200) as im2;

INSERT INTO query10(
select p.pname as pname
from w1,w2,w3,player p 
where p.pid = w1.pid and w1.pid = w2.lossid or w1.pid = w3.winid
order by p.pname desc);

