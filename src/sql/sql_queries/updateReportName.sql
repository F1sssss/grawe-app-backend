if not exists (select 1 from reports where id = @id)
begin
    throw 50000, 'report-not-found',2
end


update reports
set report_name=@report_name
where id=@id


select * from reports where id=@id