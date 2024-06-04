select polisa from gr_clients_all a
where
(exists (select 1 from praemienkonto pk where pk.pko_obnr=a.polisa and convert(date,pko_wertedatum,104) between convert(date,@dateFrom,104) and convert(date,@dateTo,104)) or
isnull(cast(((select top 1  cast(replace(p.pko_wertedatumsaldo,',','.')	as decimal(18,2))  from praemienkonto p (nolock) where convert(date,pko_wertedatum,104)<=convert(date,@dateTo,104) and p.pko_obnr=a.polisa order by convert(date,pko_wertedatum,104) desc,pko_buch_nr desc )) as decimal(18,2)),0)<>0)
and a.[embg/pib]=@id