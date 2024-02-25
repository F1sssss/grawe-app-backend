begin transaction

delete from reports where id = @id

delete from reports_param_options where report_id = @id

commit

select * from reports  (nolock) where id = @id
