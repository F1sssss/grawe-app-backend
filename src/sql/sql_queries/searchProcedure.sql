SELECT DISTINCT
p.object_id			[report_id],
p.name				[report_name],
pa.parameter_id 	[order],
pa.name			    [param_name],
UPPER(t.name)		[type],
pa.max_length		[length] ,
p.object_id			[procedure_id],
p.name				[procedure_name]
into #temp
from sys.procedures AS p
left join sys.parameters AS pa on pa.object_id = p.object_id
left JOIN sys.types AS t on pa.system_type_id = t.system_type_id AND pa.user_type_id = t.user_type_id
where p.name like '%' + @procedure_name + '%'

select distinct
[report_id],
[report_name],
[procedure_id],
[procedure_name]
from #temp

select [order],
       param_name,
       type,
       length,
       cast('' as varchar(8000)) sql_query
from #temp t
