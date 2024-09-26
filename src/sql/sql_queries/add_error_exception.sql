
if not exists (select 1 from branche where bra_obnr=@policy)
begin
    throw 50000, 'Polisa ne postoji u tabelu branche!', 1;
end

if exists (select 1 from gr_error_exceptions where polisa=@policy and id_greske=@id)
begin
    throw 50000, 'Polisa ne postoji u tabelu branche!', 1;
end



insert into gr_error_exceptions values (
@policy,
@id,
@exception,
GETDATE(),
@user
)

select * from gr_error_exceptions (nolock)
where polisa=@policy and id_greske=@id

