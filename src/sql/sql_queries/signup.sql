if exists (select 1 from users (nolock) where username=@username or email=@email)
begin
      throw 51000, 'Username or email already exists', 1;
end


insert into users
(username,password,name,last_name,email,date_of_birth,verified,time_to_varify,created_at,email_verification_token)
values
(@username,@password,@name,@last_name,@email,@DOB,0,DATEADD(mi,10,GETDATE()),GETDATE(),@verification_code)


select * from users (nolock) where username=@username
