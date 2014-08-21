select fahr_knz, count(*) from fahr f1
where fahr_knz in (select fahr_knz
from fahr f2 where f2.fahr_knz = f1.fahr_knz)
group by fahr_knz
having count(*) > 1