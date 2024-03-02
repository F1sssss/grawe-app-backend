insert into users
(username,password,role,verified,created_at,updated_at)
values
(@username,@password,999,1,GETDATE(),GETDATE());


select * from users where username = @username;
