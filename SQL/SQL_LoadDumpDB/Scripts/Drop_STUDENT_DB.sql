CONNECT system/0;
/
set verify off
declare
	res number;
begin
	select count(1) into res from all_users where upper(username) = upper('student_db');
	if res <> 0 then
    execute immediate 'drop user STUDENT_DB cascade';
	end if;
end;
/