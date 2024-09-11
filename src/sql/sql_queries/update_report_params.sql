if (exists (select 1 from reports_param_options where report_id=@report_id and  procedure_id=@procedure_id and order_param=@order))
    begin
        update reports_param_options set sql=@sql_query where report_id=@report_id and  procedure_id=@procedure_id and order_param=@order
    end
else
    begin
        insert into reports_param_options (procedure_id,report_id,order_param,param_name,sql) values (@procedure_id,@report_id,@order,@param_name,@sql_query)
    end

select * from reports_param_options where report_id=@report_id and  procedure_id=@procedure_id and order_param=@order