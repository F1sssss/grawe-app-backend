if not exists (select 1 from branche where bra_obnr=@policy)
begin
    throw 50000, 'Polisa ne postoji u tabelu branche!', 1;
end

if exists (select 1 from gr_greske_izuzetci where polisa=@policy and id_greske=@id)
begin
    throw 50000, 'Polisa ne postoji u tabelu branche!', 1;
end



insert into gr_greske_izuzetci values (
@policy,
@id,
@exception,
GETDATE(),
@user
)

select * from gr_greske_izuzetci (nolock)
where polisa=@policy and id_greske=@id

