if exists (select * from reports where report_name=@new_report_name)
begin
    throw 50000, 'report-name-already-exists',2
end

if not exists (select * from sys.procedures where object_id=@procedure_id)
begin
    throw 50000, 'procedure-not-found',2
end

BEGIN TRANSACTION

insert into reports (report_name,procedure_id) values (@new_report_name,@procedure_id)

insert into gr_property_lists
select report_name from reports where report_name=@new_report_name

insert into gr_pairing_permisson_property_list
select (select distinct id from gr_permission where route='/api/v1/reports/' and method='get'), id from gr_property_lists
where property_path=@new_report_name

COMMIT

select * from reports where report_name = @new_report_name
order by id desc