if not exists (select 1 from gr_greske_izuzetci (nolock)
where polisa=@policy and id_greske=@id)
throw 50000, ' no-policy-with-id-found',2


delete from gr_greske_izuzetci
where polisa=@policy and id_greske=@id

select * from gr_greske_izuzetci (nolock)
where polisa=@policy and id_greske=@id