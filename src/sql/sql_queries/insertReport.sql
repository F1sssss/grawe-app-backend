insert into reports (report_name,procedure_id) values (@new_report_name,@procedure_id)

select * from reports where report_name=@new_report_name