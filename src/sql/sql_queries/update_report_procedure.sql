if not exists (select 1 from reports where id = @id)
begin
    throw 50000, 'report-not-found',2
end

if not exists (select 1 from sys.procedures where object_id = @procedure_id)
begin
    throw 50000, 'procedure-not-found',2
end

begin transaction

update reports
set procedure_id=@procedure_id where id=@id

if(exists(select 1 from reports_param_options where report_id=@id and procedure_id<>@procedure_id))
    begin

        delete
        from reports_param_options
        where report_id=@id and procedure_id<>@procedure_id

    end

commit

select * from reports
where id=@id
