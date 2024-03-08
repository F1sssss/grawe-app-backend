if not exists (select 1 from users where username = @username)
begin

insert into users
(username,password,role,verified,created_at,updated_at)
values
(@username,@password,999,1,GETDATE(),GETDATE());

end


select * from users where username = @username;
