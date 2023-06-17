/*
SELECT
r.id				[report_id],
r.report_name		[report_name],
pa.parameter_id 	[order],
pa.name			    [param_name],
UPPER(t.name)		[type],
pa.max_length		[length] ,
p.object_id			[procedure_id],
p.name				[procedure_name]

FROM Reports r (nolock)
left join sys.procedures AS p on r.procedure_id = p.object_id
left join sys.parameters AS pa on pa.object_id = p.object_id
left JOIN sys.types AS t on pa.system_type_id = t.system_type_id AND pa.user_type_id = t.user_type_id
where id=@report
*/

SELECT DISTINCT
r.id				[report_id],
r.report_name		[report_name],
pa.parameter_id 	[order],
pa.name			    [param_name],
UPPER(t.name)		[type],
pa.max_length		[length] ,
p.object_id			[procedure_id],
p.name				[procedure_name]
into #temp
FROM Reports r (nolock)
left join sys.procedures AS p on r.procedure_id = p.object_id
left join sys.parameters AS pa on pa.object_id = p.object_id
left JOIN sys.types AS t on pa.system_type_id = t.system_type_id AND pa.user_type_id = t.user_type_id
where id=@report

select distinct
[report_id],
[report_name],
[procedure_id],
[procedure_name]
from #temp

select [order],param_name,type,length from #temp

