insert into gr_greske_izuzetci values (
@policy,
@id,
@exception,
GETDATE()
)

select * from gr_greske_izuzetci (nolock)
where polisa=@policy and id_greske=@id

