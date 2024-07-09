insert into users
(username,password,name,last_name,email,date_of_birth,verified,time_to_varify,created_at,email_verification_token)
values
(@username,@password,@name,@last_name,@email,null,1,DATEADD(mi,10,GETDATE()),GETDATE(),null)


select * from users (nolock) where username=@username
