if not exists (select 1 from gr_error_exceptions (nolock)
where polisa=@policy and id_greske=@id)
throw 50000, ' no-policy-with-id-found',2


delete from gr_error_exceptions
where polisa=@policy and id_greske=@id

select * from gr_error_exceptions (nolock)
where polisa=@policy and id_greske=@id