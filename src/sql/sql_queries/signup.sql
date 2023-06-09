insert into users (username,password,Name,Last_name,email,Date_of_Birth) values (@username, @name, @last_Name,@password,@email,@DOB)

select * from users
where username = @username
