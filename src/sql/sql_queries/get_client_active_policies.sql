select polisa
from gr_clients_all a
where
(exists (select 1 from praemienkonto pk where pk.pko_obnr=a.polisa and pko_wertedatum between @dateFrom and @dateTo) or
isnull((select top 1 p.pko_wertedatumsaldo from praemienkonto p (nolock) where pko_wertedatum <= @dateTo and p.pko_obnr=a.polisa order by pko_wertedatum desc,pko_buch_nr desc),0)<>0)
and a.[embg/pib]=@id
group by polisa