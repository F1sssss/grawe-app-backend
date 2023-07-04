delete from reports where id = @id

delete from reports_param_options where report_id = @id

select * from reports  (nolock) where id = @id
