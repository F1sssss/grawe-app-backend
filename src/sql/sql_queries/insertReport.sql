if exists (select * from reports where report_name=@new_report_name)
begin
    throw 50000, 'report-already-exists',2
end

if not exists (select * from sys.procedures where object_id=@procedure_id)
begin
    throw 50000, 'procedure-not-found',2
end

insert into reports (report_name,procedure_id) values (@new_report_name,@procedure_id)

select * from reports where report_name=@new_report_name