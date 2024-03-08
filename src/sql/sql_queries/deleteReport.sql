if not exists (select 1 from reports where id = @id)
begin
    throw 50000, 'report-not-found',2
end

begin transaction

delete from reports where id = @id

delete from reports_param_options where report_id = @id

commit

select * from reports  (nolock) where id = @id
