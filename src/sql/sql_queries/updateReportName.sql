update reports
set report_name=@report_name
where id=@id


select * from reports where id=@id