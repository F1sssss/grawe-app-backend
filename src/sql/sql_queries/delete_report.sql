if not exists (select 1 from reports where id = @id)
begin
    throw 50000, 'report-not-found',2
end

begin transaction

declare @old_report_name nvarchar(255)=(select report_name from reports where id=@id)


delete from reports where id = @id

delete from reports_param_options where report_id = @id

delete from gr_pairing_permisson_property_list where id_permission_property in (select id from gr_property_lists where property_path=@old_report_name)

delete from gr_property_lists where property_path=@old_report_name


commit

select * from reports  (nolock) where id = @id
