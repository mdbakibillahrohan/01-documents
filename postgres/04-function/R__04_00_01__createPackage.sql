
-- DROP FUNCTION IF EXISTS populate_calendar_detail(date, date);
CREATE OR REPLACE FUNCTION populate_calendar_detail(startDate date, endDate date)
RETURNS VOID AS $populate_calendar_detail$
    DECLARE
        currDate                            timestamp ;
        oid                                 numeric(8);
        yearValue                           numeric(4);
        quarterValue                        numeric(1);
        monthValue                          numeric(2);
        weekOfMonthValue                    numeric(1);
        weekOfYearValue                     numeric(2);
        dayValue                            numeric(2);
        dayOfYearValue                      numeric(3);
        dayOfWeekValue                      numeric(1);
        quarterString                       varchar(2);
        monthString                         varchar(10);
        dayString                           varchar(10);
    BEGIN
        currDate := startDate;
        while currDate < endDate
        loop
            oid                 := to_char(currDate, 'YYYYMMDD');
            yearValue           := to_char(currDate, 'YYYY');
            quarterValue        := to_char(currDate, 'Q');
            monthValue          := to_char(currDate, 'MM');
            weekOfMonthValue    := to_char(currDate, 'W');
            weekOfYearValue     := to_char(currDate, 'IW');
            dayValue            := to_char(currDate, 'DD');
            dayOfYearValue      := to_char(currDate, 'DDD');
            dayOfWeekValue      := to_char(currDate, 'D');
            quarterString       := trim('Q' || quarterValue);
            monthString         := trim(to_char(currDate, 'Month'));
            dayString           := trim(to_char(currDate, 'Day'));
            insert into CalendarDetail (oid, yearValue, quarterValue, monthValue, weekOfMonthValue, weekOfYearValue, dayValue, dayOfYearValue, dayOfWeekValue, quarterString, monthString, dayString)
            values (oid, yearValue, quarterValue, monthValue, weekOfMonthValue, weekOfYearValue, dayValue, dayOfYearValue, dayOfWeekValue, quarterString, monthString, dayString);
            currDate := currDate + interval '1 day';
        END loop;
    END;
$populate_calendar_detail$ language plpgsql;

select populate_calendar_detail(to_date('2019-01-01', 'YYYY-MM-DD'), to_date('2020-12-31', 'YYYY-MM-DD'));

-- DROP FUNCTION IF exists remove_salary(varchar(128), numeric(4, 0), varchar(10), varchar(64));
CREATE OR REPLACE FUNCTION remove_salary(p_companyOid varchar(128), p_year numeric(4 ,0), p_monthName varchar(10), p_createdBy varchar(64))
RETURNS VOID AS $remove_salary$
    DECLARE
        p_calendarOid                       varchar(128);
		p_companyCalendarOid				varchar(128);
    BEGIN
        p_calendarOid := (select oid from Calendar where 1 = 1 and yearEn = p_year and nameEn = p_monthName);
        p_companyCalendarOid := (select oid from CompanyCalendar where 1 = 1 and companyOid = p_companyOid and calendarOid = p_calendarOid);
        delete from EmployeeSalary where companyOid = p_companyOid and companyCalendarOid = p_companyCalendarOid;
        -- delete from CompanyCalendar where companyOid = p_companyOid and oid = p_companyCalendarOid;
        update CompanyCalendar set status = null, editedBy = p_createdBy, editedOn = clock_timestamp()
        where 1 = 1 and companyOid = p_companyOid and oid = p_companyCalendarOid;
    END;
$remove_salary$ language plpgsql;

-- DROP FUNCTION IF exists generate_salary(varchar(128), numeric(4,0), varchar(10), varchar(64));
-- select generate_salary('Company-GCL', 2019, 'January', 'debbrota');
CREATE OR REPLACE FUNCTION generate_salary(p_companyOid varchar(128), p_year numeric(4, 0), p_monthName varchar(10), p_createdBy varchar(64))
RETURNS VOID AS $generate_salary$
    DECLARE
        p_calendarOid                       varchar(128);
		p_companyCalendarOid				varchar(128);
		p_basic 							numeric(4,2) := 0;
		p_hr       							numeric(4,2) := 0;
		p_conveyance						numeric(4,2) := 0;
		p_medical     						numeric(4,2) := 0;
		employeeCursor CURSOR FOR select oid, grossSalary, tax, CASE WHEN bankOid is not null THEN 'Bank' ELSE 'Cash' end as paymentMode from Employee where companyOid = p_companyOid and status = 'Active';
		c_basic 							numeric(12,2) := 0;
		c_hr       							numeric(12,2) := 0;
		c_conveyance						numeric(12,2) := 0;
		c_medical     						numeric(12,2) := 0;
		c_late        						numeric(12,2) := 0;
		c_lwp          						numeric(12,2) := 0;
		c_totalAllowance					numeric(12,2) := 0;
		c_totalDeduction					numeric(12,2) := 0;
		c_netPayable      					numeric(12,2) := 0;
    BEGIN
		p_basic := (select salaryJson::json->>'basic' from Company where oid = p_companyOid and status = 'Active');
		p_hr := (select salaryJson::json->>'hr' from Company where oid = p_companyOid and status = 'Active');
		p_conveyance := (select salaryJson::json->>'conveyance' from Company where oid = p_companyOid and status = 'Active');
		p_medical := (select salaryJson::json->>'medical' from Company where oid = p_companyOid and status = 'Active');
		/*if p_basic is null then
			insert into CompanyCalendar (oid, status, reason, calendarOid, companyOid, createdOn, createdBy)
			values (p_companyCalendarOid, 'Failed', 'Basic configuration not found', p_calendarOid, p_companyOid, clock_timestamp(), p_createdBy);
			return;
		end if;*/
		p_calendarOid := (select oid from Calendar where 1 = 1 and yearEn = p_year and nameEn = p_monthName);
		p_companyCalendarOid := (select oid from CompanyCalendar where 1 = 1 and companyOid = p_companyOid and calendarOid = p_calendarOid);
		if p_companyCalendarOid is null then
			p_companyCalendarOid := MD5(random()::text);
       		insert into CompanyCalendar (oid, status, calendarOid, companyOid, createdOn, createdBy)
			values (p_companyCalendarOid, 'Generated', p_calendarOid, p_companyOid, clock_timestamp(), p_createdBy);
		else
			update CompanyCalendar set status = 'Generated', editedBy = p_createdBy, editedOn = clock_timestamp()
			where 1 = 1 and companyOid = p_companyOid and oid = p_companyCalendarOid;
			delete from EmployeeSalary where 1 = 1 and companyOid = p_companyOid and companyCalendarOid = p_companyCalendarOid;
        end if;
		for emp in employeeCursor loop
            c_basic := round((emp.grossSalary * p_basic)/100, 0);
            c_hr := round((emp.grossSalary * p_hr)/100, 0);
            c_conveyance := round((emp.grossSalary * p_conveyance)/100, 0);
            c_medical := round((emp.grossSalary * p_medical)/100, 0);
            c_totalAllowance := c_basic + c_hr + c_conveyance + c_medical;
            c_medical := c_medical + (emp.grossSalary - c_totalAllowance);
            c_totalAllowance := c_basic + c_hr + c_conveyance + c_medical + c_lwp;
            c_totalDeduction := emp.tax;
            c_netPayable := c_totalAllowance - c_totalDeduction;
			insert into EmployeeSalary (oid, basic, hr, conveyance, medical, late, lwp, totalAllowance, tax, totalDeduction, netPayable, paymentMode, employeeOid, companyCalendarOid, companyOid, createdOn, createdBy)
			values (MD5(random()::text), c_basic, c_hr, c_conveyance, c_medical, c_late, c_lwp, c_totalAllowance, emp.tax, c_totalDeduction, c_netPayable, emp.paymentMode, emp.oid, p_companyCalendarOid, p_companyOid, clock_timestamp(), p_createdBy);
		end loop;
    END;
$generate_salary$ language plpgsql;

-- DROP FUNCTION IF exists remove_mobile_bill(varchar(128), numeric(4, 0), varchar(10), varchar(64));
CREATE OR REPLACE FUNCTION remove_mobile_bill(p_companyOid varchar(128), p_year numeric(4, 0), p_monthName varchar(10), p_createdBy varchar(64))
RETURNS VOID AS $remove_mobile_bill$
    DECLARE
        p_calendarOid                       varchar(128);
		p_companyCalendarOid				varchar(128);
    BEGIN
        p_calendarOid := (select oid from Calendar where 1 = 1 and yearEn = p_year and nameEn = p_monthName);
        p_companyCalendarOid := (select oid from CompanyCalendar where 1 = 1 and companyOid = p_companyOid and calendarOid = p_calendarOid);
        delete from MobileBill where companyOid = p_companyOid and companyCalendarOid = p_companyCalendarOid;
        -- delete from CompanyCalendar where companyOid = p_companyOid and oid = p_companyCalendarOid;
        update CompanyCalendar set mobileBillStatus = null, editedBy = p_createdBy, editedOn = clock_timestamp()
        where 1 = 1 and companyOid = p_companyOid and oid = p_companyCalendarOid;
    END;
$remove_mobile_bill$ language plpgsql;


-- CREATE TYPE mobileBill as (mobileNo varchar(64), operator varchar(64), billAmount numeric(8,0));
-- DROP FUNCTION IF exists upload_mobile_bill(varchar(128), numeric(4, 0), varchar(10), varchar(128), mobileBill[], varchar(64));
/*
CREATE OR REPLACE FUNCTION upload_mobile_bill(p_companyOid varchar(128), p_year numeric(4,0), p_monthName varchar(10), p_fileName varchar(128), c_mobileBill mobileBill[], p_createdBy varchar(64))
RETURNS VOID AS $upload_mobile_bill$
    DECLARE
        p_mobileBill 						mobileBill[];
        p_employeeOid                       varchar(128);
        p_calendarOid                       varchar(128);
		p_companyCalendarOid				varchar(128);
    BEGIN
        p_mobileBill := c_mobileBill;
        p_calendarOid := (select oid from Calendar where 1 = 1 and yearEn = p_year and nameEn = p_monthName);
        p_companyCalendarOid := (select oid from CompanyCalendar where 1 = 1 and companyOid = p_companyOid and calendarOid = p_calendarOid);
        if p_companyCalendarOid is null then
			p_companyCalendarOid := MD5(random()::text);
       		insert into CompanyCalendar (oid, mobileBillStatus, calendarOid, companyOid, createdOn, createdBy)
			values (p_companyCalendarOid, 'Uploaded', p_calendarOid, p_companyOid, clock_timestamp(), p_createdBy);
		else
			update CompanyCalendar set mobileBillStatus = 'Uploaded', editedBy = p_createdBy, editedOn = clock_timestamp()
			where 1 = 1 and companyOid = p_companyOid and oid = p_companyCalendarOid;
			delete from MobileBill where 1 = 1 and companyOid = p_companyOid and companyCalendarOid = p_companyCalendarOid;
        end if;

        -- foreach mobileBill in array p_mobileBill loop
		for mobileBill in p_mobileBill loop
            p_employeeOid := (select oid from Employee where 1 = 1 and status = 'Active' and companyMobileNo like '%01678004545%' limit 1);
            insert into MobileBill (oid, mobileNo, operator, billAmount, fileName, employeeOid, companyCalendarOid, companyOid, createdOn, createdBy)
			values (MD5(random()::text), mobileBill.mobileNo, mobileBill.operator, mobileBill.billAmount, p_fileName, p_employeeOid, p_companyCalendarOid, p_companyOid, clock_timestamp(), p_createdBy);
        end loop;

    END;
$upload_mobile_bill$ language plpgsql;
*/
