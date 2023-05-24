<!---THIS REPORT HAD BEEN DEVELOPED BY ENG.YAhya & zainab nadeem --->
<cfcomponent>
<cfset dsn = application.systemParam.systemParam().dsn>
 <cfset This.EMPLOYEE_PUANTAJ_ID = 1>
 <cfset This.EMPLOYEE_ID = 1>
 <cfset This.IN_OUT_ID = 1>
 <cfset This.SAL_MON = 1>
 <cfset This.SAL_YEAR = 1>
 <cfset this.sskemp=1>
 <cfset this.sskcomp=1>
	
	<cffunction name="set_variables">
		<cfargument name="EMPLOYEE_PUANTAJ_ID" type="numeric" required="yes">
		<cfoutput>
		<cfquery name="get_val" datasource="#DSN#">
		select top 1 epr.EMPLOYEE_ID, ep.SAL_MON,ep.SAL_YEAR,epr.IN_OUT_ID,epr.ISSIZLIK_ISCI_HISSESI,epr.ISSIZLIK_ISVEREN_HISSESI, epr.EMPLOYEE_PUANTAJ_ID
			 from EMPLOYEES_PUANTAJ_ROWS epr inner join
			EMPLOYEES_PUANTAJ ep
			on epr.PUANTAJ_ID = ep.PUANTAJ_ID
			where epr.EMPLOYEE_PUANTAJ_ID = #arguments.EMPLOYEE_PUANTAJ_ID#
		</cfquery>
		</cfoutput>
		 <cfset This.EMPLOYEE_PUANTAJ_ID = arguments.EMPLOYEE_PUANTAJ_ID>
		 <cfset This.EMPLOYEE_ID = get_val.EMPLOYEE_ID>
		 <cfset This.IN_OUT_ID = get_val.IN_OUT_ID>
		 <cfset This.SAL_MON = get_val.SAL_MON>
		 <cfset This.SAL_YEAR = get_val.SAL_YEAR>
		 
	</cffunction>
	
 <cffunction name="emp_pun">
	
    	<cfquery name="emp_pun1" datasource="#DSN#">
WITH CTE AS(

SELECT        POSITION_NAME,SAL_YEAR, SAL_MON,GROSS_NET
,SALARY_TYPE,SALARY,in_out_id,


(select top 1 [PAT_INS_PREMIUM_BOSS_2] ---12 صندوق التقاعد العسكري 
 FROM [INSURANCE_RATIO] 
 where #createDate(arguments.sal_year,arguments.sal_mon,1)#  between  STARTDATE  and FINISHDATE
 )/100 as INnemp12_,

(select top 1 [DEATH_INSURANCE_PREMIUM_BOSS] ---12 مؤسسة العامة التأمينات 
  FROM [INSURANCE_RATIO] 
 where #createDate(arguments.sal_year,arguments.sal_mon,1)#  between  STARTDATE  and FINISHDATE)/100 as INnboss12_,

 
(select top 1 [DEATH_INSURANCE_PREMIUM_WORKER_MADEN]----6
  FROM [INSURANCE_RATIO] 
 where #createDate(arguments.sal_year,arguments.sal_mon,1)#  between  STARTDATE  and FINISHDATE
 )/100 as INnemp6_,

(select top 1 [DEATH_INSURANCE_PREMIUM_BOSS_MADEN]----9
  FROM [INSURANCE_RATIO] 
 where #createDate(arguments.sal_year,arguments.sal_mon,1)#  between  STARTDATE  and FINISHDATE)/100 as INnboss9_,



(select top 1 DEATH_INSURANCE_WORKER  FROM [INSURANCE_RATIO] 
 where #createDate(arguments.sal_year,arguments.sal_mon,1)#  between  STARTDATE  and FINISHDATE
 )/100 as INnemp7_,

(select top 1 DEATH_INSURANCE_BOSS  FROM [INSURANCE_RATIO] 
 where #createDate(arguments.sal_year,arguments.sal_mon,1)#  between  STARTDATE  and FINISHDATE)/100 as INnboss11_,


<!--- اجمالي الاستقطاعات داخل الحافز ---->		
		
isnull((
					select  distinct isnull(SUM(AMOUNT),0) as ak_val
				   from [EMPLOYEES_PUANTAJ_ROWS_EXT] SPP
			where Spp.EMPLOYEE_PUANTAJ_ID=#This.EMPLOYEE_PUANTAJ_ID#
			and spp.EXT_TYPE=1 and 
			spp.PUANTAJ_ID in (
								select PUANTAJ_ID from [EMPLOYEES_PUANTAJ]
								where SAL_YEAR= sal_year
							  )
			and COMMENT_PAY in (
								select COMMENT_PAY from  [SETUP_PAYMENT_INTERRUPTION] spg 
								where SPP.COMMENT_PAY=spg.COMMENT_PAY and spg.TAX=3
								)
),0) as  dede_exit_salary
,
<!-----  إجمالي الاستقطاعات داخل الراتب----->
isnull(((
					select  distinct isnull(SUM(AMOUNT),0) as ak_val
				   from [EMPLOYEES_PUANTAJ_ROWS_EXT] SPP
			where Spp.EMPLOYEE_PUANTAJ_ID=#This.EMPLOYEE_PUANTAJ_ID#
			and spp.EXT_TYPE=1 and  spp.COMMENT_PAY in (
							select ALLOW_TYPE from  [YTECH_COSTUM].[dbo].[SALARY_COULUMN] spg 
								where SPP.COMMENT_PAY  = spg.ALLOW_TYPE  and spg.ded_amout_day =1) 
)  +


((
					select  distinct isnull(SUM(AMOUNT),0) as ak_val
				   from [EMPLOYEES_PUANTAJ_ROWS_EXT] SPP
			where Spp.EMPLOYEE_PUANTAJ_ID=#This.EMPLOYEE_PUANTAJ_ID#
			and spp.EXT_TYPE=1 and  spp.COMMENT_PAY in (
							select ALLOW_TYPE from  [YTECH_COSTUM].[dbo].[SALARY_COULUMN] spg 
								where SPP.COMMENT_PAY  = spg.ALLOW_TYPE  and spg.ded_amout_day =0) 
)* (salary/30))



 ),0)   as  dede_salary
, 
	(
(
					select  distinct isnull(SUM(AMOUNT),0) as ak_val
				   from [EMPLOYEES_PUANTAJ_ROWS_EXT] SPP
			where Spp.EMPLOYEE_PUANTAJ_ID=#This.EMPLOYEE_PUANTAJ_ID#
			and spp.EXT_TYPE=1 and  spp.COMMENT_PAY in (
							select ALLOW_TYPE from  [YTECH_COSTUM].dbo.[HAFEZ_COULUMN] spg 
								where SPP.COMMENT_PAY  = spg.ALLOW_TYPE  and spg.ded_amout_day =1) 
)  +


((
					select  distinct isnull(SUM(AMOUNT),0) as ak_val
				   from [EMPLOYEES_PUANTAJ_ROWS_EXT] SPP
			where Spp.EMPLOYEE_PUANTAJ_ID=#This.EMPLOYEE_PUANTAJ_ID#
			and spp.EXT_TYPE=1 
			and  spp.COMMENT_PAY in (
							select ALLOW_TYPE from  [YTECH_COSTUM].dbo.[HAFEZ_COULUMN] spg 
								where SPP.COMMENT_PAY  = spg.ALLOW_TYPE  and spg.ded_amout_day =0) 
)* 



((
					select  distinct isnull(SUM(AMOUNT),0) as ak_val
				   from [EMPLOYEES_PUANTAJ_ROWS_EXT] SPP
			where Spp.EMPLOYEE_PUANTAJ_ID=#This.EMPLOYEE_PUANTAJ_ID#
			and spp.EXT_TYPE=0 and  spp.COMMENT_PAY in (
							select ALLOW_TYPE from  [YTECH_COSTUM].dbo.[HAFEZ_COULUMN] spg 
								where SPP.COMMENT_PAY  = spg.ALLOW_TYPE  and spg.ALLOW_TAX =1) 
)/30))





+(select isnull(SUM(GELIR_VERGISI),0) as ak_val from [EMPLOYEES_PUANTAJ_ROWS_EXT] SPP
			where Spp.EMPLOYEE_PUANTAJ_ID=#This.EMPLOYEE_PUANTAJ_ID#
			and spp.EXT_TYPE=0  
			and  spp.COMMENT_PAY in (
			select ALLOW_TYPE  from  [YTECH_COSTUM].dbo.[HAFEZ_COULUMN] spg 
							where SPP.COMMENT_PAY
								= spg.ALLOW_TYPE )) 

   ) as  dede_HAFEZ
,
(
					select   isnull(SUM(AMOUNT),0)
				   from [EMPLOYEES_PUANTAJ_ROWS_EXT] SPP
			where Spp.EMPLOYEE_PUANTAJ_ID=#This.EMPLOYEE_PUANTAJ_ID#
			and spp.EXT_TYPE=0 and  spp.COMMENT_PAY in (
							select ALLOW_TYPE from  [YTECH_COSTUM].[dbo].[HAFEZ_COULUMN] spg 
								where SPP.COMMENT_PAY  = spg.ALLOW_TYPE  and spg.ALLOW_TAX =1) 
) as dede_HAFEZ_day
,		 
		







 
	(
(
					select  distinct isnull(SUM(AMOUNT),0) as ak_val
				   from [EMPLOYEES_PUANTAJ_ROWS_EXT] SPP
			where Spp.EMPLOYEE_PUANTAJ_ID=#This.EMPLOYEE_PUANTAJ_ID#
			and spp.EXT_TYPE=1 and  spp.COMMENT_PAY in (
							select ALLOW_TYPE from  [YTECH_COSTUM].dbo.[HAFEZ_COULUMN] spg 
								where SPP.COMMENT_PAY  = spg.ALLOW_TYPE  and spg.ded_amout_day =1) 
)  +


((
					select  distinct isnull(SUM(AMOUNT),0) as ak_val
				   from [EMPLOYEES_PUANTAJ_ROWS_EXT] SPP
			where Spp.EMPLOYEE_PUANTAJ_ID=#This.EMPLOYEE_PUANTAJ_ID#
			and spp.EXT_TYPE=1 and  spp.COMMENT_PAY in (
							select ALLOW_TYPE from  [YTECH_COSTUM].dbo.[HAFEZ_COULUMN] spg 
								where SPP.COMMENT_PAY  = spg.ALLOW_TYPE  and spg.ded_amout_day =0) 
)* 



((
					select  distinct isnull(SUM(AMOUNT),0) as ak_val
				   from [EMPLOYEES_PUANTAJ_ROWS_EXT] SPP
			where Spp.EMPLOYEE_PUANTAJ_ID=#This.EMPLOYEE_PUANTAJ_ID#
			and spp.EXT_TYPE=0 and  spp.COMMENT_PAY in (
							select ALLOW_TYPE from  [YTECH_COSTUM].dbo.[HAFEZ_COULUMN] spg 
								where SPP.COMMENT_PAY  = spg.ALLOW_TYPE  and spg.ALLOW_TAX =1) 
)/30))





+(select isnull(SUM(GELIR_VERGISI),0) as ak_val from [EMPLOYEES_PUANTAJ_ROWS_EXT] SPP
			where Spp.EMPLOYEE_PUANTAJ_ID=#This.EMPLOYEE_PUANTAJ_ID#
			and spp.EXT_TYPE=0  
			and  spp.COMMENT_PAY in (
			select ALLOW_TYPE  from  [YTECH_COSTUM].dbo.[HAFEZ_COULUMN] spg 
							where SPP.COMMENT_PAY
								= spg.ALLOW_TYPE )) 

   ) as  dede_HAFEZ2
,
(
					select   isnull(SUM(AMOUNT),0)
				   from [EMPLOYEES_PUANTAJ_ROWS_EXT] SPP
			where Spp.EMPLOYEE_PUANTAJ_ID=#This.EMPLOYEE_PUANTAJ_ID#
			and spp.EXT_TYPE=0 and  spp.COMMENT_PAY in (
							select ALLOW_TYPE from  [YTECH_COSTUM].dbo.[HAFEZ_COULUMN] spg 
								where SPP.COMMENT_PAY  = spg.ALLOW_TYPE  and spg.ALLOW_TAX =1) 
) as dede_HAFEZ_day2
,		 
















		
 <!---- أجمالي البدلات ل شهر الحالي معفي نت الضريبه   لراتب  ----->		
		(select isnull(SUM(AMOUNT),0) as ak_val from [EMPLOYEES_PUANTAJ_ROWS_EXT] SPP
			where Spp.EMPLOYEE_PUANTAJ_ID=#This.EMPLOYEE_PUANTAJ_ID#
			and spp.EXT_TYPE=0  
			and  spp.COMMENT_PAY in (
			select ALLOW_TYPE from  [YTECH_COSTUM].[dbo].[SALARY_COULUMN] spg 
							where SPP.COMMENT_PAY
								= spg.ALLOW_TYPE

								and allow_tax=0 )) as allow_no_tax,
					
 <!---- أجمالي البدلات ل شهر الحالي معفي نت الضريبه للحافز     ----->		
		(select isnull(SUM(AMOUNT),0) as ak_val from [EMPLOYEES_PUANTAJ_ROWS_EXT] SPP
			where Spp.EMPLOYEE_PUANTAJ_ID=#This.EMPLOYEE_PUANTAJ_ID#
			and spp.EXT_TYPE=0  
			and  spp.PUANTAJ_ID in (
			select PUANTAJ_ID from [EMPLOYEES_PUANTAJ]
			where SAL_YEAR= sal_year)) as allow_no_tax_salary,
<!---- أجمالي البدلات ل شهر الحالي  غير معفي من الضريبه  ----->	

(select isnull(SUM(AMOUNT),0) as ak_val1 from [EMPLOYEES_PUANTAJ_ROWS_EXT] SPP
			where Spp.EMPLOYEE_PUANTAJ_ID=#This.EMPLOYEE_PUANTAJ_ID#
			and spp.EXT_TYPE=0 
			and  spp.COMMENT_PAY in (
			select ALLOW_TYPE  from  [YTECH_COSTUM].[dbo].[SALARY_COULUMN] spg 
							where SPP.COMMENT_PAY 
								= spg.ALLOW_TYPE

								
								and allow_tax=1)) 
			
		 as allow_with_tax,		
		 <!---- أجمالي البدلات ل شهر الحالي  غير معفي من الضريبه للحافز  ----->	

(select isnull(SUM(AMOUNT),0) as ak_val from [EMPLOYEES_PUANTAJ_ROWS_EXT] SPP
			where Spp.EMPLOYEE_PUANTAJ_ID=#This.EMPLOYEE_PUANTAJ_ID#
			and spp.EXT_TYPE=0  
			and  spp.COMMENT_PAY in (
			select ALLOW_TYPE  from  [YTECH_COSTUM].dbo.[HAFEZ_COULUMN] spg 
							where SPP.COMMENT_PAY
								= spg.ALLOW_TYPE )) 
			
		 as allow_with_tax_salary1,	
		 
		 
		 
		 <!---- أجمالي البدلات ل شهر الحالي  غير معفي من الضريبه للحافز  ----->	

(select isnull(SUM(AMOUNT),0) as ak_val from [EMPLOYEES_PUANTAJ_ROWS_EXT] SPP
			where Spp.EMPLOYEE_PUANTAJ_ID=#This.EMPLOYEE_PUANTAJ_ID#
			and spp.EXT_TYPE=0  
			and  spp.COMMENT_PAY in (
			select ALLOW_TYPE  from  [YTECH_COSTUM].dbo.[HAFEZ_COULUMN] spg 
							where SPP.COMMENT_PAY
								= spg.ALLOW_TYPE )) 
			
		 as allow_with_tax_salary12,	
		 
		  <!---- أجمالي البدلات ل شهر الحالي  غير معفي من الضريبه للحافز  ----->	

(select isnull(SUM(AMOUNT),0) as ak_val from [EMPLOYEES_PUANTAJ_ROWS_EXT] SPP
			where Spp.EMPLOYEE_PUANTAJ_ID=#This.EMPLOYEE_PUANTAJ_ID#
			and spp.EXT_TYPE=0  
			and  spp.COMMENT_PAY in (
			select ALLOW_TYPE  from  [YTECH_COSTUM].dbo.[HAFEZ_COULUMN] spg 
							where SPP.COMMENT_PAY
								= spg.ALLOW_TYPE )) 
			
		 as allow_with_tax_salary13,
		 
		  <!---- ضريبة الحافز  ----->	

(select isnull(SUM(GELIR_VERGISI),0) as ak_val from [EMPLOYEES_PUANTAJ_ROWS_EXT] SPP
			where Spp.EMPLOYEE_PUANTAJ_ID=#This.EMPLOYEE_PUANTAJ_ID#
			and spp.EXT_TYPE=0  
			and  spp.COMMENT_PAY in (
			select ALLOW_TYPE  from  [YTECH_COSTUM].dbo.[HAFEZ_COULUMN] spg 
							where SPP.COMMENT_PAY
								= spg.ALLOW_TYPE )) 
			
		 as allow_hafez_tax,	
		 	
		 
		  <!---- ضريبة الحافز  ----->	

(select isnull(SUM(GELIR_VERGISI),0) as ak_val from [EMPLOYEES_PUANTAJ_ROWS_EXT] SPP
			where Spp.EMPLOYEE_PUANTAJ_ID=#This.EMPLOYEE_PUANTAJ_ID#
			and spp.EXT_TYPE=0  
			and  spp.COMMENT_PAY in (
			select ALLOW_TYPE  from  [YTECH_COSTUM].dbo.[HAFEZ_COULUMN] spg 
							where SPP.COMMENT_PAY
								= spg.ALLOW_TYPE )) 
			
		 as allow_hafez_tax2,	
		 
		 
		 
		  <!----  ضريبه بدلات خارج الحافز  ----->	

(select isnull(SUM(GELIR_VERGISI),0) as ak_val from [EMPLOYEES_PUANTAJ_ROWS_EXT] SPP
			where Spp.EMPLOYEE_PUANTAJ_ID=#This.EMPLOYEE_PUANTAJ_ID#
			and spp.EXT_TYPE=0  
			and  spp.COMMENT_PAY in (
			select ALLOW_TYPE  from  [YTECH_COSTUM].dbo.[HAFEZ_COULUMN] spg 
							where SPP.COMMENT_PAY
								= spg.ALLOW_TYPE )) 
			
		 as allow_hafez_tax3,	
		
		
 
<!--- تأكد اذا الموظف الجديد أو لا  --->
			isnull((SELECT top 1 IN_OUT_ID FROM EMPLOYEES_IN_OUT eio1
			where eio1.EMPLOYEE_ID= EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID
			 AND  MONTH(START_DATE)= SAL_MON AND YEAR(START_DATE)=SAL_YEAR
			 and IN_OUT_ID = (SELECT max(IN_OUT_ID) FROM EMPLOYEES_IN_OUT eio2 WHERE eio1.EMPLOYEE_ID =EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID )),0) as ISNEW
 	,
<!----  الراتب الاساسي حسب الاجمالي يقسم او يعطى مثل ماكان---->

	 (case when GROSS_NET=1 then SALARY / 0.65 else salary end) as base_salary
,
<!----  تقسيم البدلات حسب ايام العمل قبل وبعد الاجمالي  عن طريق الياقه --->
		(
			SELECT  top 1 GROUP_IDS 
			  FROM [SETUP_PROGRAM_PARAMETERS]
			  where PARAMETER_NAME = SAL_YEAR  
		) as Gr_all
,
<!---    معفى من ضريبة الدخل  0 غير معفي 1 معفي ---->
	 (
SELECT  top 1 IS_TAX_FREE
  FROM EMPLOYEES_IN_OUT eio2 
  where eio2.EMPLOYEE_ID= EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID
) as Tax_free,

<!---  هل الراتب او حافز ---->
	 (
SELECT  top 1 IS_DAMGA_FREE
  FROM EMPLOYEES_IN_OUT eio2 
  where eio2.EMPLOYEE_ID= EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID
) as Damge_free ,


isnull((select top 1 amount  FROM [YTECH_COSTUM].[dbo].SALARY_syspand  where  sal_year=#this.sal_year# and s_salary=1 and  EMP_NO in (select employee_no from EMPLOYEES where employee_id=EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID  ) and sal_mon >= sal_monf and sal_mon <= sal_mont and sal_year=SALARY_syspand.sal_year),0) syspand_amount,
isnull((select top 1 pers  FROM [YTECH_COSTUM].[dbo].SALARY_syspand  where  sal_year=#this.sal_year# and s_salary=1 and EMP_NO in (select employee_no from EMPLOYEES where employee_id=EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID  ) and sal_mon >= sal_monf and sal_mon <= sal_mont and sal_year=SALARY_syspand.sal_year),0) syspand_pers,

isnull((select top 1 amount  FROM [YTECH_COSTUM].[dbo].SALARY_syspand  where  sal_year=#this.sal_year# and  s_hafez=1 and EMP_NO in (select employee_no from EMPLOYEES where employee_id=EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID  ) and sal_mon >= sal_monf and sal_mon <= sal_mont and sal_year=SALARY_syspand.sal_year),0) syspand_amount_hafez,
isnull((select top 1 pers  FROM [YTECH_COSTUM].[dbo].SALARY_syspand  where  sal_year=#this.sal_year# and s_hafez=1 and EMP_NO in (select employee_no from EMPLOYEES where employee_id=EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID  ) and sal_mon >= sal_monf and sal_mon <= sal_mont and sal_year=SALARY_syspand.sal_year),0) syspand_pers_hafez,



<!--- أزدواج تاميني --->
(SELECT top 1 Use_SSK FROM EMPLOYEES_IN_OUT eio2
where eio2.EMPLOYEE_ID= EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID) as ISSSK
,

<!----  قيمة العمله ----->
		(SELECT 
		  top 1 [WORTH]  
		  FROM [EMPLOYEES_SALARY_CHANGE] esc
		  where esc.Money = [EMPLOYEES_PUANTAJ_ROWS].Money ) as money_exchang
  ,
<!---- نوع العملة ----->
		(SELECT 
		 money   FROM [EMPLOYEES_SALARY_CHANGE] esc
		 where esc.Money = [EMPLOYEES_PUANTAJ_ROWS].Money ) as money
  , 



<!---  يتم اختيار نوع الياقه لتحديد التامين هئية --->
<!---او مكتب تامين هناك خيارين (1 معناتها هذا موظف مثبت اللياقه زرقاء ) (2- معناتها موظف متعاقد اللياقه بيضاء )  ---->
		(
		SELECT TOP 1 COLLAR_TYPE
		  FROM [EMPLOYEE_POSITIONS]
		  WHERE POSITION_CODE = EMPLOYEES_PUANTAJ_ROWS.POSITION_CODE) AS COLLAR_TYPE_1
    ,
<!--- الراتب التأميني ---->
isnull(( select top  1 (pr.SALARY ) FROM [EMPLOYEES_PUANTAJ_ROWS] pr
where  pr.EMPLOYEE_ID= EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID
and PR.IN_OUT_ID=  IN_OUT_ID  and PUANTAJ_ID in (
select PUANTAJ_ID from [EMPLOYEES_PUANTAJ]
where SAL_YEAR= sal_year)  order by PUANTAJ_ID  ASC )  ,0) as Base_salary_ss
  
  ,
   <!---  ربط المنصب بالبدل بدل المسؤليه  --->
   
      (SELECT top  1 z.[POSITION_CAT_ID] FROM [EMPLOYEE_POSITIONS] z
        where z.EMPLOYEE_ID= employee_id) as Posstion_type
		,
 
<!--- عدد ايام الشهر--->
 (case DAY(EOMONTH(#CreateDateTime(session.ep.period_year, sal_mon, 1,0,0,0)#)) when 31 then 30 else DAY(EOMONTH(#CreateDateTime(session.ep.period_year, sal_mon, 1,0,0,0)#)) end )  as maxdayofmon  ,
<!---عدد أيام العمل --->
case when (#sal_mon# =2 and TOTAL_DAYS >= (DAY(EOMONTH(#CreateDateTime(session.ep.period_year,sal_mon, 1,0,0,0)#))))
then ((DAY(EOMONTH(#CreateDateTime(session.ep.period_year, sal_mon, 1,0,0,0)#)))) else
(case   when(DAY(EOMONTH(#CreateDateTime(session.ep.period_year, sal_mon, 1,0,0,0)#))=31 and TOTAL_DAYS < 29)
then TOTAL_DAYS-1 else TOTAL_DAYS  end ) end as Work_day   ,

ISSIZLIK_ISVEREN_HISSESI,ISSIZLIK_ISCI_HISSESI


FROM            EMPLOYEES_PUANTAJ_ROWS INNER JOIN
                         EMPLOYEES_PUANTAJ ON EMPLOYEES_PUANTAJ_ROWS.PUANTAJ_ID = EMPLOYEES_PUANTAJ.PUANTAJ_ID
		where 
		EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_PUANTAJ_ID = #This.EMPLOYEE_PUANTAJ_ID#
		
		)
	,
		CTE1 AS
		( 
		SELECT *, 
		
		
		(case when GROSS_NET=1 then SALARY / 0.65 else salary end) as base_salary_A
		
		 FROM CTE
		)
		,
		CTE00 as
		(
		Select *,
		(base_salary_A / maxdayofmon * Work_day) as r
		
		from CTE1
		)
		
		,
		CTE2 AS
		(
		SELECT *,
		( CASE when Gr_all = 3 then r else base_salary_A end) as Salary_days_work
		
		
		FROM CTE00
		),
		CTE000 as 
		(
		select * ,
		<!--- هذا عباره عن التأمينات الموظف والتامينات الشركه/ او الموسسه بنسبة 6 و 9 بالميه أو 7 و11 بالميه  ---->

<!------------------------------  yah تامين الشركة---->
(case when ISNEW > 0 AND  Work_day < 15 then 0  when ISNEW > 0 AND  Work_day < maxdayofmon then ((ISSIZLIK_ISVEREN_HISSESI) /maxdayofmon * Work_day) else (ISSIZLIK_ISVEREN_HISSESI) END ) as SSK11_comp ,
<!------------------------------  yah  تامين الموظف---->
(case when ISNEW > 0 AND  Work_day < 15 then 0  when ISNEW > 0 AND  Work_day < maxdayofmon then ((ISSIZLIK_ISCI_HISSESI) /maxdayofmon * Work_day) else (ISSIZLIK_ISCI_HISSESI) END ) as SSK11_emp ,
<!------------------------------  yah اصابة عمل  ---->
 (SALARY * 0.01) as Box_1_tranning,
 (SALARY * 0.02) as insurance_2

 	from CTE2
		
		)

		,  
CTE7  As 
		(
		select * ,
		<!---------اجمالي الاستحقاق ya-------------------> 
		( 
			 (Salary / maxdayofmon * Work_day)  + allow_no_tax + allow_with_tax + SSK11_comp + Box_1_tranning ) as Total_allowance 
				from CTE000
		)
		
		,
		CTE0000 as 
		(
		Select * ,
		<!------------yahya------------->
		( SSK11_comp + SSK11_emp) as Total_insurance
		from CTE7
		)
		,
		CTE004 as
		(
		select *,
		(   Total_allowance - ( SSK11_emp + SSK11_comp+ Box_1_tranning  )) as Taxbale_all
		from CTE0000
		),
		CTE8 as (
		select *,
		<!---yahya ضريبة كاك بنك للمثبتين والمتعاقدين---> case when salary = 0 then 0 else (
	case when (POSITION_NAME = 'محال للتقاعد') then 0 else (
		( select  

   case when  Taxbale_all <= max_payment_1 then Taxbale_all * ratio_1  else 
   (max_payment_1 * (ratio_1/100)) end  +

   (case when (Taxbale_all - max_payment_1 ) <= max_payment_2 then (Taxbale_all - MAX_PAYMENT_1 ) * (RATIO_2/100)
   else ((MAX_PAYMENT_2 - MAX_PAYMENT_1) * (ratio_2/100))
   end) 
       +
    (case when (Taxbale_all - ( MAX_PAYMENT_2 )) <= max_payment_3 then (Taxbale_all - (MAX_PAYMENT_2 ) ) * (RATIO_3/100)
   else ((MAX_PAYMENT_3 - (MAX_PAYMENT_2 ) )  * (ratio_3/100) )
   end) 

    FROM [SETUP_TAX_SLICES] 
	where datefromparts(SAL_YEAR,SAL_MON,1) between  STARTDATE  and FINISHDATE) ) end ) end as tax_1

	from CTE004
	)
	
	,
	
	CTE9 as
	(
	Select * ,
	
	( dede_salary + tax_1 + Total_insurance + Box_1_tranning   ) as Total_deduction 
	
	
	
	from CTE8
	)
	,CTE10 as 
	(
	Select * ,
	case when syspand_pers > 0 then
	( Total_allowance - Total_deduction )-(((( Total_allowance - Total_deduction )* syspand_pers) /100) + syspand_amount )
     else 
  ((( Total_allowance - Total_deduction )) - syspand_amount )   end 	as Net_benfit_1 ,
  ((( Total_allowance - Total_deduction )* syspand_pers )/100)  syspand_per ,
  
  
  
  
  case when syspand_pers_hafez > 0 then
	(allow_with_tax_salary1 - dede_HAFEZ) - (((allow_with_tax_salary1 - dede_HAFEZ)* syspand_pers_hafez /100) - syspand_amount_hafez ) 
     else 
  (((allow_with_tax_salary1 - dede_HAFEZ)) - syspand_amount_hafez )   end 	as Net_benfit_Hafz ,
  

  
  
  

  (allow_with_tax_salary12 - dede_HAFEZ2  ) 	as Net_benfit_Hafz2 ,
  (allow_with_tax_salary13 - allow_hafez_tax3  ) 	as Net_benfit_Hafz3 ,
  
  
    (((allow_with_tax_salary1 - dede_HAFEZ)* syspand_pers_hafez /100) ) syspand_per_Hafz

	
	from CTE9
	)
	

		SELECT * FROM CTE10
		
		</cfquery>
		<cfreturn emp_pun1>
</cffunction>
<!------------- Salary ---------->
					<!--- Get Deduction for Salary --->
				  <cffunction name="emp_deduction_Salary">
				  <cfargument name="emp_deduction_Salary" type="string" required="yes">

					<cfquery NAME="emp_deduction_Salary_1" datasource="#dsn#">
					  select isnull(SUM(AMOUNT),0) as ak_val from [EMPLOYEES_PUANTAJ_ROWS_EXT] SPP
							where Spp.EMPLOYEE_PUANTAJ_ID=#This.EMPLOYEE_PUANTAJ_ID#
							and spp.EXT_TYPE=1 
						  and (SPP.COMMENT_PAY like N'#arguments.emp_deduction_Salary#')
							and  spp.COMMENT_PAY in (select ALLOW_TYPE from  [YTECH_COSTUM].[dbo].[SALARY_COULUMN] spg 
								where SPP.COMMENT_PAY=spg.ALLOW_TYPE ) 
					</cfquery>
					<cfreturn emp_deduction_Salary_1>
				  </cffunction>
 <!--- Get Allowance for Salary --->
				  <!--- Get Allowance for Salary  wıthout tax--->
				  <cffunction name="emp_allowance_without_tax">
				  <cfargument name="allowance_name_without_tax" type="string" required="yes">
					<cfquery NAME="allowance_without_tax" datasource="#dsn#">
							select isnull(SUM(AMOUNT),0) as ak_val from [EMPLOYEES_PUANTAJ_ROWS_EXT] SPP
							where Spp.EMPLOYEE_PUANTAJ_ID=#This.EMPLOYEE_PUANTAJ_ID#
							and spp.EXT_TYPE=0  
							and (SPP.COMMENT_PAY like N'#arguments.allowance_name_without_tax#')
							
					</cfquery>
					<cfreturn allowance_without_tax>
					</cffunction>
					  <!--- Get Allowance for Salary  wıtht tax--->
				  <cffunction name="emp_allowance_with_tax">
				  <cfargument name="allowance_name_with_tax" type="string" required="yes">
					<cfquery NAME="allowance_with_tax" datasource="#dsn#">
							select isnull(SUM(AMOUNT),0) as ak_val1 from [EMPLOYEES_PUANTAJ_ROWS_EXT] SPP
							where Spp.EMPLOYEE_PUANTAJ_ID=#This.EMPLOYEE_PUANTAJ_ID#
							and spp.EXT_TYPE=0  
							and (SPP.COMMENT_PAY like N'#arguments.allowance_name_with_tax#')
							

					</cfquery>
					<cfreturn allowance_with_tax>
					</cffunction>
<!--------------- end Salary ------------->
					
										<!------- EXTRA SALARY -------------->
	
<!--- Get Deduction for extra --->
					  <cffunction name="emp_deduction_extra">
					  <cfargument name="deduction_name_extra" type="string" required="yes">

						<cfquery NAME="deduction_extra" datasource="#dsn#">
						  select isnull(SUM(AMOUNT),0) as ak_val from [EMPLOYEES_PUANTAJ_ROWS_EXT] SPP
								where Spp.EMPLOYEE_PUANTAJ_ID=#This.EMPLOYEE_PUANTAJ_ID#
								and spp.EXT_TYPE=1 
							  and (SPP.COMMENT_PAY like '#arguments.deduction_name_extra#')
							and  spp.PUANTAJ_ID in (
								select PUANTAJ_ID from [EMPLOYEES_PUANTAJ]
								where SAL_YEAR= sal_year)
								and COMMENT_PAY in (
								select COMMENT_PAY from  [SETUP_PAYMENT_INTERRUPTION] spg 
								where SPP.COMMENT_PAY=spg.COMMENT_PAY and spg.TAX=3
								)
						</cfquery>
						<cfreturn deduction_extra>
					  </cffunction>

					<!--- Get Allowance for extra --->
					  <cffunction name="emp_allowance_extra_without_tax">
					  <cfargument name="allowance_name_extra_without_tax" type="string" required="yes">
						<cfquery NAME="allowance_extra_without_tax" datasource="#dsn#">
								select isnull(SUM(AMOUNT),0) as ak_val from [EMPLOYEES_PUANTAJ_ROWS_EXT] SPP
								where Spp.EMPLOYEE_PUANTAJ_ID=#This.EMPLOYEE_PUANTAJ_ID#
								and spp.EXT_TYPE=0 and TAX =1 and SSK_EXEMPTION_TYPE = 1
								and (SPP.COMMENT_PAY like '#arguments.allowance_name_extra_without_tax#')
								and  spp.PUANTAJ_ID in (
								select PUANTAJ_ID from [EMPLOYEES_PUANTAJ]
								where SAL_YEAR= sal_year) 

						</cfquery>
						<cfreturn allowance_extra_without_tax>
						</cffunction>
						
						<!--- Get Allowance for extra --->
					  <cffunction name="emp_allowance_extra_with_tax">
					  <cfargument name="allowance_name_extra_with_tax" type="string" required="yes">
						<cfquery NAME="allowance_extra_with_tax" datasource="#dsn#">
								select isnull(SUM(AMOUNT),0) as ak_val from [EMPLOYEES_PUANTAJ_ROWS_EXT] SPP
								where Spp.EMPLOYEE_PUANTAJ_ID=#This.EMPLOYEE_PUANTAJ_ID#
								and spp.EXT_TYPE=0   and TAX =2 and SSK_EXEMPTION_TYPE = 1
								and (SPP.COMMENT_PAY like '#arguments.allowance_name_extra_with_tax#')
								and  spp.PUANTAJ_ID in (
								select PUANTAJ_ID from [EMPLOYEES_PUANTAJ]
								where SAL_YEAR= sal_year) 

						</cfquery>
						<cfreturn allowance_extra_with_tax>
						</cffunction>
<!------ end extra SALARY -------->
	
</cfcomponent>
