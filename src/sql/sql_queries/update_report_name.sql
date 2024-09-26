if not exists (select 1 from reports where id = @id)
begin
    throw 50000, 'report-not-found',2
end

if exists (select 1 from reports where report_name = @report_name)
begin
    throw 50000, 'report-name-already-exists',2
end

declare @old_report_name nvarchar(255)=(select report_name from reports where id=@id)

BEGIN TRANSACTION

update gr_property_lists
set property_path=@report_name
where property_path=@old_report_name

update reports
set report_name=@report_name
where id=@id

COMMIT


select * from reports where id=@id