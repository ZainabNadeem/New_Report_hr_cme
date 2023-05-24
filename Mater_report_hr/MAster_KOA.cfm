<!---THIS REPORT HAD BEEN DEVELOPED BY ENG.YAhya & Zainab Nadeem --->
<!---V21 ADD SERVICE-STAFF (salary per day) AS CATOGERY--->
<!---V22 remove SERVICE-STAFF (salary per day) AS CATOGERY and support report with Table style--->
<!---V23 support report with resend an email action--->
<!---V23 support report with CHANGE REVIEWER OR APPROVAL AND resend an email action--->
<!---V24 change some words and sentences and --->
<!---V25 correct the calc of Gross s.s column --->
<!---V1add new columen of changrate ss --->
<!---V2add adjestmetn column --->
<!---V3add first checkbox --->
<cfprocessingdirective pageEncoding="utf-8">  




 <cfquery name="ddd_trad" datasource="#dsn#">
	 select DEPARTMENT_ID from DEPARTMENT where IS_PRODUCTION =1
	 </cfquery>

<cfset REVIEWER1_code=''>
<cfset APPROVAL1_code=''>
<cfset APPROVAL2_code=''>  
   <cfset dec_sal_sum=0> 
   <cfset t_dec_sum=0>
    <cfset t_15_sum=0> 
	<cfset t_withour_sum=0>
     <cfset t_col10_sum=0>
      <cfset t_col9_sum=0>
<cfparam name="attributes.ADDGL" default="">  
<cfset t_col2_sum=0> 
<cfset t_20_sum=0>
<cfset T_16_SUM =0>
<cfset T_17_SUM =0>
<cfset T_18_SUM =0>
<cfset T_19_SUM =0>
<cfset T_21_SUM =0>

 <cfset t_col8_sum=0> 
  <cfset t_col13_sum=0> 
   <cfset t_col14_sum=0> 
<cfset t_col14_sum=0>
<!-----za_sum------>
<cfset t_salba_sum=0>
<cfSET t_absent_day =0>
<cfSET t_absent_day_1 =0>
<cfset t_Tran_sum=0>
<cfset  t_Repres_sum=0>
<cfset  t_nature_sum =0>
<cfset t_Grosss_sum=0>
  <cfset t_S.S6_sum=0>
<cfset t_S.S9_sum=0>
<cfset t_gen_sum=0>
<cfset t_SSk_sum=0>
<cfset t_Sal15_sum=0>
<cfset t_15_sum=0>
<cfset t_Incom_sum=0>
<cfset t_Incom_sum=0>
<cfset dec_Tax_sum=0>
<cfset dec_oth_sum=0>
<cfset t_dec_sum=0>
<cfset t_Net_sum=0>   
<cfparam name="attributes.ADDnet" default="">
<cfparam name="attributes.ADDdetec" default="">
<cfparam name="attributes.ADDAdj" default="">





<!-----------function to match the net-------------->
<cffunction name="getnet" output="false" access="public" returntype="any">
    <cfargument name="empparm" type="string" required="false" default="" />
    
   

	<cfquery name="qcustanly" datasource="#dsn#">
SELECT 

     ((NET_UCRET - (((ISSIZLIK_ISCI_HISSESI + ISSIZLIK_ISVEREN_HISSESI)* DAMGA_VERGISI_INDIRIMI_7103)- ((ISSIZLIK_ISCI_HISSESI + ISSIZLIK_ISVEREN_HISSESI)* GELIR_VERGISI_INDIRIMI_7103)) / DAMGA_VERGISI_INDIRIMI_7103))  AS NET_UCRET_
             
                       
FROM            EMPLOYEES_PUANTAJ_ROWS INNER JOIN
                         EMPLOYEES_PUANTAJ ON EMPLOYEES_PUANTAJ_ROWS.PUANTAJ_ID = EMPLOYEES_PUANTAJ.PUANTAJ_ID 
                        
                          WHERE   
      SAL_MON= #attributes.sal_mon#  
      AND SAL_YEAR= #attributes.sal_YEAR#
     
   
       AND  EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID  = #arguments.empparm#

   
	
	
	
 </cfquery>

	<cfreturn   qcustanly />
	
	
	</cffunction>
	
	
	

<!-----------create with  FULL  conditions the function  for salary-------------->











<cfif isdefined('attributes.resend_email')>

<cffunction name="msgg">
<cfargument name="RECEIVER_ID" required="true">
        <cfargument name="POSITION_CODE" required="true">
        <cfargument name="WARNING_HEAD" required="true">
<cfif len(RECEIVER_ID)>
        <cfquery name="get_employee_data" datasource="#dsn#">
           SELECT        
              EMPLOYEE_NAME, 
              EMPLOYEE_SURNAME, 
              EMPLOYEE_EMAIL,
              (SELECT TOP (1) EMPLOYEE_EMAIL FROM EMPLOYEES WHERE EMPLOYEE_ID=#SESSION.EP.USERID#) AS SENDER
              FROM   EMPLOYEES
              WHERE        (EMPLOYEE_ID = #RECEIVER_ID#)
        </cfquery>
        <cfquery name="get_employee_data_ID" datasource="#dsn#">
           SELECT        
              [EMPLOYEE_ID]
      ,[EMPLOYEE_IDENTY_ID]
      ,[TC_IDENTY_NO]
              (SELECT TOP (1) EMPLOYEE_EMAIL FROM EMPLOYEES WHERE EMPLOYEE_ID=#SESSION.EP.USERID#) AS SENDER
              FROM   EMPLOYEES
              WHERE        (EMPLOYEE_ID = #RECEIVER_ID#)
        </cfquery>
		
         <cfquery name="ORGANIZATION_STEPS" datasource="#dsn#">
       SELECT 
      [ORGANIZATION_STEP_NAME]   
	 (SELECT TOP (1) EMPLOYEE_EMAIL FROM EMPLOYEES WHERE EMPLOYEE_ID=#SESSION.EP.USERID#) AS SENDER
  FROM [SETUP_ORGANIZATION_STEPS]SOS inner join [EMPLOYEE_POSITIONS]EP

  on EP.ORGANIZATION_STEP_ID = SOS.[ORGANIZATION_STEP_ID] and  EMPLOYEE_ID in ( select EMPLOYEE_ID from employees  ES
  where (ES.EMPLOYEE_ID =#RECEIVER_ID#)
  </cfquery>
  
  <cfquery name="ORGANIZATION_STEPS?1" datasource="#dsn#">
       SELECT 
      COLLAR_TYPE   
	 (SELECT TOP (1) EMPLOYEE_EMAIL FROM EMPLOYEES WHERE EMPLOYEE_ID=#SESSION.EP.USERID#) AS SENDER
  FROM [EMPLOYEE_POSITIONS]

  where  EMPLOYEE_ID in ( select EMPLOYEE_ID from employees  ES
  where (ES.EMPLOYEE_ID =#RECEIVER_ID#)
  </cfquery> 
  
  
		<cfif ISDEFINED('attributes.W_ID_') AND LEN (attributes.W_ID_)>
        
		<cfquery name="Get_Max_Warnings" datasource="#dsn#">
        UPDATE 
        PAGE_WARNINGS
        SET IS_ACTIVE=1,
        EMAIL_WARNING_DATE=#now()#
        where W_ID=#attributes.W_ID_#
        
		SELECT #attributes.W_ID_# AS MAX
        </cfquery>
        <cfelse>
        <cfquery name="Get_Maxi_Paper" datasource="#dsn#">
			SELECT  MAX(PAPER_NO) PAPER_NO FROM PAGE_WARNINGS 
		</cfquery>
        
		<cfif Get_Maxi_Paper.RecordCount and len(Get_Maxi_Paper.Paper_No)>
			<cfset Maxi = Get_Maxi_Paper.Paper_No + 1>
		<cfelse>
			<cfset Maxi = 1>
		</cfif>
        <cfquery name="add_Page_Warnings" datasource="#dsn#">
        DELETE FROM PAGE_WARNINGS WHERE WARNING_HEAD=N'#REPLACE(attributes.REPORT_NAME,"KOA","Master PAYROLL","all")#' AND SETUP_WARNING_ID=<cfif isdefined('attributes.type')>#attributes.type#<cfelse>-2</cfif>
        INSERT INTO
				PAGE_WARNINGS
			(
				PAPER_NO,
				URL_LINK,
				WARNING_HEAD,
				SETUP_WARNING_ID,
				WARNING_DESCRIPTION,
				SMS_WARNING_DATE,
				EMAIL_WARNING_DATE,
				LAST_RESPONSE_DATE,
				RECORD_DATE,
				IS_ACTIVE,
				IS_PARENT,
				RESPONSE_ID,
				RECORD_IP,
				RECORD_EMP,
				POSITION_CODE,
				WARNING_PROCESS,
				OUR_COMPANY_ID,
				PERIOD_ID,
				ACTION_TABLE,
				ACTION_COLUMN,
				ACTION_ID,
				ACTION_STAGE_ID
			)
		VALUES
			(
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Maxi#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#request.self#?fuseaction=report.popupflush_view_saved_report&sr_id=#attributes.SR_ID#">,
				N'#REPLACE(attributes.REPORT_NAME,"KOA","Master PAYROLL","all")#',
                <cfif isdefined('attributes.type')>#attributes.type#<cfelse>-2</cfif>,
				N'Please check the report for approving',
				#NOW()#,
				#NOW()#,
				#NOW()#,
                #NOW()#,
				1,
				1,
				0,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
				#session.ep.USERID#,
				#POSITION_CODE#,
				1,
				#SESSION.EP.company_id#,
				#SESSION.EP.period_id#,
				'SAVED_REPORTS',
				'SR_ID',
				#attributes.SR_ID#,
				0
			)
		</cfquery>
        <cfquery name="Get_Max_Warnings" datasource="#dsn#">
			SELECT MAX(W_ID) MAX FROM PAGE_WARNINGS
		</cfquery>
        <cfquery name="Upd_Warnings" datasource="#dsn#">
			UPDATE PAGE_WARNINGS SET PARENT_ID = #Get_Max_Warnings.Max# WHERE W_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Max_Warnings.Max#">
		</cfquery>
        </cfif>
        
			<cfset sender =session.ep.company_email>
        <cfif len(get_employee_data.SENDER) and find('.org',get_employee_data.SENDER)>
		
		<cfset sender =get_employee_data.SENDER>
        
        </cfif>
        
		
		
        <cfoutput>
        <cfif get_employee_data.recordcount and  len(get_employee_data.EMPLOYEE_EMAIL)>
        <cfmail to="#get_employee_data.EMPLOYEE_EMAIL#"
			from="#session.ep.company#<#sender#>"
			subject="re-send #Replace(attributes.REPORT_NAME,'KOA','Master Payroll')#" type="HTML">
			عزيزي #get_employee_data.employee_name# #get_employee_data.employee_surname#,
			<br/><br/>
			الرجاء الضغط على الرابط أدناه للوصول إلى ومراجعة#Replace(attributes.REPORT_NAME,'KOA','Master Payroll')# تقرير ...    <br/><br/>
			<a href="#employee_domain##request.self#?fuseaction=report.popupflush_view_saved_report&sr_id=#attributes.SR_ID#" target="_blank"><strong>#Replace(attributes.REPORT_NAME,'KOA','Master Payroll')# تقرير</strong></a> <br/><br/>
            <cfif isdefined('type') AND TYPE EQ -10>
            
            <cfelse>
           للموافقة ، يرجى النقر على الرابط أدناه
				<br/><br/>
               <cfset parent_id_ = contentEncryptingandDecodingAES(isEncode:1,content:Get_Max_Warnings.Max,accountKey:'wrk')>
			  <cfset w_id_ = contentEncryptingandDecodingAES(isEncode:1,content:Get_Max_Warnings.Max,accountKey:'wrk')>
              <a href="#employee_domain##request.self#?fuseaction=myhome.popup_dsp_warning&warning_id=#w_id_#&warning_is_active=1&sub_warning_id=#parent_id_#" target="_blank"><strong>#Replace(attributes.REPORT_NAME,'KOA','Master Payroll')# حالة الموافقة </strong></a>
            <br/><br/>
			في حالة حدوث أي مشكلة ، يرجى الاتصال بمديرية الموارد البشرية بالمقر الرئيسي
            </cfif>
            <br/><br/>
            ملاحظة: - تم إرسال هذا البريد من  <strong>نظام تخطيط موارد المؤسسات CME</strong><br/>
			ملاحظة 2: - يرجى عدم الرد على هذا البريد الإلكتروني
		</cfmail>
        </cfif>
         <cfmail to="#sender#"
           from="#session.ep.company#<#session.ep.company_email#>"
			subject="Statuts of sending email for re-send #Replace(attributes.REPORT_NAME,'KOA','Master Payroll')#" type="HTML">
			Dear #get_emp_info(session.ep.POSITION_CODE,1,0)#,
			<br/><br/>
			حسب الموضوع تجدون القائمة أدناه: -   <br/><br/>
			<cfif get_employee_data.recordcount and  len(get_employee_data.EMPLOYEE_EMAIL)>
             #get_employee_data.employee_name#(#get_employee_data.EMPLOYEE_EMAIL#)- أرسلت<br/>
            <cfelseif get_employee_data.recordcount>
            <font color=red>#get_employee_data.employee_name#(#get_employee_data.EMPLOYEE_EMAIL#)- لم ترسل</font><br/>
            </cfif>
            ملاحظة: - تم إرسال هذا البريد من <strong>نظام تخطيط موارد المؤسسات من CME</strong><br/>
		</cfmail>
        </cfoutput>
</cfif>
</cffunction>

<cfif not isdefined('attributes.POSITION_CODE') or (isdefined('attributes.POSITION_CODE') and not len(attributes.POSITION_CODE))>
<script>
		  alert('Sorry the EMPLOYEE you need to send to is not defined!');
		  window.close();
		  </script>
</cfif>
<cfif isdefined('attributes.SR_ID') and len(attributes.SR_ID)>
<cfquery name="get_report" datasource="#DSN#">
SELECT  
       SR_ID
FROM SAVED_REPORTS
where SR_ID=#attributes.SR_ID#
</cfquery>
<cfif not get_report.recordcount>
<script>
		  alert('Sorry the closed report had removed \n please re-close the report');
		   if (window.opener != null && !window.opener.closed)
		  {
			 window.opener.re();
		  }
		  window.close();
		  </script>
          </cfif>
<cfelse>
<script>
		  alert('Sorry the closed report is not AV\n please re-close the report');
		   if (window.opener != null && !window.opener.closed)
		  {
			 window.opener.re();
		  }
		  window.close();
		  </script>
</cfif>

<cfquery name="get_pos" datasource="#DSN#">
SELECT  
        POSITION_CODE,
        EMPLOYEE_ID,
        EMPLOYEE_NAME,
        POSITION_NAME,
        DEPARTMENT_ID,
        (SELECT TOP(1) EMPLOYEE_EMAIL FROM EMPLOYEES WHERE EMPLOYEE_ID=EMPLOYEE_POSITIONS.EMPLOYEE_ID) EMAIL
FROM EMPLOYEE_POSITIONS
where POSITION_CODE=#attributes.POSITION_CODE#
</cfquery>
		<cfoutput query="get_pos">
        <cfif LEN(EMAIL) AND FIND('CME',EMAIL)>
        <cfscript>
        msgg(EMPLOYEE_ID,POSITION_CODE,'#attributes.REPORT_NAME#');
        </cfscript>
        <cfelse>
         <script>
		  alert('Sorry the email of #get_emp_info(attributes.POSITION_CODE,1,0)# is not available or not a member of CME Email\n Please contact the HR');
		  window.close();
		  </script>
          </cfif>
        </cfoutput>
   <script>
		  if (window.opener != null && !window.opener.closed)
		  {
			 window.opener.re();
		  }
		  window.close();
		  </script>
</cfif>
<cfif isdefined('attributes.reger_service')>
      <cfquery name="GET_NO_ALLOCATION" datasource="#DSN#">
      SELECT DISTINCT ALLOCATION_NO,ALLOCATION_NAME
        FROM 
        ALLOCATION_PLAN
        WHERE
            ALLOCATION_MONTH=#attributes.sal_mon# AND
            ALLOCATION_YEAR=#attributes.sal_year#
       
        </cfquery>
        
      <cfquery name="GET_ALLOCATION_PROJECT" datasource="#DSN#">
      SELECT DISTINCT ALLOCATION_NO,ALLOCATION_NAME,#attributes.BRANCH_ID# AS BRANCH_ID
        FROM 
        ALLOCATION_PLAN
        WHERE
            ALLOCATION_MONTH=#attributes.sal_mon# AND
            ALLOCATION_YEAR=#attributes.sal_year# AND
			ALLOCATION_PLAN.EMP_ID IN(#attributes.Get_PROGRAM#)
        order by ALLOCATION_NAME
       
        </cfquery>
        <cfif GET_ALLOCATION_PROJECT.RECORDCOUNT>
        <cfset BID=0>
        
          <cfoutput  query="GET_ALLOCATION_PROJECT">
          <cfif BID NEQ BRANCH_ID>
               <cfset Get_GNRL_RATE=LISTLEN(attributes.Get_PROGRAM)>
               <cfset Get_SUM_EMP=LISTLEN(attributes.Get_SERVICE)>
                   <cfset BID = BRANCH_ID>
                   <cfset TOTAL_GEMP_NO=Get_GNRL_RATE>
                   <cfset TOTAL_SER_EMP_NO=Get_SUM_EMP>
                   </cfif>
        	   <cfquery name="Get_SUM_RATE" datasource="#DSN#">
                      SELECT SUM(ALLOCATION_PLAN.RATE) RATE
                      FROM 
                      ALLOCATION_PLAN
                      WHERE
                          ALLOCATION_MONTH=#attributes.sal_mon# AND
                          ALLOCATION_YEAR=#attributes.sal_year# AND
                          EMP_ID IN(#attributes.Get_PROGRAM#) AND 
                          ALLOCATION_NO LIKE N'#ALLOCATION_NO#' AND 
                          ALLOCATION_NAME LIKE N'#ALLOCATION_NAME#'
                   </cfquery>
                   
              <cfif Get_SUM_RATE.RECORDCOUNT AND Get_SUM_RATE.RATE neq 0  AND Get_SUM_EMP neq 0> 
              
                <cfset TOTL_RATE1=evaluate('#tlformat(Get_SUM_RATE.RATE/TOTAL_GEMP_NO,0)#')>
                  
                 <cfquery datasource="#DSN#">
                      UPDATE  ALLOCATION_PLAN
                      SET RATE= #TOTL_RATE1#
                      FROM 
                      ALLOCATION_PLAN
                      WHERE
                          ALLOCATION_MONTH=#attributes.sal_mon# AND
                          ALLOCATION_YEAR=#attributes.sal_year# AND
                          EMP_ID IN(#attributes.Get_SERVICE#)
                      AND ALLOCATION_NO LIKE N'#ALLOCATION_NO#'
                      AND ALLOCATION_NAME LIKE N'#ALLOCATION_NAME#'
              </cfquery>
             
              <cfelse>
              <cfquery datasource="#DSN#">
                UPDATE       ALLOCATION_PLAN
                SET               RATE=0
                FROM 
                      ALLOCATION_PLAN
                         WHERE
                          ALLOCATION_MONTH=#attributes.sal_mon# AND
                          ALLOCATION_YEAR=#attributes.sal_year# AND
                          EMP_ID IN(#attributes.Get_SERVICE#)
                      AND ALLOCATION_NO LIKE N'#ALLOCATION_NO#'
                      AND ALLOCATION_NAME LIKE N'#ALLOCATION_NAME#'
              </cfquery>
            </cfif>
          </cfoutput>
          
          DONE....
          
        <cfelse>
         عذرا ، البيانات المطلوبة غير متوفرة <br />يرجى التحقق مما إذا تم تحميل ملف  LOE للشهر المحدد .. 
        </cfif>
  <script>
		  if (window.opener != null && !window.opener.closed)
		  {
			 window.opener.re();
		  }
		  window.close();
		  </script>
<cfelse>
<cfparam name="attributes.emp_id" default="">
<cfparam name="attributes.emp_name" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.sal_mon" default="#MONTH(NOW())#">
<cfparam name="attributes.sal_year" default="#session.ep.period_year#">
<cfparam name="attributes.DEPARTMENT_ID" default="">
<cfparam name="attributes.Type_id" default="">
<cfparam name="attributes.Gross_with_adjust" default="">
<cfparam name="attributes.Table" default="1">
<cfparam name="attributes.with_color" default="">
<cfparam name="attributes.new_staff" default="">
<cfparam name="attributes.changed_staff" default="">
<cfparam name="attributes.FUNC" default="">
<cfparam name="attributes.Grant_option" default="">
<cfparam name="attributes.Grant" default="">
<cfparam name="attributes.col_option" default="">

<cfparam name="attributes.allowance" default="">
<cfparam name="attributes.allowance_with" default="">													 
<cfparam name="attributes.deduction" default="">
<cfparam name="attributes.DepartmentXX" default="">
<cfparam name="attributes.Position" default="">
<cfparam name="attributes.Staff_ID" default="">
<cfparam name="attributes.Accounts" default="">


<cfparam name="attributes.DISTRIBUTION" default="">
<cfparam name="attributes.REVIEWER1_id" default="">
<cfparam name="attributes.REVIEWER1_name" default="">

<cfparam name="attributes.REVIEWER2_id" default="">
<cfparam name="attributes.REVIEWER2_name" default="">
<cfparam name="attributes.APPROVAL1_id" default="">
<cfparam name="attributes.APPROVAL1_name" default="">

<cfparam name="attributes.APPROVAL2_id" default="">
<cfparam name="attributes.APPROVAL2_name" default="">

<cfsavecontent variable="ay1"><cf_get_lang_main no='180.Ocak'></cfsavecontent>
<cfsavecontent variable="ay2"><cf_get_lang_main no='181.Şubat'></cfsavecontent>
<cfsavecontent variable="ay3"><cf_get_lang_main no='182.Mart'></cfsavecontent>
<cfsavecontent variable="ay4"><cf_get_lang_main no='183.Nisan'></cfsavecontent>
<cfsavecontent variable="ay5"><cf_get_lang_main no='184.Mayıs'></cfsavecontent>
<cfsavecontent variable="ay6"><cf_get_lang_main no='185.Haziran'></cfsavecontent>
<cfsavecontent variable="ay7"><cf_get_lang_main no='186.Temmuz'></cfsavecontent>
<cfsavecontent variable="ay8"><cf_get_lang_main no='187.Ağustos'></cfsavecontent>
<cfsavecontent variable="ay9"><cf_get_lang_main no='188.Eylül'></cfsavecontent>
<cfsavecontent variable="ay10"><cf_get_lang_main no='189.Ekim'></cfsavecontent>
<cfsavecontent variable="ay11"><cf_get_lang_main no='190.Kasım'></cfsavecontent>
<cfsavecontent variable="ay12"><cf_get_lang_main no='191.Aralık'></cfsavecontent>
<cfset ay_list = "#ay1#,#ay2#,#ay3#,#ay4#,#ay5#,#ay6#,#ay7#,#ay8#,#ay9#,#ay10#,#ay11#,#ay12#">
<cfset attributes.sal_year_end=attributes.SAL_YEAR>
<cfset attributes.sal_mon_end=attributes.sal_mon>
<cfif not len(attributes.APPROVAL2_name)><cfset attributes.APPROVAL2_id =""></cfif>
<cfif not len(attributes.APPROVAL1_name)><cfset attributes.APPROVAL1_id =""></cfif>

<cfif not len(attributes.REVIEWER1_name)><cfset attributes.REVIEWER1_id =""></cfif>
<cfif not len(attributes.REVIEWER2_name)><cfset attributes.REVIEWER2_id =""></cfif>

 <cfif len(attributes.REVIEWER1_id) and len(attributes.REVIEWER1_name)>
            <cfquery name="get_code" datasource="#DSN#">
         SELECT POSITION_CODE
         FROM EMPLOYEE_POSITIONS
         where EMPLOYEE_ID =#attributes.REVIEWER1_id#
          </cfquery>
          <cfif get_code.RECORDCOUNT>
            <cfset REVIEWER1_code=get_code.POSITION_CODE>
          </cfif>
        </cfif>
        
        <cfif len(attributes.APPROVAL1_id) and len(attributes.APPROVAL1_name)>
            <cfquery name="get_code" datasource="#DSN#">
         SELECT POSITION_CODE
         FROM EMPLOYEE_POSITIONS
         where EMPLOYEE_ID =#attributes.APPROVAL1_id#
          </cfquery>
          <cfif get_code.RECORDCOUNT>
            <cfset APPROVAL1_code=get_code.POSITION_CODE>
          </cfif>
        </cfif>
        <cfif len(attributes.APPROVAL2_id) and len(attributes.APPROVAL2_name)>
            <cfquery name="get_code" datasource="#DSN#">
         SELECT POSITION_CODE
         FROM EMPLOYEE_POSITIONS
         where EMPLOYEE_ID =#attributes.APPROVAL2_id#
          </cfquery>
          <cfif get_code.RECORDCOUNT>
            <cfset APPROVAL2_code=get_code.POSITION_CODE>
          </cfif>
        </cfif>

<cfif attributes.sal_mon eq 1>
				<cfset Prev_MON=12>
                <cfset Prev_YEAR=attributes.SAL_YEAR-1>
                <cfelse>
                <cfset Prev_MON=attributes.sal_mon-1>
                <cfset Prev_YEAR=attributes.SAL_YEAR>
                </cfif>
<cfif attributes.Table eq 2>
<cfset coloption=1>
<cfelse>
<cfset coloption=1>
</cfif>

<cfquery name="ALLOCATION_" datasource="#DSN#">
SELECT DISTINCT ALLOCATION_NO,ALLOCATION_NAME
FROM 
ALLOCATION_PLAN
ORDER BY ALLOCATION_NAME
</cfquery>

<cfform name="form" method="post" action="#request.self#?fuseaction=report.detail_report&report_id=#attributes.report_id#&event=det">
<input name="is_form_submitted" id="is_form_submitted" type="hidden" value="1">
<cfif len(attributes.Type_id) and attributes.Type_id eq 5>
<input name="rep_name" id="rep_name" type="hidden" value="KOA">
<input name="KOA" id="KOA" type="hidden" value="1">
<cfelseif len(attributes.Type_id) and attributes.Type_id eq 1>
<input name="rep_name" id="rep_name" type="hidden" value="SERVICE">
<input name="SERVICE" id="SERVICE" type="hidden" value="1">
</cfif>
<cf_basket_form id="gizli">
<div style="text-align:left">
<select name="sal_mon" id="sal_mon" style="width:75px;">
						<cfloop from="1" to="12" index="i">
						  <cfoutput><option value="#i#" <cfif attributes.sal_mon is i>selected</cfif> >#listgetat(ay_list,i,',')#</option></cfoutput>
						</cfloop>
		</select>
					<select name="sal_year" id="sal_year">
						<cfloop from="#session.ep.period_year#" to="#session.ep.period_year-3#" step="-1" index="i">
							<cfoutput><option value="#i#"<cfif attributes.sal_year eq i> selected</cfif>>#i#</option></cfoutput>
						</cfloop>
					</select>  <cf_wrk_search_button>
       <BR /><BR />
          
<strong>
مكتب الفرع
</strong>   
<cfquery name="get_branch" datasource="#dsn#">
SELECT * FROM BRANCH WHERE BRANCH_STATUS = 1 ORDER BY BRANCH_ID
</cfquery>    
<cfquery name="getdepartment" datasource="#DSN#">
	SELECT distinct DEPARTMENT_HEAD FROM DEPARTMENT ORDER BY DEPARTMENT_HEAD
</cfquery>                    .
<cfset OZEL_KOD='#get_branch.OZEL_KOD#'>
<select name="branch_id" id="branch_id" style="width:160px;" onChange="">
<option value="" selected>الكـــل</option>
                    <cfoutput query="get_branch">
					<option value="#branch_id#" <cfif len(attributes.branch_id) and attributes.branch_id eq branch_id>selected<cfset OZEL_KOD='#OZEL_KOD#'></cfif>>#branch_id# - #branch_name#</option>
					</cfoutput>
                </select>
                        
  <span style="width:120px">
  <input name="Gross_with_adjust" type="checkbox" id="Gross_with_adjust"<cfif isdefined('attributes.Gross_with_adjust') AND LEN(attributes.Gross_with_adjust)>checked </cfif>  />
  أضف إجمالي إلى التعديل لحساب تخصيص الراتب </span><br />  
  <br />
<strong>
نوع التقرير  
</strong>    <select name="Type_id" id="Type_id" style="width:160px;" onchange="state_color(this.value);">
              <option value="5" <cfif len(attributes.Type_id) and attributes.Type_id eq 5>selected</cfif>>الرواتب الرئيسية</option>
              <option value="3" <cfif len(attributes.Type_id) and attributes.Type_id eq 3>selected</cfif>>ملخص KOA for CME</option>
             
                </select>
<div id="collr" style="">
<input name="with_color" type="hidden" id="with_color" value="1"/> 
 <cfquery name="get_FUNC" datasource="#dsn#">
SELECT 
    	UNIT_ID, 
        UNIT_NAME, 
        HIERARCHY,
        UNIT_DETAIL
    FROM 
	    SETUP_CV_UNIT 
    ORDER BY 
    	UNIT_ID
</cfquery>
<table>
    	<tr>
        	<td colspan="4"><strong>إظهار الخيارات</strong></td></tr>
            <tr><td style="width:120px"><select name="col_option" id="col_option" style="width:65px;height:50px;" multiple>
		<option value="1" <cfif ListFind(attributes.col_option,1,',')>selected</cfif>>حصة المؤسسة في التأمين</option>
        <option value="2" <cfif ListFind(attributes.col_option,2,',')>selected</cfif>>التأمين</option>
        <option value="3" <cfif ListFind(attributes.col_option,3,',')>selected</cfif>>ضريبة</option>
                </select>
           </td>
            <select name="Grant_option" id="Grant_option"style="width:160px;"  >
	      <option value="2" <cfif len(attributes.Grant_option) and attributes.Grant_option eq 3>selected</cfif>>توع التقرير</option>
		  <option value="0" <cfif len(attributes.Grant_option) and attributes.Grant_option eq 3>selected</cfif>>جيش</option>
		   <option value="1" <cfif len(attributes.Grant_option) and attributes.Grant_option eq 3>selected</cfif>>مدني</option>
		 
                </select>
            </td>

						 <Td style="width:120px">
			  <input name="allowance_with" type="checkbox" id="allowance_with"<cfif isdefined('attributes.allowance_with') AND  LEN(attributes.allowance_with)>checked </cfif>  /> بدلات خاضعه لضريبه
			  </td>
			  

			<Td style="width:120px">
			  <input name="allowance" type="checkbox" id="allowance"<cfif isdefined('attributes.allowance') AND  LEN(attributes.allowance)>checked </cfif>  /> بدلات  
			  </td>
			  
			  <Td style="width:120px">
			  <input name="deduction" type="checkbox" id="deduction"<cfif isdefined('attributes.deduction') AND LEN(attributes.deduction)>checked </cfif>  /> الاستقطاعات  
			  </td>																																				  
			 
			  
			 
			 </td><td style="width:120px"></td><td style="width:120px"></td>
            
      </tr>
      <tr>
        	<td colspan="5"><strong>خيارات التصفية</strong></td></tr>
    	<tr>
        	<td style="width:120px"> <input name="new_staff" type="checkbox" id="new_staff" <cfif isdefined('attributes.new_staff') AND LEN(attributes.new_staff)>checked </cfif> />الموظفين الجدد فقط <br />
            <input name="changed_staff" type="checkbox" id="changed_staff"<cfif isdefined('attributes.changed_staff') AND LEN(attributes.changed_staff)>checked </cfif>  />فقط تغيير الموظفين</td>
            <td style="width:120px">رقم الموظف<input type="text" name="Staff_ID" id="Staff_ID" value="<cfif isdefined("attributes.Staff_ID") and len(attributes.Staff_ID)><cfoutput>#attributes.Staff_ID#</cfoutput></cfif>"></td>
             <td style="width:120px">المناصب<input type="text" name="Position" id="Position" value="<cfif isdefined("attributes.Position") and len(attributes.Position)><cfoutput>#attributes.Position#</cfoutput></cfif>"></td>
             
             <td style="width:120px">الأقسام
             <select name="DepartmentXX" id="DepartmentXX" onChange="">
<option value="" selected>الكــل</option>
                    <cfoutput query="getdepartment">
					<option value="#DEPARTMENT_HEAD#" <cfif len(attributes.DepartmentXX) and attributes.DepartmentXX eq DEPARTMENT_HEAD>selected</cfif>>#DEPARTMENT_HEAD#</option>
					</cfoutput>
                </select>
            </td>
   </tr>
        <tr>
        <td  colspan="2">Grants<select name="Grant" id="Grant" multiple="multiple" style="width:240px">
                    <cfoutput query="ALLOCATION_">
					<option value="#ALLOCATION_NAME#" <cfif ListFind(attributes.Grant,ALLOCATION_NAME,',')>selected</cfif>>#ALLOCATION_NAME#-#ALLOCATION_NO#</option>
					</cfoutput>
                </select></td>
                <td>Accounts<select name="Accounts" id="Accounts" multiple="multiple" style="width:120px">
                    <cfoutput query="get_FUNC">
					<option value="#UNIT_ID#" <cfif ListFind(attributes.Accounts,UNIT_ID,',')>selected</cfif>>#UNIT_DETAIL#</option>
					</cfoutput>
                    
                </select></td>
        </tr>
          <tr>
        	<td style="width:120px">المراجع <input type="hidden" name="REVIEWER1_id" id="REVIEWER1_id" value="<cfif len(attributes.REVIEWER1_id)><cfoutput>#attributes.REVIEWER1_id#</cfoutput></cfif>">
<input type="text" name="REVIEWER1_name" id="REVIEWER1_name" style="width:100px"  onfocus="AutoComplete_Create('REVIEWER1_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','REVIEWER1_id','form','3','135')" value="<cfif len(attributes.REVIEWER1_name)><cfoutput>#attributes.REVIEWER1_name#</cfoutput></cfif>" autocomplete="off">
<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_name=form.REVIEWER1_name&field_emp_id=form.REVIEWER1_id<cfif fusebox.circuit is "store">&is_store_module=1</cfif>&select_list=1,9','list');return false"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a></td>
          <td style="width:120px">المرافق FAD :-
            <input type="hidden" name="APPROVAL1_id" id="APPROVAL1_id" value="<cfif len(attributes.APPROVAL1_id)><cfoutput>#attributes.APPROVAL1_id#</cfoutput></cfif>">
<input type="text" name="APPROVAL1_name" id="APPROVAL1_name" style="width:100px" onfocus="AutoComplete_Create('APPROVAL1_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','APPROVAL1_id','form','3','135')" value="<cfif len(attributes.APPROVAL1_name)><cfoutput>#attributes.APPROVAL1_name#</cfoutput></cfif>" autocomplete="off">
<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_name=form.APPROVAL1_name&field_emp_id=form.APPROVAL1_id<cfif fusebox.circuit is "store">&is_store_module=1</cfif>&select_list=1,9','list');return false"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>
</td>
          <td style="width:120px">الموافق CD :-

  <input type="hidden" name="APPROVAL2_id" id="APPROVAL2_id" value="<cfif len(attributes.APPROVAL2_id)><cfoutput>#attributes.APPROVAL2_id#</cfoutput></cfif>">
<input type="text" name="APPROVAL2_name" id="APPROVAL2_name" style="width:100px" onfocus="AutoComplete_Create('APPROVAL2_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','APPROVAL2_id','form','3','135')" value="<cfif len(attributes.APPROVAL2_name)><cfoutput>#attributes.APPROVAL2_name#</cfoutput></cfif>" autocomplete="off">
<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_name=form.APPROVAL2_name&field_emp_id=form.APPROVAL2_id<cfif fusebox.circuit is "store">&is_store_module=1</cfif>&select_list=1,9','list');return false"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>
</td>
        </tr>
    </table>    
            
     
        </div>
                <br />

				<select name="distribution" id="distribution" style="width:160px;">
                    <option value="1">بعد التوزيع</option>
                    <option value="2" <cfif len(attributes.distribution) and attributes.distribution eq 2>selected</cfif>>قبل التوزيع</option>
                    
      </select></div>
         <cf_basket_form_button> 
        <cf_wrk_search_button button_type='1' is_excel='0'>
    </cf_basket_form_button>
</cf_basket_form>                     
</cfform>
<div id="detail_report_div">
<cfif isdefined("attributes.is_form_submitted")>
<cffunction name="getimpdata">
  <cfargument name="type" required="yes">
   <cfargument name="id" required="yes">
    <cfif type eq 1>
    <cfset data=''>
    <cfquery name="GET_FILES" datasource="#dsn#">
   SELECT 
        	EMPLOYEE_ID,
            ASSET_FILE AS ASSET_FILE_NAME
        FROM 
    	   EMPLOYEE_EMPLOYMENT_ROWS,
		   SETUP_EMPLOYMENT_ASSET_CAT
		where 
		SETUP_EMPLOYMENT_ASSET_CAT.ASSET_CAT_ID=EMPLOYEE_EMPLOYMENT_ROWS.ASSET_CAT_ID
		and EMPLOYEE_ID=<cfif NOT LEN(id)>0<cfelse>#id#</cfif>
        and (ASSET_CAT LIKE 'Signature%')
</cfquery>
    <cfelse>
    <cfquery name="GET_FILES" datasource="#dsn#">
   SELECT 
        	EMPLOYEE_ID,
            ASSET_FILE AS ASSET_FILE_NAME
        FROM 
    	   EMPLOYEE_EMPLOYMENT_ROWS,
		   SETUP_EMPLOYMENT_ASSET_CAT
		where 
		SETUP_EMPLOYMENT_ASSET_CAT.ASSET_CAT_ID=EMPLOYEE_EMPLOYMENT_ROWS.ASSET_CAT_ID
		and EMPLOYEE_ID=(select EMPLOYEE_ID from EMPLOYEE_POSITIONS where POSITION_CODE=#id#)
        and (ASSET_CAT LIKE 'Signature%')
</cfquery>
     </cfif>
     <cfif GET_FILES.recordcount>
       <span style="mso-ignore:vglayout;position: absolute;z-index:1;margin-left:0px;margin-top:0px;">
       <img width="70" src="documents/hr/#GET_FILES.ASSET_FILE_NAME#" v:shapes="Picture_x0020_1"></span>
       <cfelse>
       
     </cfif>
  </cffunction>
 <cfquery name="Get_signs" datasource="#dsn#">
                       SELECT        
                    SAVED_REPORTS.SR_ID, 
                    PAGE_WARNINGS.ACTION_STAGE_ID, 
                    PAGE_WARNINGS.WARNING_HEAD,
                    PAGE_WARNINGS.SETUP_WARNING_ID, 
                     PAGE_WARNINGS.POSITION_CODE, 
                     PAGE_WARNINGS.RECORD_EMP, 
                     PAGE_WARNINGS.RECORD_DATE,
                     PAGE_WARNINGS.WARNING_RESULT,
					 PAGE_WARNINGS.LAST_RESPONSE_DATE,
                     EMAIL_WARNING_DATE,
                     PAGE_WARNINGS.W_ID,
                     (SELECT TOP(1) SV.RECORD_EMP FROM SAVED_REPORTS SV WHERE SV.REPORT_NAME LIKE 'HR_REPORT_#attributes.sal_mon#_#attributes.sal_year#') HR_ID,
                      (SELECT TOP(1) SV.RECORD_DATE FROM SAVED_REPORTS SV WHERE SV.REPORT_NAME LIKE 'HR_REPORT_#attributes.sal_mon#_#attributes.sal_year#') HR_DATE,
                     (SELECT TOP(1) POSITION_NAME FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_POSITIONS.EMPLOYEE_ID = ISNULL((SELECT TOP(1) SV.RECORD_EMP FROM SAVED_REPORTS SV WHERE SV.REPORT_NAME LIKE 'HR_REPORT_#attributes.sal_mon#_#attributes.sal_year#'),-1)) HR_POSITION_NAME,
                     (SELECT TOP(1) POSITION_NAME FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_POSITIONS.POSITION_CODE = PAGE_WARNINGS.POSITION_CODE) POSITION_NAME,
                     (SELECT TOP(1) POSITION_NAME FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_POSITIONS.EMPLOYEE_ID = PAGE_WARNINGS.RECORD_EMP )POSITION_NAME1,
                     CASE WHEN WARNING_RESULT LIKE 'Appr%' then (SELECT TOP(1) WR.RECORD_DATE from PAGE_WARNINGS WR WHERE  WR.PARENT_ID<>WR.W_ID AND PAGE_WARNINGS.PARENT_ID =WR.PARENT_ID) ELSE NULL END AS APPROVE_DATE
FROM            SAVED_REPORTS INNER JOIN
                         PAGE_WARNINGS ON SAVED_REPORTS.SR_ID = PAGE_WARNINGS.ACTION_ID
                         
WHERE         
         PAGE_WARNINGS.SETUP_WARNING_ID in(-2,-3) AND 
         
         (PAGE_WARNINGS.WARNING_HEAD LIKE 'KOA_#attributes.sal_mon#_#attributes.sal_year#' OR PAGE_WARNINGS.WARNING_HEAD LIKE 'Master PAYROLL_#attributes.sal_mon#_#attributes.sal_year#') AND 
        
         (PAGE_WARNINGS.WARNING_PROCESS=1)
         ORDER BY SETUP_WARNING_ID
                    </cfquery>
                    <cfquery name="Get_REVIEW" datasource="#dsn#">
                       SELECT        
                    SAVED_REPORTS.SR_ID, 
                    PAGE_WARNINGS.ACTION_STAGE_ID, 
                    PAGE_WARNINGS.WARNING_HEAD, 
                    PAGE_WARNINGS.SETUP_WARNING_ID, 
                     PAGE_WARNINGS.POSITION_CODE, 
                     PAGE_WARNINGS.RECORD_EMP,
                     PAGE_WARNINGS.RECORD_DATE,
                     EMAIL_WARNING_DATE,
                     PAGE_WARNINGS.WARNING_RESULT,
                     PAGE_WARNINGS.W_ID,
                     (SELECT TOP(1) SV.RECORD_EMP FROM SAVED_REPORTS SV WHERE SV.REPORT_NAME LIKE 'HR_REPORT_#attributes.sal_mon#_#attributes.sal_year#') HR_ID,
                     (SELECT TOP(1) SV.RECORD_DATE FROM SAVED_REPORTS SV WHERE SV.REPORT_NAME LIKE 'HR_REPORT_#attributes.sal_mon#_#attributes.sal_year#') HR_DATE,
                     (SELECT TOP(1) POSITION_NAME FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_POSITIONS.EMPLOYEE_ID = ISNULL((SELECT TOP(1) SV.RECORD_EMP FROM SAVED_REPORTS SV WHERE SV.REPORT_NAME LIKE 'HR_REPORT_#attributes.sal_mon#_#attributes.sal_year#'),-1)) HR_POSITION_NAME,
                     (SELECT TOP(1) POSITION_NAME FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_POSITIONS.POSITION_CODE = PAGE_WARNINGS.POSITION_CODE) POSITION_NAME,
                     (SELECT TOP(1) POSITION_NAME FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_POSITIONS.EMPLOYEE_ID = PAGE_WARNINGS.RECORD_EMP )POSITION_NAME1,
                     CASE WHEN PAGE_WARNINGS.WARNING_RESULT LIKE 'Appr%' then (SELECT TOP(1) WR.RECORD_DATE from PAGE_WARNINGS WR WHERE  WR.PARENT_ID<>WR.W_ID AND PAGE_WARNINGS.PARENT_ID =WR.PARENT_ID) ELSE NULL END AS APPROVE_DATE
FROM            SAVED_REPORTS INNER JOIN
                         PAGE_WARNINGS ON SAVED_REPORTS.SR_ID = PAGE_WARNINGS.ACTION_ID
WHERE     
         (PAGE_WARNINGS.SETUP_WARNING_ID = - 1) AND 
         <cfif len(attributes.Type_id) and attributes.Type_id neq 1>
         (PAGE_WARNINGS.WARNING_HEAD LIKE 'KOA_#attributes.sal_mon#_#attributes.sal_year#' OR PAGE_WARNINGS.WARNING_HEAD LIKE 'Master PAYROLL_#attributes.sal_mon#_#attributes.sal_year#') AND 
         <cfelse>
         (PAGE_WARNINGS.WARNING_HEAD LIKE 'SERVICE_#attributes.sal_mon#_#attributes.sal_year#') AND 
         </cfif>
         (PAGE_WARNINGS.WARNING_PROCESS=1)
                    </cfquery>

<cfset MONTH_DAYS=30>
<cfquery name="GET_MONTH_DAYS" datasource="#DSN#">
 SELECT datediff(day, CONCAT(#attributes.sal_mon#,'/','01', '/',#attributes.sal_year#), dateadd(month, 1, CONCAT(#attributes.sal_mon#,'/','01', '/',#attributes.sal_year#))) AS MONTH_DAYS
</cfquery>
<cfif GET_MONTH_DAYS.recordcount>
<cfif GET_MONTH_DAYS.MONTH_DAYS lte 30>
<cfset MONTH_DAYS=GET_MONTH_DAYS.MONTH_DAYS></cfif></cfif>


<cfquery name="GET_ALLOCATION_PROJECT" datasource="#DSN#">
SELECT DISTINCT ALLOCATION_NO,ALLOCATION_NAME
FROM 
ALLOCATION_PLAN
WHERE
    ALLOCATION_MONTH=#attributes.sal_mon# AND
    ALLOCATION_YEAR=#attributes.sal_year#
    
    
     <cfif len(attributes.Type_id) and attributes.Type_id neq 3 AND LEN(attributes.Grant)>
     AND ( <cfloop from="1" to="#LISTLEN(attributes.Grant)#" index="I">
            ALLOCATION_NAME LIKE '#listgetat(attributes.Grant,I,',')#' 
            <cfif I NEQ LISTLEN(attributes.Grant)>
            OR </cfif>
            </cfloop>)
     </cfif>
order by ALLOCATION_NAME
</cfquery>
<cfscript>
		get_puantaj_ = createObject("component", "v16.hr.ehesap.cfc.get_dynamic_bordro");
		get_puantaj_.dsn = dsn;
		get_puantaj_.dsn_alias = dsn_alias;
		get_puantaj_rows = get_puantaj_.get_dynamic_bordro

		(
			sal_year : attributes.sal_year,
			sal_mon : attributes.sal_mon,
			sal_year_end : attributes.sal_year_end,
			sal_mon_end : attributes.sal_mon_end,
			puantaj_type : -1,
			branch_id: '#iif(isdefined("attributes.branch_id"),"attributes.branch_id",DE(""))#' ,
			comp_id: '#iif(isdefined("attributes.comp_id"),"attributes.comp_id",DE(""))#',
			department:'#iif(isdefined("attributes.department"),"attributes.department",DE(""))#',
			position_branch_id:'#iif(isdefined("attributes.position_branch_id"),"attributes.position_branch_id",DE(""))#',
			position_department:'#iif(isdefined("attributes.position_department"),"attributes.position_department",DE(""))#',
			is_all_dep:'#iif(isdefined("attributes.is_all_dep"),"attributes.is_all_dep",DE(""))#',
			is_dep_level:'#iif(isdefined("attributes.is_dep_level"),"attributes.is_dep_level",DE(""))#',
			ssk_statute:'#iif(isdefined("attributes.ssk_statute"),"attributes.ssk_statute",DE(""))#',
			duty_type:'#iif(isdefined("attributes.duty_type"),"attributes.duty_type",DE(""))#',
			main_payment_control:'#iif(isdefined("attributes.main_payment_control"),"attributes.main_payment_control",DE(""))#',
			department_level:'#iif(isdefined("attributes.is_dep_level"),"1","0")#',
			expense_center:'#iif(isdefined("attributes.expense_center"),"attributes.expense_center",DE(""))#'
		);
	</cfscript>
 <cfquery name="ddd_trad" datasource="#dsn#">
	 select DEPARTMENT_ID from DEPARTMENT where IS_PRODUCTION =1
	 </cfquery>

    <cfquery name="ddd" datasource="#dsn#">
  SELECT IN_OUT_ID FROM EMPLOYEES_IN_OUT 
   <cfif len(attributes.Type_id) and attributes.Type_id NEQ 1>
  WHERE MONTH(ISNULL(FINISH_DATE,'1990-01-01')) <> CASE WHEN YEAR(ISNULL(FINISH_DATE,'1990-01-01'))=#attributes.sal_year# THEN #attributes.sal_mon# ELSE 0 END
  AND SALARY_TYPE = 2
  <cfif attributes.Type_id EQ 5 AND isdefined('attributes.new_staff') AND LEN(attributes.new_staff)>
   AND  MONTH(START_DATE)=#attributes.sal_mon# AND YEAR(START_DATE)=#attributes.sal_year# 
 </cfif>
  
  <cfelse>
    WHERE SALARY_TYPE = 1
  </cfif>
  <cfif get_puantaj_rows.RECORDCOUNT>
  AND IN_OUT_ID IN (#VALUELIST(get_puantaj_rows.IN_OUT_ID)#)
  <cfelse>
  AND 1=0
  </cfif>
 
   <cfif len(attributes.Grant_option)  and attributes.Grant_option EQ 0> 
  AND department_id not in (#VALUELIST(ddd_trad.department_id)#)
  <cfelseif len(attributes.Grant_option)  and attributes.Grant_option EQ 1> 
  AND department_id  in (#VALUELIST(ddd_trad.department_id)#)
 </cfif>
  
</cfquery>
<cfquery name="getserv" dbtype="query">
   SELECT EMPLOYEE_ID,BRANCH_ID FROM get_puantaj_rows WHERE FUNC_ID=2
</cfquery>
<cfif LEN(attributes.Grant)>
<cfquery name="GET_ALLCTION" datasource="#dsn#">
  SELECT EMP_ID
        FROM 
        ALLOCATION_PLAN
        WHERE
            ALLOCATION_MONTH=#attributes.sal_mon# AND
            ALLOCATION_YEAR=#attributes.sal_year# AND(
            <cfloop from="1" to="#LISTLEN(attributes.Grant)#" index="I">
             <cfif attributes.distribution EQ 2>
             <cfif FIND('YEM Service',listgetat(attributes.Grant,I,','))>
            ( (EMP_ID IN(#VALUELIST(getserv.EMPLOYEE_ID)#)) 
             OR (EMP_ID NOT IN(#VALUELIST(getserv.EMPLOYEE_ID)#) AND ALLOCATION_NAME LIKE '#listgetat(attributes.Grant,I,',')#'  AND RATE<>0))
             <cfelse>
             (EMP_ID NOT IN(#VALUELIST(getserv.EMPLOYEE_ID)#) AND ALLOCATION_NAME LIKE '#listgetat(attributes.Grant,I,',')#'  AND RATE<>0)
             </cfif>
               <cfelse>
               ( ALLOCATION_NAME LIKE '#listgetat(attributes.Grant,I,',')#'  AND RATE<>0)
              </cfif>
            <cfif I NEQ LISTLEN(attributes.Grant)>
            OR </cfif>
            </cfloop>
            )
</cfquery>
</cfif>
<cfquery name="ddd_" dbtype="query">
  select * from get_puantaj_rows  
  WHERE 
  
  IN_OUT_ID IN(<cfif ddd.RECORDCOUNT>#VALUELIST(ddd.IN_OUT_ID)#<cfelse>0</cfif>)
  <cfif len(attributes.Type_id) and attributes.Type_id eq 5>
 <cfif isdefined("attributes.Staff_ID") and len(attributes.Staff_ID)>
 AND EMPLOYEE_NO LIKE '%#attributes.Staff_ID#%'
 </cfif>
  <cfif isdefined("attributes.Position") and len(attributes.Position)>
  AND POSITION_NAME LIKE '%#attributes.Position#%'
  </cfif>
  <cfif isdefined("attributes.DepartmentXX") and len(attributes.DepartmentXX)>
AND DEPARTMENT_HEAD LIKE '#attributes.DepartmentXX#'
</cfif>
<cfif LEN(attributes.Grant)>
   <cfif ISDEFINED('GET_ALLCTION') AND GET_ALLCTION.RECORDCOUNT>
   AND EMPLOYEE_ID IN(#VALUELIST(GET_ALLCTION.EMP_ID)#)
   <cfelse>
   AND 1=0
   </cfif>
</cfif>
<cfif LEN(attributes.Accounts)>
AND FUNC_ID IN (#attributes.Accounts#)
</cfif>
</cfif>
</cfquery>
<cfset get_puantaj_rows=ddd_> 
<cfif len(attributes.Type_id) and attributes.Type_id neq 3 AND NOT LEN(attributes.Grant) AND attributes.distribution NEQ 2>
<cfquery name="GET_ALLOCATION_PROJECT" datasource="#DSN#">
SELECT SUM(RATE),ALLOCATION_NO,ALLOCATION_NAME
FROM 
ALLOCATION_PLAN
WHERE
    ALLOCATION_MONTH=#attributes.sal_mon# AND
    ALLOCATION_YEAR=#attributes.sal_year# AND
    EMP_ID IN (<cfif get_puantaj_rows.RECORDCOUNT>#VALUELIST(get_puantaj_rows.EMPLOYEE_ID)#<cfelse>0</cfif>)
    
     GROUP BY ALLOCATION_NO,ALLOCATION_NAME
     HAVING SUM(RATE) > 0
</cfquery> 
</cfif>
<cfset day_last = createodbcdatetime(createdate(attributes.sal_year_end,attributes.sal_mon_end,daysinmonth(createdate(attributes.sal_year_end,attributes.sal_mon_end,1))))>
<cfset sayfa_no = 0>


<cfscript>
	attributes.startrow = 1;

	t_istisna_odenek = 0;
	t_ssk_matrahi = 0;
	t_gunluk_ucret = 0;
	t_toplam_kazanc = 0;
	t_vergi_indirimi = 0;
	t_sakatlik_indirimi = 0;
	t_kum_gelir_vergisi_matrahi = 0;
	t_gelir_vergisi_matrahi = 0;
	t_gelir_vergisi = 0;
	t_asgari_gecim = 0;
	t_damga_vergisi_matrahi = 0;
	t_damga_vergisi = 0;
	t_mahsup_g_vergisi = 0;	
	t_h_ici = 0;
	t_h_sonu = 0;
	t_toplam_days = 0;
	t_resmi = 0;	
	t_kesinti = 0;
	t_net_ucret = 0;
	t_vergi_iadesi = 0;
	t_ssk_primi_isci = 0;
	t_ssk_primi_isci_devirsiz = 0;
	t_ssk_primi_isveren_hesaplanan = 0;
	t_ssk_primi_isveren = 0;
	t_ssk_primi_isveren_gov = 0;
	t_ssk_primi_isveren_5510 = 0;
	t_ssk_primi_isveren_5084 = 0;
	t_ssk_primi_isveren_5921 = 0;
	t_ssk_primi_isveren_5746 = 0;
	t_ssk_primi_isveren_4691 = 0;
	t_ssk_primi_isveren_6111 = 0;
	t_ssk_primi_isveren_6486 = 0;
	t_ssk_primi_isveren_6322 = 0;
	t_ssk_primi_isci_6322 = 0;
	t_ssk_primi_isveren_14857 = 0;
	
	
	//687 tesvigi
	t_ssk_isveren_hissesi_687 = 0;
	t_ssk_isci_hissesi_687 = 0;
	t_issizlik_isci_hissesi_687 = 0;
	t_issizlik_isveren_hissesi_687 = 0;
	t_gelir_vergisi_indirimi_687 = 0;
	t_damga_vergisi_indirimi_687 = 0;
	
	//7103 tesvigi
	t_ssk_isveren_hissesi_7103 = 0;
	t_ssk_isci_hissesi_7103 = 0;
	t_issizlik_isci_hissesi_7103 = 0;
	t_issizlik_isveren_hissesi_7103 = 0;
	t_gelir_vergisi_indirimi_7103 = 0;
	t_damga_vergisi_indirimi_7103 = 0;
	
	
	t_toplam_isveren = 0;
	t_toplam_isveren_indirimsiz = 0;
	t_issizlik_isci_hissesi = 0;
	t_issizlik_isveren_hissesi = 0;
	t_kidem_isci_payi = 0;
	t_kidem_isveren_payi = 0;
	t_total_pay_ssk_tax = 0;
	t_total_pay_ssk = 0;
	t_total_pay_tax = 0;
	t_total_pay = 0;
	t_onceki_aydan_devreden_kum_mat = 0;
	t_ozel_kesinti = 0;
	t_sgk_normal_gun = 0;
	t_ssk_days = 0;
	t_days = 0;
	sayac = 0;
	ssk_count = 0;
	t_work_days = 0;
	id_list = '';
	t_ssdf_ssk_days = 0;
	t_izin = 0;
	t_izin_paid = 0;
	t_paid_izinli_sunday_count = 0;
	t_sundays = 0;
	t_offdays = 0;
	t_offdays_sundays = 0;
	t_offdays_sundays = 0;
	t_ssdf_sundays = 0;
	t_ssdf_days = 0;
	t_ssdf_izin_days = 0;
	t_ssdf_matrah = 0;
	t_ssdf_isci_hissesi = 0;
	t_ssdf_isveren_hissesi = 0;
	t_aylik_ucret = 0;
	t_aylik = 0;
	t_kanun = 0;
	t_aylik_fazla = 0;
	t_aylik_fazla_mesai_net = 0;
	normal_gun_total = 0;
	haftalik_tatil_total = 0;
	genel_tatil_total = 0;
	izin_total = 0;
	yillik_izin_total = 0;
	mahsup_g_vergisi_ = 0;
	t_maas = 0;
	t_gelir_vergisi_indirimi_5746 = 0;
	t_gelir_vergisi_indirimi_5746_ = 0; //gelir vergisi hesaplanandan dusulmesi icin ayrıldı
	t_gelir_vergisi_indirimi_4691 = 0;
	t_gelir_vergisi_indirimi_4691_ = 0; //gelir vergisi hesaplanandan dusulmesi icin ayrıldı
	t_yillik_izin = 0;
	t_kidem_amount = 0;
	t_ihbar_amount = 0;
	t_vergi_istisna_total = 0;
	t_vergi_istisna_ssk = 0;
	t_vergi_istisna_ssk_net = 0;
	t_vergi_istisna_vergi = 0;
	t_vergi_istisna_vergi_net = 0;
	t_vergi_istisna_damga = 0;
	t_vergi_istisna_damga_net = 0;
	t_devir_fark = 0;
	t_ssk_devir = 0;
	t_ssk_devir_last = 0;
	t_ssk_amount = 0;
	t_onceki_donem_kum_gelir_vergisi_matrahi = 0;
	t_sgk_isci_hissesi_fark = 0;
	t_sgk_issizlik_hissesi_fark = 0;
	t_sgdp_isci_primi_fark = 0;
	gt_hi_saat = 0;
	gt_ht_saat = 0;
	gt_gt_saat = 0;
	gt_paid_izin_saat = 0;
	gt_paid_ht_izin_saat = 0;
	gt_izin_saat = 0;
	gt_toplam_saat = 0;
	gt_gece_mesai_saat = 0;
	dt_izin_saat = 0;
	d_agi_oncesi_net = 0;
	t_agi_oncesi_net = 0;
	t_avans = 0;
	d_t_avans = 0;
	d_t_ssk_matrahi = 0;
	d_t_gunluk_ucret = 0;
	d_t_toplam_kazanc = 0;
	d_t_vergi_indirimi = 0;
	d_t_sakatlik_indirimi = 0;
	d_t_kum_gelir_vergisi_matrahi = 0;
	d_t_gelir_vergisi_matrahi = 0;
	d_t_gelir_vergisi = 0;
	d_t_asgari_gecim = 0;
	d_t_gelir_vergisi=0;
	
	d_t_damga_vergisi_matrahi = 0;
	d_t_damga_vergisi = 0;
	d_t_mahsup_g_vergisi = 0;	
	d_t_h_ici = 0;
	d_t_h_sonu = 0;
	d_t_toplam_days = 0;
	d_t_resmi = 0;	
	d_t_kesinti = 0;
	
	
	

	d_t_net_with=0;
	d_t_diff=0;
	d_t_adv=0;
	
	
	d_t_net_ucret = 0;
	d_t_ssk_primi_isci = 0;
	d_t_bes_isci_hissesi = 0;
	d_t_ssk_primi_isveren_hesaplanan = 0;
	d_t_ssk_primi_isveren = 0;
	d_t_ssk_primi_isveren_gov = 0;
	d_t_ssk_primi_isveren_5510 = 0;
	d_t_ssk_primi_isveren_5084 = 0;
	d_t_ssk_primi_isveren_5921 = 0;
	d_t_ssk_primi_isveren_5746 = 0;
	d_t_ssk_primi_isveren_4691 = 0;
	d_t_ssk_primi_isveren_6111 = 0;
	d_t_ssk_primi_isveren_6486 = 0;
	d_t_ssk_primi_isveren_6322 = 0;
	d_t_ssk_primi_isci_6322 = 0;
	d_t_ssk_primi_isveren_14857 = 0;
	
	
	//687 tesvigi
	d_t_ssk_isveren_hissesi_687 = 0;
	d_t_ssk_isci_hissesi_687 = 0;
	d_t_issizlik_isci_hissesi_687 = 0;
	d_t_issizlik_isveren_hissesi_687 = 0;
	d_t_gelir_vergisi_indirimi_687 = 0;
	d_t_damga_vergisi_indirimi_687 = 0;
	
	//7103 tesvigi
	d_t_ssk_isveren_hissesi_7103 = 0;
	d_t_ssk_isci_hissesi_7103 = 0;
	d_t_issizlik_isci_hissesi_7103 = 0;
	d_t_issizlik_isveren_hissesi_7103 = 0;
	d_t_gelir_vergisi_indirimi_7103 = 0;
	d_t_damga_vergisi_indirimi_7103 = 0;
	
	d_t_toplam_isveren = 0;
	d_t_toplam_isveren_indirimsiz = 0;
	d_t_issizlik_isci_hissesi = 0;
	d_t_issizlik_isveren_hissesi = 0;
	d_t_kidem_isci_payi = 0;
	d_t_kidem_isveren_payi = 0;
	d_t_total_pay_ssk_tax = 0;
	d_t_TOTAL_DAYS = 0;
	d_t_DAMGA_VERGISI_MATRAH =0;
	d_t_DAMGA_VERGISI_MATRAH_days =0;
	d_t_total_pay_ssk = 0;
	d_t_total_pay_tax = 0;
	d_t_total_pay = 0;
	d_t_onceki_aydan_devreden_kum_mat = 0;
	d_t_ozel_kesinti = 0;
	d_t_ssk_days = 0;
	d_t_sgk_normal_gun = 0;
	d_t_days = 0;
	d_sayac = 0;
	d_ssk_count = 0;
	d_t_work_days = 0;
	d_id_list = '';
	d_t_ssdf_ssk_days = 0;
	d_t_izin = 0;
	d_t_izin_paid = 0;
	d_t_paid_izinli_sunday_count = 0;
	d_t_sundays = 0;
	d_t_offdays = 0;
	d_t_offdays_sundays = 0;
	d_t_yillik_izin = 0;
	d_t_offdays_sundays = 0;
	d_t_ssdf_sundays = 0;
	d_t_ssdf_days = 0;
	d_t_ssdf_izin_days = 0;
	d_t_ssdf_matrah = 0;
	d_t_ssdf_isci_hissesi = 0;
	d_t_ssdf_isveren_hissesi = 0;
	d_t_aylik_ucret = 0;
	d_t_aylik = 0;
	d_t_kanun = 0;
	d_t_aylik_fazla = 0;
	d_t_aylik_fazla_mesai_net = 0;
	d_normal_gun_total = 0;
	d_haftalik_tatil_total = 0;
	d_genel_tatil_total = 0;
	d_izin_total = 0;
	d_mahsup_g_vergisi_ = 0;
	d_t_maas = 0;
	d_t_gelir_vergisi_indirimi_5746 = 0;
	d_t_gelir_vergisi_indirimi_5746_ = 0;
	d_t_gelir_vergisi_indirimi_4691 = 0;
	d_t_gelir_vergisi_indirimi_4691_ = 0;
	d_yillik_izin_total = 0;
	d_kidem_amount = 0;
	d_ihbar_amount = 0;
	d_vergi_istisna_total = 0;
	d_vergi_istisna_ssk = 0;
	d_vergi_istisna_ssk_net = 0;
	d_vergi_istisna_vergi = 0;
	d_vergi_istisna_vergi_net = 0;
	d_vergi_istisna_damga = 0;
	d_vergi_istisna_damga_net = 0;
	d_t_devir_fark = 0;
	d_t_ssk_devir = 0;
	d_t_ssk_devir_last = 0;
	d_t_ssk_amount = 0;
	d_net_ucret = 0;
	d_vergi_iadesi = 0;
	d_avans = 0;
	d_ozel_kesinti = 0;
	t_hi_saat = 0;
	t_ht_saat = 0;
	t_gt_saat = 0;
	t_paid_izin_saat = 0;
	t_paid_ht_izin_saat = 0;
	t_izin = 0;

	t_saat = 0;
	t_gece_mesai_saat = 0;
	d_t_onceki_donem_kum_gelir_vergisi_matrahi = 0;
	d_t_sgk_isci_hissesi_fark = 0;
	d_t_sgk_issizlik_hissesi_fark = 0;
	d_t_sgdp_isci_primi_fark = 0;
	t_sgk_isveren_hissesi=0;
	d_t_sgk_isveren_hissesi=0;
	d_t_ssdf_isveren_hissesi=0;
	aylik_brut_ucret = 0;
	t_aylik_brut_ucret = 0;
	t_bes_isci_hissesi=0;
</cfscript>
<cfquery name="GET_EXPENSES" datasource="#iif(fusebox.use_period,"dsn2","dsn")#">
	SELECT 
        EXPENSE, 
        HIERARCHY, 
        EXPENSE_CODE, 
        EXPENSE_ACTIVE 
    FROM 
        EXPENSE_CENTER 
    ORDER BY 
    	EXPENSE_CODE
</cfquery>
<cfset main_expense_list = valuelist(get_expenses.expense_code,';')>
<cfquery name="get_emp_branches" datasource="#DSN#">
	SELECT
		BRANCH_ID
	FROM
		EMPLOYEE_POSITION_BRANCHES
	WHERE
		EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
</cfquery>
<cfset emp_branch_list = valuelist(get_emp_branches.branch_id)>
<cfquery name="get_emp_puantaj_ids" datasource="#dsn#">
        SELECT DISTINCT
			EMPLOYEE_PUANTAJ_ID 
		FROM 
			EMPLOYEES_PUANTAJ_ROWS EPR
			INNER JOIN EMPLOYEES_PUANTAJ EP ON EPR.PUANTAJ_ID = EP.PUANTAJ_ID
			INNER JOIN BRANCH B ON EP.SSK_OFFICE = B.SSK_OFFICE AND EP.SSK_OFFICE_NO = B.SSK_NO
		WHERE 
			(
				(EP.SAL_YEAR > <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND EP.SAL_YEAR < <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#">)
				OR
				(
					EP.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND 
					EP.SAL_MON >= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND
					(
						EP.SAL_YEAR < <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#"> OR
						(EP.SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon_end#"> AND EP.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#">)
					)
				)
				OR
				(
					EP.SAL_YEAR > <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND 
					(
						EP.SAL_YEAR < <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#"> OR
						(EP.SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon_end#"> AND EP.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#">)
					)
				)
				OR
				(
					EP.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#"> AND 
					EP.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#"> AND
					EP.SAL_MON >= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND
					EP.SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon_end#">
				)
			) 
			<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
				AND B.BRANCH_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#attributes.branch_id#">)	
			</cfif>
            <cfif isdefined("attributes.comp_id") and len(attributes.comp_id)>
				AND B.COMPANY_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#attributes.comp_id#">)	
			</cfif>
			<cfif not session.ep.ehesap>AND B.BRANCH_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#emp_branch_list#">)</cfif>
</cfquery>
<cfset employee_puantaj_ids = valuelist(get_puantaj_rows.EMPLOYEE_PUANTAJ_ID)>
<cfquery name="get_kesintis" datasource="#dsn#">
	SELECT 
		PUANTAJ_ID, 
		EMPLOYEE_PUANTAJ_ID, 
		COMMENT_PAY, 
		PAY_METHOD, 
		AMOUNT_2, 
		AMOUNT, 
		SSK, 
		TAX, 
		EXT_TYPE, 
		ACCOUNT_CODE, 
		AMOUNT_PAY
	FROM 
		EMPLOYEES_PUANTAJ_ROWS_EXT
	WHERE 
		<cfif listlen(employee_puantaj_ids)>EMPLOYEE_PUANTAJ_ID IN (#employee_puantaj_ids#)<cfelse>1=0</cfif> AND 
		EXT_TYPE = 1 
	ORDER BY 
		COMMENT_PAY
</cfquery>
<cfquery name="get_kesinti_adlar" dbtype="query">
	SELECT DISTINCT COMMENT_PAY FROM get_kesintis WHERE COMMENT_PAY <> 'Avans' ORDER BY COMMENT_PAY
</cfquery>
<cfset kesinti_names = listsort(valuelist(get_kesinti_adlar.comment_pay),"text","ASC")>
<cfset count_ = 0>
<cfloop list="#kesinti_names#" index="cc">
	<cfset count_ = count_ + 1>
	<cfset 't_kesinti_#count_#' = 0>
	<cfset 'd_t_kesinti_#count_#' = 0>
</cfloop>
<cfquery name="get_odeneks" datasource="#dsn#">
	SELECT 
		EMPLOYEES_PUANTAJ_ROWS_EXT.PUANTAJ_ID, 
		EMPLOYEES_PUANTAJ_ROWS_EXT.EMPLOYEE_PUANTAJ_ID, 
		EMPLOYEES_PUANTAJ_ROWS_EXT.COMMENT_PAY, 
		EMPLOYEES_PUANTAJ_ROWS_EXT.PAY_METHOD, 
		EMPLOYEES_PUANTAJ_ROWS_EXT.AMOUNT_2, 
		EMPLOYEES_PUANTAJ_ROWS_EXT.AMOUNT, 
		EMPLOYEES_PUANTAJ_ROWS_EXT.SSK, 
		EMPLOYEES_PUANTAJ_ROWS_EXT.TAX, 
		EMPLOYEES_PUANTAJ_ROWS_EXT.EXT_TYPE, 
		EMPLOYEES_PUANTAJ_ROWS_EXT.ACCOUNT_CODE, 
		EMPLOYEES_PUANTAJ_ROWS_EXT.AMOUNT_PAY,
		SETUP_PAYMENT_INTERRUPTION.FROM_SALARY,
		SETUP_PAYMENT_INTERRUPTION.CALC_DAYS
	FROM 
		EMPLOYEES_PUANTAJ_ROWS_EXT LEFT JOIN SETUP_PAYMENT_INTERRUPTION
		ON EMPLOYEES_PUANTAJ_ROWS_EXT.COMMENT_PAY_ID = SETUP_PAYMENT_INTERRUPTION.ODKES_ID
	WHERE 
		<cfif listlen(employee_puantaj_ids)>EMPLOYEE_PUANTAJ_ID IN (#employee_puantaj_ids#)<cfelse>1=0</cfif> AND 
		EXT_TYPE = 0 
	ORDER BY 
		COMMENT_PAY
</cfquery>
<cfquery name="get_odenek_adlar" dbtype="query">
	SELECT DISTINCT COMMENT_PAY FROM get_odeneks
</cfquery>
<cfset odenek_names = listsort(valuelist(get_odenek_adlar.comment_pay),"text","ASC")>
<cfset count_ = 0>
<cfloop list="#odenek_names#" index="cc">
	<cfset count_ = count_ + 1>
	<cfset 't_odenek_#count_#' = 0>
	<cfset 'd_t_odenek_#count_#' = 0>
	<cfset 't_odenek_net_#count_#' = 0>
	<cfset 'd_t_odenek_net_#count_#' = 0>
</cfloop>
<cfquery name="get_vergi_istisna" datasource="#dsn#">
	SELECT 
		VERGI_ISTISNA_AMOUNT,
		VERGI_ISTISNA_TOTAL,
		COMMENT_PAY,
		EMPLOYEE_PUANTAJ_ID
	FROM 
		EMPLOYEES_PUANTAJ_ROWS_EXT
	WHERE 
		<cfif listlen(employee_puantaj_ids)>EMPLOYEE_PUANTAJ_ID IN (#employee_puantaj_ids#)<cfelse>1=0</cfif> AND 
		EXT_TYPE = 2 
	ORDER BY 
		COMMENT_PAY
</cfquery>
<cfquery name="get_vergi_istisna_adlar" dbtype="query">
	SELECT DISTINCT COMMENT_PAY FROM get_vergi_istisna
</cfquery>
<cfset vergi_istisna_names = valuelist(get_vergi_istisna_adlar.comment_pay)>
<cfset count_ = 0>
<cfloop list="#vergi_istisna_names#" index="cc">
	<cfset count_ = count_ + 1>
	<cfset 't_vergi_#count_#' = 0>
	<cfset 'd_t_vergi_#count_#' = 0>
	<cfset 't_vergi_net_#count_#' = 0>
	<cfset 'd_t_vergi_net_#count_#' = 0>
</cfloop>
<cfquery name="get_definition" datasource="#DSN#">
	SELECT
		DEFINITION,
		PAYROLL_ID
	FROM
		SETUP_SALARY_PAYROLL_ACCOUNTS_DEFF
    ORDER BY 
    	PAYROLL_ID
</cfquery>
<cfset def_list = listsort(listdeleteduplicates(valuelist(get_definition.payroll_id,',')),'numeric','ASC',',')>

<cfquery name="get_pay_methods" datasource="#dsn#">
	SELECT 
		SP.PAYMETHOD_ID, 
        SP.PAYMETHOD
	FROM 
		SETUP_PAYMETHOD SP,
		SETUP_PAYMETHOD_OUR_COMPANY SPOC
	WHERE
		SP.PAYMETHOD_STATUS = 1
		AND SP.PAYMETHOD_ID = SPOC.PAYMETHOD_ID 
		AND SPOC.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
</cfquery>
<cfset pay_list = listsort(listdeleteduplicates(valuelist(get_pay_methods.PAYMETHOD_ID,',')),'numeric','ASC',',')>
<cfquery name="get_units" datasource="#DSN#">
	SELECT 
    	UNIT_ID, 
        UNIT_NAME, 
        HIERARCHY 
    FROM 
	    SETUP_CV_UNIT 
    ORDER BY 
    	UNIT_ID
</cfquery>
<cfset fonsiyonel_list = listsort(listdeleteduplicates(valuelist(get_units.unit_id,',')),'numeric','ASC',',')>
<cfquery name="get_position_cats" datasource="#DSN#">
	SELECT 
    	POSITION_CAT_ID, 
        POSITION_CAT,
        HIERARCHY 
    FROM 
    	SETUP_POSITION_CAT 
    ORDER BY 
	    POSITION_CAT_ID
</cfquery>
<cfset position_cat_list = listsort(listdeleteduplicates(valuelist(get_position_cats.POSITION_CAT_ID,',')),'numeric','ASC',',')>
<cfquery name="get_titles" datasource="#DSN#">
	SELECT 
    	TITLE_ID, 
        TITLE 
    FROM 
	    SETUP_TITLE 
    ORDER BY 
    	TITLE_ID
</cfquery>
<cfset title_list = listsort(listdeleteduplicates(valuelist(get_titles.TITLE_ID,',')),'numeric','ASC',',')>
<cfquery name="get_branchs" datasource="#DSN#">
	SELECT BRANCH_ID,BRANCH_NAME FROM BRANCH ORDER BY BRANCH_ID
</cfquery>
<cfset branch_list = listsort(listdeleteduplicates(valuelist(get_branchs.BRANCH_ID,',')),'numeric','ASC',',')>
<cfquery name="get_departments" datasource="#DSN#">
	SELECT DEPARTMENT_ID,DEPARTMENT_HEAD FROM DEPARTMENT ORDER BY DEPARTMENT_ID
</cfquery>
<cfset department_list = listsort(listdeleteduplicates(valuelist(get_departments.DEPARTMENT_ID,',')),'numeric','ASC',',')>
<cfquery name="get_dep_lvl" datasource="#dsn#">
    SELECT DISTINCT LEVEL_NO FROM DEPARTMENT WHERE LEVEL_NO IS NOT NULL ORDER BY LEVEL_NO
</cfquery>
<cfset dep_level_list = listsort(valuelist(get_dep_lvl.level_no),"numeric" ,"ASC")>

<cfset type_ = "employee_puantaj_id">


<cfset sayfa_count_ = 0>
<cfparam name="attributes.totalrecords" default="#get_puantaj_rows.recordcount#">
</cfif>

<cfif isdefined("attributes.is_form_submitted") AND  attributes.Type_id EQ 3>
<cfif GET_ALLOCATION_PROJECT.RECORDCOUNT>
<cfquery name="Get_PROGRAM" dbtype="query">
 	SELECT EMPLOYEE_ID FROM get_puantaj_rows WHERE FUNC_ID = 1
</cfquery>
<cfquery name="Get_SUPPORT" dbtype="query">
 	SELECT EMPLOYEE_ID FROM get_puantaj_rows WHERE FUNC_ID = 1
</cfquery>
<cfquery name="Get_SERVICE" dbtype="query">
 	SELECT EMPLOYEE_ID FROM get_puantaj_rows WHERE FUNC_ID = 2
</cfquery>

<cfoutput query="GET_ALLOCATION_PROJECT">
 <cfset 'T_#CURRENTROW#P_GROSS'=0>
 <cfset 'T_#CURRENTROW#P_9TH'=0>
 <cfset 'T_#CURRENTROW#SP_GROSS'=0>
 <cfset 'T_#CURRENTROW#SP_9TH'=0>
 <cfset 'T_#CURRENTROW#SR_GROSS'=0>
 <cfset 'T_#CURRENTROW#SR_9TH'=0>
 
 <cfset 'T_#CURRENTROW#WO_GROSS'=0>
 <cfset 'T_#CURRENTROW#WO_9TH'=0>
</cfoutput>
 <cfset T_P_ROWG=0>
 <cfset T_P_ROW9=0>
  <cfset T_SP_ROWG=0>
 <cfset T_SP_ROW9=0>
  <cfset T_SR_ROWG=0>
 <cfset T_SR_ROW9=0>
 
  <cfset T_WO_ROWG=0>
 <cfset T_WO_ROW9=0>
 
  <cfset CNT_SP=0>
  <cfset EMP_ERR=''>
<cfoutput query="get_puantaj_rows">
 
    <cfloop query="GET_ALLOCATION_PROJECT">
                          <cfquery name="GET_ALLOCATION_rate" datasource="#DSN#">
                            SELECT 
                            
                             <cfif attributes.distribution EQ 2 and get_puantaj_rows.func_id eq 2>
                            <cfif FIND('YEM Service',ALLOCATION_NAME)>
                            100 AS RATE
                            <cfelse>
                            0 AS RATE
                            </cfif>
                            <cfelse>
                            isnull(RATE,0) RATE 
                            </cfif>
                            FROM ALLOCATION_PLAN 
                            WHERE EMP_ID=#get_puantaj_rows.EMPLOYEE_ID# AND  
                            ALLOCATION_MONTH=#attributes.sal_mon# AND
                            ALLOCATION_YEAR=#attributes.sal_year# AND
                            ALLOCATION_NAME LIKE N'#ALLOCATION_NAME#' AND
                            ALLOCATION_NO LIKE N'#ALLOCATION_NO#'
                          </cfquery>
                          <cfif not GET_ALLOCATION_rate.recordcount or not len(GET_ALLOCATION_rate.RATE)><cfset RATE_=0><cfelse><cfset RATE_=GET_ALLOCATION_rate.RATE></cfif>
                          <cfif isdefined('attributes.Gross_with_adjust') AND LEN(attributes.Gross_with_adjust)>
                    <cfset _gross=(get_puantaj_rows.DAMGA_VERGISI_MATRAH/MONTH_DAYS*get_puantaj_rows.TOTAL_DAYS)+get_puantaj_rows.TOTAL_PAY_SSK_TAX>
                    <cfelse>
                    <cfset _gross=get_puantaj_rows.DAMGA_VERGISI_MATRAH/MONTH_DAYS*get_puantaj_rows.TOTAL_DAYS>
                    </cfif>
                    <cfif LISTFIND(VALUELIST(Get_PROGRAM.EMPLOYEE_ID),get_puantaj_rows.EMPLOYEE_ID)>
                    
		<cfset 'T_#CURRENTROW#P_GROSS'=evaluate('T_#CURRENTROW#P_GROSS')+(_gross*RATE_/100)>
        <cfset 'T_#CURRENTROW#P_9th'=evaluate('T_#CURRENTROW#P_9th')+(get_puantaj_rowsISSIZLIK_ISVEREN_HISSESI*RATE_/100)>
         <cfset T_P_ROWG=T_P_ROWG+(_gross*RATE_/100)>
		 <cfset T_P_ROW9=T_P_ROW9+(get_puantaj_rows.ISSIZLIK_ISVEREN_HISSESI*RATE_/100)>
                  <cfelseif LISTFIND(VALUELIST(Get_SUPPORT.EMPLOYEE_ID),get_puantaj_rows.EMPLOYEE_ID)>
                   <cfset CNT_SP=CNT_SP+1>
        <cfset 'T_#CURRENTROW#SP_GROSS'=evaluate('T_#CURRENTROW#SP_GROSS')+(_gross*RATE_/100)>
        <cfset 'T_#CURRENTROW#SP_9th'=evaluate('T_#CURRENTROW#SP_9TH')+(get_puantaj_rows.ISSIZLIK_ISVEREN_HISSESI*RATE_/100)>
        <cfset T_SP_ROWG=T_SP_ROWG+(_gross*RATE_/100)>
		 <cfset T_SP_ROW9=T_SP_ROW9+(get_puantaj_rows.ISSIZLIK_ISVEREN_HISSESI*RATE_/100)>
                    <cfelseif LISTFIND(VALUELIST(Get_SERVICE.EMPLOYEE_ID),get_puantaj_rows.EMPLOYEE_ID)>
        <cfset 'T_#CURRENTROW#SR_GROSS'=evaluate('T_#CURRENTROW#SR_GROSS')+(_gross*RATE_/100)>
        <cfset 'T_#CURRENTROW#SR_9th'=evaluate('T_#CURRENTROW#SR_9TH')+(get_puantaj_rows.ISSIZLIK_ISVEREN_HISSESI*RATE_/100)>  
        <cfset T_SR_ROWG=T_SR_ROWG+(_gross*RATE_/100)>
		 <cfset T_SR_ROW9=T_SR_ROW9+(get_puantaj_rows.ISSIZLIK_ISVEREN_HISSESI*RATE_/100)> 
         <cfelse>
          <!--- <cfset EMP_ERR=EMP_ERR&get_puantaj_rows.EMPLOYEE_ID&','>--->
            <cfset 'T_#CURRENTROW#WO_GROSS'=evaluate('T_#CURRENTROW#WO_GROSS')+(_gross*RATE_/100)>
        <cfset 'T_#CURRENTROW#WO_9th'=evaluate('T_#CURRENTROW#WO_9TH')+(get_puantaj_rows.ISSIZLIK_ISVEREN_HISSESI*RATE_/100)>  
        <cfset T_WO_ROWG=T_WO_ROWG+(_gross*RATE_/100)>
		 <cfset T_WO_ROW9=T_WO_ROW9+(get_puantaj_rows.ISSIZLIK_ISVEREN_HISSESI*RATE_/100)> 
                    </cfif>
                         </cfloop>
  </cfoutput>
<cfquery name="GET_AGG_P_T" dbtype="query">
    SELECT SUM(ISSIZLIK_ISVEREN_HISSESI) AS 9TH,COUNT(EMPLOYEE_ID) No_of_staff,SUM(DAMGA_VERGISI_MATRAH*(TOTAL_DAYS/#MONTH_DAYS#) <cfif isdefined('attributes.Gross_with_adjust') AND LEN(attributes.Gross_with_adjust)>+TOTAL_PAY_SSK_TAX</cfif>) AS GROS FROM get_puantaj_rows
    WHERE EMPLOYEE_ID IN (#VALUELIST(Get_PROGRAM.EMPLOYEE_ID)#)
</cfquery>
<cfquery name="GET_AGG_SP_T" dbtype="query">
    SELECT SUM(ISSIZLIK_ISVEREN_HISSESI) AS 9TH,COUNT(EMPLOYEE_ID) No_of_staff,SUM(DAMGA_VERGISI_MATRAH*(TOTAL_DAYS/#MONTH_DAYS#) <cfif isdefined('attributes.Gross_with_adjust') AND LEN(attributes.Gross_with_adjust)>+TOTAL_PAY_SSK_TAX</cfif>) AS GROS,COUNT(EMPLOYEE_ID) CNT FROM get_puantaj_rows
    WHERE EMPLOYEE_ID IN (#VALUELIST(Get_SUPPORT.EMPLOYEE_ID)#)
</cfquery>
<cfquery name="GET_AGG_SR_T" dbtype="query">
    SELECT SUM(ISSIZLIK_ISVEREN_HISSESI) AS 9TH,COUNT(EMPLOYEE_ID) No_of_staff,SUM(DAMGA_VERGISI_MATRAH*(TOTAL_DAYS/#MONTH_DAYS#) <cfif isdefined('attributes.Gross_with_adjust') AND LEN(attributes.Gross_with_adjust)>+TOTAL_PAY_SSK_TAX</cfif>) AS GROS FROM get_puantaj_rows
    WHERE EMPLOYEE_ID >1
</cfquery>
<cfquery name="GET_AGG_WO_T" dbtype="query">
    SELECT SUM(ISSIZLIK_ISVEREN_HISSESI) AS 9TH,COUNT(EMPLOYEE_ID) No_of_staff,SUM(DAMGA_VERGISI_MATRAH*(TOTAL_DAYS/#MONTH_DAYS#) <cfif isdefined('attributes.Gross_with_adjust') AND LEN(attributes.Gross_with_adjust)>+TOTAL_PAY_SSK_TAX</cfif>) AS GROS FROM get_puantaj_rows
    WHERE EMPLOYEE_ID >1
    AND EMPLOYEE_ID >1
    AND EMPLOYEE_ID >1
</cfquery>

<cfset c_no=1>
   <cfif GET_ALLOCATION_PROJECT.recordcount>
   <cfset c_no=GET_ALLOCATION_PROJECT.recordcount+1>
   </cfif>
<table   class="basket_list" id="list_tb" width="99%">
<cfset row_color="border:1px solid ##000;">
<tr>
   <th rowspan="2" style="border:1px solid #000;">#</th>
   <th  style="border:1px solid #000;"></th>
   <th rowspan="2" style="border:1px solid #000;">فئات</th>
   <th rowspan="2" style="border:1px solid #000;">انواع</th>
   <th rowspan="2" style="border:1px solid #000; text-align:center; width:50px">الحساب</th>
   <th rowspan="2" style="border:1px solid #000; text-align:center; width:50px">عدد الموظفين</th>
    <th colspan="<cfoutput>#c_no#</cfoutput>" style="border:1px solid #000; text-align:center">ALLOCATIONS</th>
    <th rowspan="2" style="border:1px solid #000; text-align:center">STATE</th>
   </tr>
   <tr>
   <cfoutput query="GET_ALLOCATION_PROJECT">
   <th style="border:1px solid ##000; text-align:center">#ALLOCATION_NAME#<cfif FIND('YEM Service',ALLOCATION_NAME)><BR />#ALLOCATION_NO#</cfif></th>
   </cfoutput>
    <th style="border:1px solid #000;"> TOTAL</th>
   </tr>
   <tr style="background-color:rgb(237,254,254)">
   <td rowspan="2"  style="border:1px solid #000;">1</td>
   <td rowspan="2"  style="border:1px solid #000;">PROGRAM</td>
   <td style="border:1px solid #000; text-align:center;background-color:rgb(203,222,254)">GROSS</td>
   <td style="border:1px solid #000;text-align:center;background-color:rgb(203,222,254)">50-30-102</td>
   <td rowspan="2" style="border:1px solid #000;text-align:center"><cfoutput>#GET_AGG_P_T.No_of_staff#</cfoutput></td>
   <cfoutput query="GET_ALLOCATION_PROJECT">
    <td style="border:1px solid ##000; text-align:center;background-color:rgb(203,222,254)">#tlformat(evaluate('T_#CURRENTROW#P_GROSS'))#</td>
   </cfoutput>
    <td style="border:1px solid #000;;background-color:rgb(203,222,254)"> <cfoutput>#tlformat(T_P_ROWG)#</cfoutput></td>
     <cfif GET_AGG_P_T.recordcount and tlformat(GET_AGG_P_T.GROS) NEQ tlformat(T_P_ROWG)>
     <td rowspan="2" style="background:#F00; text-align:center">يجب أن يكون الإجمالي الإجمالي <cfoutput>#tlformat(GET_AGG_P_T.GROS)#</cfoutput></td>
    <cfelse>
    <td rowspan="2" style="border:1px solid #000;"></td>
    </cfif>
   </tr>
    <tr>
   <td style="border:1px solid #000;text-align:center">S.S 12%</td>
   <td style="border:1px solid #000;text-align:center">50-30-110</td>
   <cfoutput query="GET_ALLOCATION_PROJECT">
    <td style="border:1px solid ##000; text-align:center">#tlformat(evaluate('T_#CURRENTROW#P_9TH'))#</td>
   </cfoutput>
    <td  style="border:1px solid #000;text-align:center"> <cfoutput>#tlformat(T_P_ROW9)#</cfoutput></td>
   </tr>
   
   
    <tr>
   <td rowspan="2" style="border:1px solid #000;">2</td>
   <td rowspan="2" style="border:1px solid #000;">SUPPORT</td>
  
   <td style="border:1px solid #000;background-color:rgb(203,222,254)">GROSS</td>
   <td style="border:1px solid #000;text-align:center;background-color:rgb(203,222,254)">50-30-101</td>
   <td rowspan="2" style="border:1px solid #000;text-align:center"><cfoutput>#GET_AGG_SP_T.No_of_staff#</cfoutput></td>
   <cfoutput query="GET_ALLOCATION_PROJECT">
    <td style="border:1px solid ##000; text-align:center;background-color:rgb(203,222,254)">#tlformat(evaluate('T_#CURRENTROW#SP_GROSS'))#</td>
   </cfoutput>
    <td style="border:1px solid #000;background-color:rgb(203,222,254)"> <cfoutput>#tlformat(T_SP_ROWG)#</cfoutput></td>
    <cfif GET_AGG_SP_T.recordcount and tlformat(GET_AGG_SP_T.GROS) NEQ tlformat(T_SP_ROWG)>
     <td rowspan="2" style="background:#F00; text-align:center;border:1px solid #000;" rowspan="2"><span style="background:#F00; text-align:center">Gross Total must be <cfoutput>#tlformat(GET_AGG_SP_T.GROS)#</cfoutput> </span></td>
    <cfelse>
    <td rowspan="2" style="border:1px solid #000;"></td>
    </cfif>
   </tr>
   <tr>
   <td style="border:1px solid #000;text-align:center">S.S 12%</td>
   <td style="border:1px solid #000;text-align:center">50-30-110</td>
   <cfoutput query="GET_ALLOCATION_PROJECT">
    <td style="border:1px solid ##000; text-align:center">#tlformat(evaluate('T_#CURRENTROW#SP_9TH'))#</td>
   </cfoutput>
    <td  style="border:1px solid #000;text-align:center"> <cfoutput>#tlformat(T_SP_ROW9)#</cfoutput></td>
   </tr>
   
   <tr>
   <td rowspan="3" style="border:1px solid #000;">3</td>
   <td rowspan="3"  style="border:1px solid #000;">SERVICE</td>
  
   <td style="border:1px solid #000;background-color:rgb(203,222,254)">GROSS</td>
   <td style="border:1px solid #000;text-align:center;background-color:rgb(203,222,254)">50-30-103</td>
   <td rowspan="3" style="border:1px solid #000;text-align:center"><cfoutput>#GET_AGG_SR_T.No_of_staff#</cfoutput></td>
   <cfoutput query="GET_ALLOCATION_PROJECT">
    <td style="border:1px solid ##000; text-align:center;background-color:rgb(203,222,254)">#tlformat(evaluate('T_#CURRENTROW#SR_GROSS'))#</td>
   </cfoutput>
    <td  style="border:1px solid #000;background-color:rgb(203,222,254)"> <cfoutput>#tlformat(T_SR_ROWG)#</cfoutput></td>
    <cfif GET_AGG_SR_T.recordcount and tlformat(GET_AGG_SR_T.GROS) NEQ tlformat(T_SR_ROWG)>
     <td  rowspan="3"  style="background:#F00;text-align:center;border:1px solid #000;" rowspan="2"> Total must be <cfoutput>#tlformat(GET_AGG_SR_T.GROS)#</cfoutput></td>
    <cfelse>
    <td  rowspan="3"  style="border:1px solid #000;"></td>
    </cfif>
   </tr>
   <tr>
   <td style="border:1px solid #000;text-align:center">S.S 12%</td>
   <td style="border:1px solid #000;text-align:center">50-30-110</td>
   <cfoutput query="GET_ALLOCATION_PROJECT">
    <td style="border:1px solid ##000; text-align:center">#tlformat(evaluate('T_#CURRENTROW#SR_9TH'))#</td>
   </cfoutput>
    <td  style="border:1px solid #000;text-align:center"> <cfoutput>#tlformat(T_SR_ROW9)#</cfoutput></td>
   </tr>
   <tr>
   <td colspan="2" style="border:1px solid #000;text-align:center">Allocation %</td>
   <cfset PERCENT=0>
   <cfoutput query="GET_ALLOCATION_PROJECT">
    <td style="border:1px solid ##000; text-align:center">#tlformat(evaluate('T_#CURRENTROW#SR_GROSS')/GET_AGG_SR_T.GROS*100)#%</td>
    <cfset PERCENT=PERCENT+evaluate('T_#CURRENTROW#SR_GROSS')/GET_AGG_SR_T.GROS*100>
   </cfoutput>
    <td  style="border:1px solid #000;text-align:center"> <cfoutput>#tlformat(PERCENT)#</cfoutput>%</td>
   </tr>
   <cfset nounknownstaff=0>
   <cfif T_WO_ROWG GT 0>
   <cfset nounknownstaff=GET_AGG_WO_T.No_of_staff>
    <tr>
   <td style="border:1px solid #000;">4</td>
   <td style="border:1px solid #000;" >STAFF W/O CATEGORY</td>
   <td style="border:1px solid #000;">GROSS</td>
   <td></td>
   <td  style="border:1px solid #000;text-align:center"><cfoutput>#GET_AGG_WO_T.No_of_staff#</cfoutput></td>
   <cfoutput query="GET_ALLOCATION_PROJECT">
    <td style="border:1px solid ##000; text-align:center">#tlformat(evaluate('T_#CURRENTROW#WO_GROSS'))#</td>
   </cfoutput>
    <td> <cfoutput>#tlformat(T_WO_ROWG)#</cfoutput></td>
     <td style="background:#F00; text-align:center"> لا يفترض أن يتم العثور عليها</td>
   
   </tr>
   
   </cfif>

   <tr>
   
   <td style="border:1px solid #000;text-align:center"><cfoutput>#listlen(valuelist(get_puantaj_rows.EMPLOYEE_ID))#</cfoutput></td>
   <cfoutput query="GET_ALLOCATION_PROJECT">
    <td style="border:1px solid ##006; text-align:center">#tlformat(evaluate('T_#CURRENTROW#P_9TH')+evaluate('T_#CURRENTROW#SP_9TH')+evaluate('T_#CURRENTROW#SR_9TH')+evaluate('T_#CURRENTROW#WO_9TH'))#</td>
   </cfoutput>
   <td style="border:1px solid #006; text-align:center"><cfoutput>#tlformat(T_P_ROW9+T_SP_ROW9+T_SR_ROW9+T_WO_ROW9)#</cfoutput></td>
    <td style="border:1px solid #006;"></td>
   </tr><cfoutput>
                    <cfif Get_signs.RECORDCOUNT OR Get_REVIEW.RECORDCOUNT>
                    <cfset REC_EMP=-1>
					<cfSET REC_POS='Finance Manager'>
                    <cfset REC_DATE=''>
                    <cfset HR_REC_EMP=-1>
                    <cfSET HR_REC_POS='HR & Admin Manager'>
                    <cfset HR_REC_DATE=''>
                    <cfif Get_signs.RECORDCOUNT>
                    <cfSET REC_POS=Get_signs.POSITION_NAME1>
                    <cfSET HR_REC_POS=Get_signs.HR_POSITION_NAME>
					<cfset REC_EMP=Get_signs.RECORD_EMP>
                    
                    <cfif NOT FIND('Finance',Get_signs.POSITION_NAME1) OR NOT FIND('Manager',Get_signs.POSITION_NAME1)>
					<cfSET REC_POS='Acting Finance Manager'>
                    </cfif>
                     <cfset REC_DATE=Get_signs.RECORD_DATE>
                    <cfset HR_REC_EMP=Get_signs.HR_ID>
                    
                    <cfif NOT FIND('HR',Get_signs.HR_POSITION_NAME) OR NOT FIND('Manager',Get_signs.HR_POSITION_NAME)>
					<cfSET HR_REC_POS='Acting HR & Admin Manager'>
                    </cfif>
                    
                    <cfset HR_REC_DATE=Get_signs.HR_DATE>
                    <cfelse>
                    <cfSET REC_POS=Get_REVIEW.POSITION_NAME1>
                    <cfSET HR_REC_POS=Get_REVIEW.HR_POSITION_NAME>
                    <cfset REC_EMP=Get_REVIEW.RECORD_EMP>
                    <cfif NOT FIND('Finance',Get_REVIEW.POSITION_NAME1) OR NOT FIND('Manager',Get_REVIEW.POSITION_NAME1)>
					<cfSET REC_POS='Acting Finance Manager'>
                    </cfif>
                     <cfset REC_DATE=Get_REVIEW.RECORD_DATE>
                    <cfset HR_REC_EMP=Get_REVIEW.HR_ID>
                    <cfif NOT FIND('HR',Get_REVIEW.HR_POSITION_NAME) OR NOT FIND('Manager',Get_REVIEW.HR_POSITION_NAME)>
					<cfSET HR_REC_POS='Acting HR & Admin Manager'>
                    </cfif>
                    <cfset HR_REC_DATE=Get_REVIEW.HR_DATE>
                    </cfif>
                    <tr id="sign">
                    <td colspan="#GET_ALLOCATION_PROJECT.recordcount+2+5#">
                    <table style="width:100%">
                    <tr>
                    <cfset column_total='text-align:center; font-size:12px; width:15%'>
                     <td style="#column_total#"><cfscript>getimpdata(1,REC_EMP);</cfscript>
                       تمت مراجعته من قبل<BR />#get_emp_info(REC_EMP,0,0)#<BR  />#REC_POS#<br /><br />#dateformat(REC_DATE, 'dd-MMM-yyyy ')##TimeFormat(REC_DATE,"HH:mm")#
                      </td>
                      <td style="#column_total#"><cfscript>getimpdata(1,HR_REC_EMP);</cfscript>
                        أعدت بواسطة<BR />#get_emp_info(HR_REC_EMP,0,0)#<BR  />#HR_REC_POS#<br /><br />#dateformat(HR_REC_DATE, 'dd-MMM-yyyy ')##TimeFormat(HR_REC_DATE,"HH:mm")#
                      </td>
                     
                       <cfif not len(Get_REVIEW.WARNING_RESULT)>
                        <td style="#column_total#">
                        <font color="RED"> لم تتم المراجعة حتى الآن<br />#get_emp_info(Get_REVIEW.POSITION_CODE,1,0)#<br /><cfif NOT FIND('Compliance',Get_REVIEW.POSITION_NAME) OR NOT FIND('Manager',Get_REVIEW.POSITION_NAME)>القائم بأعمال مدير الامتثال<cfelse>#Get_REVIEW.POSITION_NAME#</cfif></font></td>
                        <cfelseif find('Rejec',Get_REVIEW.WARNING_RESULT)>
                        <td style="#column_total#">
                        <font color="RED"> مرفوض من طرف<br />#get_emp_info(Get_REVIEW.POSITION_CODE,1,0)#<br /><cfif NOT FIND('Compliance',Get_REVIEW.POSITION_NAME) OR NOT FIND('Manager',Get_REVIEW.POSITION_NAME)>
                         العمل بالامتثال Manager<cfelse>#Get_REVIEW.POSITION_NAME#</cfif></font></td>
                        <cfelseif find('Appro',Get_REVIEW.WARNING_RESULT)>
                        <td style="text-align:center; font-size:12px">
						<cfscript>getimpdata(2,Get_REVIEW.POSITION_CODE);</cfscript>
                        أكد عن طريق<br />#get_emp_info(Get_REVIEW.POSITION_CODE,1,0)#<br /><cfif NOT FIND('Compliance',Get_REVIEW.POSITION_NAME) OR NOT FIND('Manager',Get_REVIEW.POSITION_NAME)>
                          العمل بالامتثال Manager<cfelse>#Get_REVIEW.POSITION_NAME#</cfif><br /><br />#dateformat(Get_REVIEW.APPROVE_DATE, 'dd-MMM-yyyy ')##TimeFormat(Get_REVIEW.APPROVE_DATE,"HH:mm")#</td>
                      </cfif>
                       <td style="text-align:center; font-size:12px; width:25%"></td>
                       
                       <cfloop query="Get_signs">
                        <cfset sign_possition=Get_signs.POSITION_NAME>
                       
                      <cfif currentrow eq 1>
                       
                       <cfif NOT FIND('Finance',Get_signs.POSITION_NAME) OR NOT FIND('Director',Get_signs.POSITION_NAME)>
                       <cfset sign_possition='المراجع المالي'>
                       </cfif>
                       <cfelse>
                       <cfif NOT FIND('Country',Get_signs.POSITION_NAME) OR NOT FIND('Director',Get_signs.POSITION_NAME)>
                       <cfset sign_possition='المدير التنفيذي'>
                       </cfif>
                       
                       </cfif>
                       
                        <cfif not len(Get_signs.WARNING_RESULT)>
                        <td style="#column_total#">
                        <font color="RED"> لم تتم الموافقة عليها بعد<br />#get_emp_info(Get_signs.POSITION_CODE,1,0)#<br />#sign_possition#</font></td>
                        <cfelseif find('Rejec',Get_signs.WARNING_RESULT)>
                        <td style="#column_total#">
                        <font color="RED"> مرفوض من طرف<br />#get_emp_info(Get_signs.POSITION_CODE,1,0)#<br />#sign_possition#</font></td>
                        <cfelseif find('Appro',Get_signs.WARNING_RESULT)>
                        <td style="#column_total#"><cfscript>getimpdata(2,Get_signs.POSITION_CODE);</cfscript>
                        تمت الموافقة عليه من قبل<br />#get_emp_info(Get_signs.POSITION_CODE,1,0)#<br />#sign_possition#<br /><br />#dateformat(Get_signs.APPROVE_DATE, 'dd-MMM-yyyy ')##TimeFormat(Get_signs.APPROVE_DATE,"HH:mm")#</td>
                        </cfif>
                      </cfloop>
                    </tr>
                    </table>
                    </td>
                    </tr>
                    </cfif>  </cfoutput>                
   <cfquery name="find_closed_state" datasource="#DSN#">
      SELECT * FROM SAVED_REPORTS
      WHERE REPORT_NAME LIKE 'FINAL_KOA_#attributes.sal_mon#_#attributes.sal_year#' 
      <!---<cfif attributes.sal_mon neq 12>
      <cfloop from="#attributes.sal_mon+1#" to="12" index="i">
      OR REPORT_NAME LIKE 'FINAL_KOA_#i#_#attributes.sal_year#'  
      </cfloop>
      </cfif>--->
   </cfquery>
   
   <cfoutput>
   
   <cfif not find_closed_state.recordcount and len(attributes.branch_id)>
   <tr>
     <td colspan="#7+GET_ALLOCATION_PROJECT.recordcount#" style="text-align:RIGHT">من أجل توزيع النسب المئوية LOA  الجديدة لموظفي الخدمة ، يرجى النقر <strong><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=report.detail_report&report_id=#attributes.report_id#&reger_service&sal_mon=#attributes.sal_mon#&sal_year=#attributes.sal_year#&BRANCH_ID=#attributes.branch_id#&Get_PROGRAM=#valuelist(Get_PROGRAM.EMPLOYEE_ID)#&Get_SERVICE=#valuelist(Get_SERVICE.EMPLOYEE_ID)#','small');">HERE</a></strong></td></tr>
   <cfelseif find_closed_state.recordcount>
    
   <cfelse>
   <tr>
   <td colspan="#6+GET_ALLOCATION_PROJECT.recordcount#" style="text-align:RIGHT">
   <strong>يرجى تحديد اسم الفرع لتوزيع نسب LOA الجديدة من موظفي الخدمة</strong></td> 
   </tr>
   </cfif>
  
   </cfoutput>

  
</table>
<cfelse>
<span style="border:1px solid #000; text-align:center">ALLOCATIONS</span>لم يتم العثور على بيانات



</cfif>
<cfelseif isdefined("attributes.is_form_submitted")>

<cfif len(attributes.FUNC)>
  <cfquery name="GET_AGG_puantaj_rows" dbtype="query">
    SELECT * FROM get_puantaj_rows
    WHERE FUNC_ID = #attributes.FUNC#
</cfquery>
<cfset get_puantaj_rows =GET_AGG_puantaj_rows>
</cfif>
<cfquery name="check" datasource="#dsn#">
	SELECT
		COMPANY_NAME,
		TEL_CODE,
		TEL,
		TEL2,
		TEL3,
		TEL4,
		FAX,
		ADDRESS,
		WEB,
		EMAIL,
		ASSET_FILE_NAME3,
		ASSET_FILE_NAME3_SERVER_ID,
		TAX_OFFICE,
		TAX_NO
	FROM
		OUR_COMPANY
	WHERE
		<cfif isDefined("session.ep.company_id")>
			COMP_ID = #session.ep.company_id#
		<cfelseif isDefined("session.pp.company")>	
			COMP_ID = #session.pp.company_id#
		</cfif> 
</cfquery>
  <cfset c_no=1>
   <cfif GET_ALLOCATION_PROJECT.recordcount>
   <cfset c_no=GET_ALLOCATION_PROJECT.recordcount+1>
   </cfif>
   <cfset col_no=9>
	<cfif  attributes.Type_id eq 4>
    <cfset col_no=7+c_no>
    </cfif>
<table class="basket_list" width="99%" style="border:hidden;">
 <cfoutput>
     
	
       </cfoutput>
</table>
<table id="list_tb" class="basket_list" width="99%">
<cfif isdefined("attributes.is_form_submitted")>
<cfset total_taxable=0>
    <cfset sayfa_count_ = sayfa_count_ + 1>
    <cfif (sayfa_count_ eq 1)>
        <cfset sayfa_no = sayfa_no + 1>
        <cfset cols_plus = 0>
        </cfif>
 <cfset Total_adjustment=0>
	
        <thead>
       
	   <cfoutput>
  <tr class="txtbold" align="left">	
   <td colspan="5" style="text-align:center;background:##FFF"><cfif len(check.asset_file_name3)><cf_get_server_file output_file="settings/#check.asset_file_name3#" output_server="#check.asset_file_name3_server_id#" output_type="5"></cfif></td>
 
  <td style="background:##EBE600;  border:1px solid ##000; width:6px"></td> 
  <th colspan="2">موظف جديد</td> 
  
  <td style="background:##FFC000;  border:1px solid ##000;width:6px"></td>
  <th colspan="2"> موظف تعرض للتغيير</td> 
  <td  colspan="7" style=" font-family:'Times New Roman', Times, serif; font-size:24px">#DateFormat('20/#attributes.sal_mon#/#attributes.sal_year#','MMMM, yy')# كشوف المرتبات لشهر  <cfif len(attributes.Type_id) and attributes.Type_id eq 1><br /></cfif>
  
  		<td  colspan="3" style=" font-family:'Times New Roman', Times, serif; font-size:24px"><cfif len(attributes.branch_id)><cfloop query="get_branch"><cfif branch_id eq attributes.branch_id>#Replace(get_branch.branch_name,'/','&')#</cfif></cfloop><cfelse></cfif>		  </td>
  
  
  </tr> </cfoutput>

            <tr class="txtbold" align="left">	
             <th width="70" style="border:1px solid #000;">#</th>                 

         <th width="100" style="border:1px solid #000;width:50px;">الرقم الوظيفي </th>
         <th width="200" style="border:1px solid #000;"><div style="width:100px">اسم الموظف</div></th>

        <th width="70" style="border:1px solid #000;">الدرجه الماليه</th>
   <th width="70" style="border:1px solid #000;"> نوع الموطف </th>
   <th width="200" style="border:1px solid #000;">المسمى الوظيفي</th>
   <th width="70" style="border:1px solid #000;">الفرع</th>
   <th width="70" style="border:1px solid #000;">الموقع</th>
   
    <cfif not len(attributes.col_option)> 
    <!---<th style="border:1px solid #000;">الحساب البنكي</th>--->
   <th width="70" style="border:1px solid #000;"> عدد أيام العمل</th>
   <th width="70" style="border:1px solid #000;" >  الراتب  اساسي  </th>
 <cfif not len(attributes.col_option)> 
   <!--- أجمالي البدلات--->
           <cfif ListFind(attributes.allowance,1,',') OR  len(attributes.allowance)> 
		 <cfset employee_puantaj_ids = valuelist(get_puantaj_rows.employee_puantaj_id)>
                        <cfquery name="get_allow_query" datasource="#dsn#">
                            SELECT 
                                PUANTAJ_ID, 
                                EMPLOYEE_PUANTAJ_ID, 
                                COMMENT_PAY, 
                                PAY_METHOD, 
                                AMOUNT_2, 
                                isnull(AMOUNT,0) as AMOUNT, 
                                SSK, 
                                TAX, 
                                EXT_TYPE, 
                                ACCOUNT_CODE, 
                                AMOUNT_PAY
                            FROM 
                                EMPLOYEES_PUANTAJ_ROWS_EXT spp
                            WHERE 
                                <cfif listlen(employee_puantaj_ids)>spp.EMPLOYEE_PUANTAJ_ID IN (#employee_puantaj_ids#)<cfelse>1=0</cfif> AND 
                                spp.EXT_TYPE = 0
                                --and  spp.COMMENT_PAY in (
                                --					select ALLOW_TYPE from  [YTECH_COSTUM].[dbo].[SALARY_COULUMN] spg 
                                ---						where SPP.COMMENT_PAY = spg.ALLOW_TYPE and spg.allow_tax=1  and spg.ded_amout_day=0) 
                            ORDER BY 
                                COMMENT_PAY
                        </cfquery>
                                <cfquery name="get_allow_name" dbtype="query">
                            SELECT DISTINCT COMMENT_PAY FROM get_allow_query WHERE COMMENT_PAY <> 'Avans' ORDER BY COMMENT_PAY
                        </cfquery>

   <cfoutput query="get_allow_name">

             <cfset 'ALLOW_#CURRENTROW#_TOTAL'=0>
     </cfoutput>

      <cfoutput query="get_allow_name">
           <th width="70" style="border:1px solid ##000;">#get_allow_name.COMMENT_PAY#</th>
      </cfoutput>
	  </cfif>   
    </cfif> 
	
	
	  
	 <th width="70"  style="border:1px solid #000;"> اجمالى البدلات </th>
     <th width="70" style="border:1px solid #000;"> إجمالي الاستحقاقات   </th>



        <th width="70" style="border:1px solid #000;">  تـأمين 1 %  صندوق التدريب   </th>
   <th width="70" style="border:1px solid #000;">  تـأمين 2 %  تأمين الصحي </th>
   <th width="70" style="border:1px solid #000;">  تقاعد 6 %  </th>
   <th width="70" style="border:1px solid #000;"> تقاعد 9 %    </th>

    <th width="70" style="border:1px solid #000;">  تقاعد 12 % صندوق التقاعد العسكري   </th>
     <th width="70" style="border:1px solid #000;">  تقاعد 12 % مؤسسة العامه التأمينات </th>
     <th width="70" style="border:1px solid #000;"> تقاعد 15 %   </th>																		
    <th width="70" style="border:1px solid #000;"> تقاعد 12 %   </th> 


	
	 <cfif ListFind(attributes.deduction,1,',') OR  len(attributes.deduction)>



		 <cfset employee_puantaj_ids = valuelist(get_puantaj_rows.employee_puantaj_id)>
<cfquery name="get_ded_query" datasource="#dsn#">
	SELECT 
		PUANTAJ_ID, 
		EMPLOYEE_PUANTAJ_ID, 
		COMMENT_PAY , 
		PAY_METHOD, 
		AMOUNT_2, 
		 isnull(AMOUNT,0) as AMOUNT, 
		SSK, 
		TAX, 
		EXT_TYPE, 
		ACCOUNT_CODE, 
		AMOUNT_PAY
	FROM 
		EMPLOYEES_PUANTAJ_ROWS_EXT spp
	WHERE 
		<cfif listlen(employee_puantaj_ids)>spp.EMPLOYEE_PUANTAJ_ID IN (#employee_puantaj_ids#)<cfelse>1=0</cfif> AND 
		spp.EXT_TYPE = 1
		---and  spp.COMMENT_PAY in (
		---					select ALLOW_TYPE from  [YTECH_COSTUM].[dbo].[SALARY_COULUMN] spg 
		---						where SPP.COMMENT_PAY = spg.ALLOW_TYPE  and spg.ded_amout_day =1) 
	ORDER BY 
		COMMENT_PAY
</cfquery>
<!---------------ded by day---------------------------> 
<cfquery name="get_ded1_query" datasource="#dsn#">
	SELECT 
		PUANTAJ_ID, 
		EMPLOYEE_PUANTAJ_ID, 
		COMMENT_PAY , 
		PAY_METHOD, 
		AMOUNT_2, 
		 isnull(AMOUNT,0) as AMOUNT, 
		SSK, 
		TAX, 
		EXT_TYPE, 
		ACCOUNT_CODE, 
		AMOUNT_PAY
	FROM 
		EMPLOYEES_PUANTAJ_ROWS_EXT spp
	WHERE 
		<cfif listlen(employee_puantaj_ids)>spp.EMPLOYEE_PUANTAJ_ID IN (#employee_puantaj_ids#)<cfelse>1=0</cfif> AND 
		spp.EXT_TYPE = 1
		---and  spp.COMMENT_PAY in (
		---					select ALLOW_TYPE from  [YTECH_COSTUM].[dbo].[SALARY_COULUMN] spg 
		---						where SPP.COMMENT_PAY = spg.ALLOW_TYPE  and spg.ded_amout_day=0) 
	ORDER BY 
		COMMENT_PAY
</cfquery>
		 <cfquery name="get_ded_name" dbtype="query">
	SELECT DISTINCT COMMENT_PAY  FROM get_ded_query WHERE COMMENT_PAY <> 'Avans' ORDER BY COMMENT_PAY
</cfquery>

 <cfquery name="get_ded1_name" dbtype="query">
	SELECT DISTINCT COMMENT_PAY  FROM get_ded1_query WHERE COMMENT_PAY <> 'Avans' ORDER BY COMMENT_PAY
</cfquery>

<cfoutput query="get_ded_name">

<cfset 'ded#CURRENTROW#_T'=0>
 
</cfoutput>

<cfoutput query="get_ded1_name">

<cfset 'ded#CURRENTROW#_T1'=0>
 
</cfoutput>
      <cfoutput query="get_ded_name">
        <th width="70" style="border:1px solid ##000;">#get_ded_name.COMMENT_PAY#</th>
      </cfoutput>
      <cfoutput query="get_ded1_name">
        <th width="70" style="border:1px solid ##000;">#get_ded1_name.COMMENT_PAY#</th>
      </cfoutput>
	 </cfif>

 <th width="70" width="70" style="border:1px solid #000;"> إجمالي الاستقطاعات   </th>
	   
   <cfif ListFind(attributes.col_option,1,',') OR not len(attributes.col_option)> 
																		 
<th width="70" style="border:1px solid #000;"> احتساب ضريبة  </th>   
   <th width="70"  style="border:1px solid #000;"> توريد جزئي  </th>
			  
			
 <th width="70" style="border:1px solid #000;"> توريد  </th>  
  <th width="70" style="border:1px solid #000;"> مجموع الاستقطاعات  </th>   
  <th width="70" style="border:1px solid #000;"> صافي الراتب </th>  
   </cfif>
				  
				 


   <!--- أجمالي البدلات--->
				  
				   
   </cfif>
   <cfif isdefined('attributes.ADDAdj') AND LEN(attributes.ADDAdj)> 
 
 </cfif>

    
    </tr>
        </thead>
    </cfif>
    <tbody>
    <cfif isdefined("attributes.is_form_submitted")>




    <cfif listfind('1,2,4',attributes.Type_id) AND ((isdefined('attributes.new_staff') AND LEN(attributes.new_staff)) or (isdefined('attributes.changed_staff') AND LEN(attributes.changed_staff)))>
    <cfquery name="CHANGED_STAFF1" datasource="#dsn#">
                 SELECT EMPLOYEE_POSITIONS_CHANGE_HISTORY.EMPLOYEE_ID 
                 FROM EMPLOYEE_POSITIONS_CHANGE_HISTORY 
                 WHERE
                 (SELECT top(1) M#Prev_MON# FROM EMPLOYEES_SALARY WHERE EMPLOYEE_ID=EMPLOYEE_POSITIONS_CHANGE_HISTORY.EMPLOYEE_ID AND PERIOD_YEAR=#Prev_YEAR#) IS NOT NULL
                 AND
                 (SELECT top(1) M#Prev_MON# FROM EMPLOYEES_SALARY WHERE EMPLOYEES_SALARY.EMPLOYEE_ID=EMPLOYEE_POSITIONS_CHANGE_HISTORY.EMPLOYEE_ID AND PERIOD_YEAR=#Prev_YEAR#) <> (SELECT top(1) M#attributes.sal_mon# FROM EMPLOYEES_SALARY WHERE EMPLOYEES_SALARY.EMPLOYEE_ID=EMPLOYEE_POSITIONS_CHANGE_HISTORY.EMPLOYEE_ID AND PERIOD_YEAR=#attributes.sal_year#)
                 </cfquery>
                 <cfquery name="CHANGED_STAFF2" datasource="#dsn#">
                 SELECT EMPLOYEE_ID 
                 FROM EMPLOYEES_IN_OUT 
                 WHERE
                  MONTH(START_DATE)=#attributes.sal_mon# AND YEAR(START_DATE)=#attributes.sal_year# 
                 </cfquery>
      <cfset CHANGED_STAFF_LIST='0'>
      <cfset NEW_STAFF_LIST='0'>
      <cfif CHANGED_STAFF1.RECORDCOUNT>
      <cfset CHANGED_STAFF_LIST= VALUELIST(CHANGED_STAFF1.EMPLOYEE_ID)>
      </cfif>
      <cfif CHANGED_STAFF2.RECORDCOUNT>
      <cfset NEW_STAFF_LIST= VALUELIST(CHANGED_STAFF2.EMPLOYEE_ID)>
      </cfif>
      <cfquery name="GET_STAFF" dbtype="query">
        SELECT * FROM get_puantaj_rows
        WHERE 
        <cfif isdefined('attributes.new_staff') AND LEN(attributes.new_staff) AND isdefined('attributes.changed_staff') AND LEN(attributes.changed_staff)>
        (
         EMPLOYEE_ID IN (#CHANGED_STAFF_LIST#)
        )
        OR
        (
           EMPLOYEE_ID IN (#NEW_STAFF_LIST#)
        )
        <cfelseif isdefined('attributes.new_staff') AND LEN(attributes.new_staff)>
        EMPLOYEE_ID IN (#NEW_STAFF_LIST#)
        <cfelse>
        EMPLOYEE_ID IN (#CHANGED_STAFF_LIST#)
        </cfif>
        order by BRANCH_NAME
      </cfquery>
      
      <cfset get_puantaj_rows=GET_STAFF>
      
    </cfif>
    <cfquery name="GET_STAFF" dbtype="query">
        SELECT * FROM get_puantaj_rows
        order by BRANCH_NAME 
    </cfquery>		   
    <cfset get_puantaj_rows=GET_STAFF>

        <cfoutput query="get_puantaj_rows" group="#type_#">
            <cfoutput>
            
                <cfset attributes.employee_id = get_puantaj_rows.EMPLOYEE_ID>
                
                
                <cfquery name="get_this_istisna" dbtype="query">
                    SELECT SUM(VERGI_ISTISNA_AMOUNT) AS VERGI_ISTISNA_AMOUNT FROM get_vergi_istisna WHERE EMPLOYEE_PUANTAJ_ID = #EMPLOYEE_PUANTAJ_ID# AND VERGI_ISTISNA_AMOUNT IS NOT NULL
                </cfquery>
                <tr style="height:25">
                <cfset row_color="border:1px solid ##000;">
                 <cfif len(attributes.Type_id) and attributes.Type_id neq 3 AND isdefined('attributes.with_color') and len(attributes.with_color)> 
                  <cfquery name="NEW_PERMOTION_salary" datasource="#dsn#">
                   SELECT M#Prev_MON# FROM EMPLOYEES_SALARY 
                   WHERE EMPLOYEE_ID=#EMPLOYEE_ID# AND 
                   IN_OUT_ID = #IN_OUT_ID# AND
                   PERIOD_YEAR=#Prev_YEAR# AND 
                   M#Prev_MON# IS NOT NULL AND 
                   M#Prev_MON# <> #SALARY#
                 </cfquery>
                 <cfif len(start_date) and (month(start_date) eq row_sal_mon and year(start_date) eq row_sal_year)>
                 <cfset row_color="background:##EBE600;"&"border:1px solid ##000;">
                 <cfelseif NEW_PERMOTION_salary.recordcount>
                 <cfset row_color="background:##FFC000;"&"border:1px solid ##000;">
                 </cfif>
               </cfif>
                  <cfset ssk_count = ssk_count+1>
                  <!---<cfloop list="#attributes.b_obj_hidden_new#" index="xlr">--->
      <cfif isDefined("attributes.is_title") or isDefined("attributes.is_position_cat_id") or isDefined("attributes.is_position") or isDefined("attributes.is_position_fonksiyon") or isDefined("attributes.is_p_branch_name") or isDefined("attributes.is_p_department_name")>
        <cfquery dbtype="query" name="position_info">
	SELECT * FROM get_position_info WHERE EMPLOYEE_ID = #EMPLOYEE_ID#
	</cfquery>
      </cfif>
      <cfquery name="bank_info" datasource="#dsn#">
    SELECT
    	BANK_ACCOUNT_NO,
        MONEY
    FROM EMPLOYEES_BANK_ACCOUNTS
    WHERE
    	EMPLOYEE_ID = #EMPLOYEE_ID#
</cfquery>
<cfquery name="FUNC_info" datasource="#dsn#">
 SELECT *   FROM [SETUP_CV_UNIT] 
 </cfquery>
 



<cfscript>
		get_puantaj_12 = createObject("component", "v16.hr.ehesap.cfc.Ytech_Putan");
															  
		  
		get_puantaj_12.set_variables(
			EMPLOYEE_PUANTAJ_ID :#get_puantaj_rows.EMPLOYEE_PUANTAJ_ID#						
		);
		
		eprza = get_puantaj_12.emp_pun();
	</cfscript>

  <!---1---> <td  style="#row_color#width:10;">#CURRENTROW#</td>
  <!---2--->     <td   style="#row_color#width:10;" >#EMPLOYEE_NO#</td>
  

  <!---5--->     <td   style="#row_color#">#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</td> 

 <td   style="#row_color#width:10;"  >#ORGANIZATION_STEP_NAME#</td> 
 <td   style="#row_color#width:10;"  > <cfif #COLLAR_TYPE# eq 1 > صندوق تأمينات الجيش  <cfelse> صندوق الهيئة العامة للتأمينات  <cfelse #COLLAR_TYPE# eq 3> صندوق المؤسسة العامة للتامينات </cfif></td> 
  <!---6--->    <td   style="#row_color#"  >#POSITION_NAME#</td>
    <!---7--->    <td   style="#row_color#"  >#branch_name# </td>
  <!---7--->    <td   style="#row_color#"  >#DEPARTMENT_HEAD#</td>

         <cfif not len(attributes.col_option)> 
  
  <!---9--->     <td   style="#row_color#; text-align:center">#TOTAL_DAYS#</td>
<!----- this for gave us the puantaj row ----->

<!--- this for base salary  --->
<td   style="#row_color#; text-align:center" title="base salary">#numberFormat(eprza.Salary_days_work,'_,9.99')#</td>
<cfset t_salba_sum= t_salba_sum + val(NumberFormat(eprza.Salary_days_work,'0000.00'))>

		 <cfif ListFind(attributes.allowance,1,',') OR  len(attributes.allowance)> 

  <cfloop query="GET_allow_name">
   

	 <cfquery name="get_allow_value" dbtype="query">
	SELECT SUM(CAST(get_allow_query.AMOUNT as decimal)) AS amount FROM get_allow_query  
  WHERE get_allow_query.COMMENT_PAY like '#GET_allow_name.COMMENT_PAY#' and EMPLOYEE_PUANTAJ_ID=#get_puantaj_rows.EMPLOYEE_PUANTAJ_ID#  
</cfquery>



	
	 <td   style="#row_color#; text-align:center" title="#COMMENT_PAY#"> #numberFormat(get_allow_value.amount,'_,9.99')#</td>
	 <cfset 'ALLOW_#CURRENTROW#_TOTAL'=evaluate('ALLOW_#CURRENTROW#_TOTAL') + val(numberFormat(get_allow_value.amount,'0000.00'))>
  </cfloop>

     
        
       
		</cfif>
     
	  <!--- this for sum_ded --->

<td   style="#row_color#; text-align:center" title="sum_ded"> #numberFormat((eprza.allow_with_tax),'_,9.99')#</td>
<cfset t_col9_sum= t_col9_sum + val(NumberFormat(eprza.allow_with_tax,'0000.00'))>

<td   style="#row_color#; text-align:center;background:##D9D9D9;"  title="total allow"> #numberFormat((eprza.Total_allowance),'_,9.99')#</td>
	 <cfset t_col13_sum= t_col13_sum + val(NumberFormat(eprza.Total_allowance,'0000.00'))>
		<cfif ListFind(attributes.deduction,1,',') OR  len(attributes.deduction)>
       

   
<!--- this for Transportation_allowance_div  --->
<td   style="#row_color#; text-align:center" title="SSK_ded">#numberFormat(eprza.SSK11_comp,'_,9.99')#</td>
<cfset t_dec_sum= t_dec_sum + val(NumberFormat(eprza.SSK11_comp,'0000.00'))>
<!--- this for Work_injury_1 --->
<td   style="#row_color#; text-align:center" title="Work_injury_1">#numberFormat((eprza.Work_injury_1),'_,9.99')#</td>
<cfset t_15_sum= t_15_sum + val(NumberFormat(eprza.Work_injury_1,'0000.00'))>
	      

  <cfloop query="GET_ded_name">
   

	 <cfquery name="get_ded_value" dbtype="query">
	SELECT SUM(CAST(get_ded_query.AMOUNT as decimal)) AS amount FROM get_ded_query  WHERE
   get_ded_query.COMMENT_PAY like '#GET_ded_name.COMMENT_PAY#' and EMPLOYEE_PUANTAJ_ID=#get_puantaj_rows.EMPLOYEE_PUANTAJ_ID#  
</cfquery>

	
	 <td   style="#row_color#; text-align:center" title="#COMMENT_PAY#"> #numberFormat(get_ded_value.amount,'_,9.99')#</td>
	  <cfset 'ded#CURRENTROW#_T'=evaluate('ded#CURRENTROW#_T') + val(numberFormat(get_ded_value.amount,'0000.00'))>

  </cfloop>	 




  <cfloop query="GET_ded1_name">
   

	 <cfquery name="get_ded1_value" dbtype="query">
	SELECT (SUM(CAST(get_ded1_query.AMOUNT as decimal)) * #(eprza.Salary_days_work/30)#)  AS amount FROM get_ded1_query  WHERE get_ded1_query.COMMENT_PAY like '#GET_ded1_name.COMMENT_PAY#' and EMPLOYEE_PUANTAJ_ID=#get_puantaj_rows.EMPLOYEE_PUANTAJ_ID#  
</cfquery>

	 <td   style="#row_color#; text-align:center" title="#COMMENT_PAY#"> #numberFormat(get_ded1_value.amount,'_,9.99')#</td>
	  <cfset 'ded#CURRENTROW#_T1'=evaluate('ded#CURRENTROW#_T1') + val(numberFormat(get_ded1_value.amount,'0000.00'))>

  </cfloop>	   
       
		</cfif>
      
	    <!--- this for sum_ded --->
<td   style="#row_color#; text-align:center" title="sum_ded">  #numberFormat((eprza.dede_salary),'_,9.99')#</td>
<cfset t_col14_sum= t_col14_sum + val(numberFormat((eprza.dede_salary),'0000.00'))>

	  <!------------------->

								 
<!--- this for tax_1 --->
<td   style="#row_color#; text-align:center" title="tax_1">#numberFormat((eprza.tax_1),'_,9.99')#</td>
<cfset t_20_sum= t_20_sum + val(NumberFormat((eprza.tax_1),'0000.00'))>
<!--- this for Work_injury_1 --->
<td   style="#row_color#; text-align:center" title="Work_injury_1">#numberFormat(eprza.Total_insurance,'_,9.99')#</td>
<cfset t_16_sum= t_16_sum + val(NumberFormat(eprza.Total_insurance,'0000.00'))>
<!--- this for Work_injury_1 --->
<td   style="#row_color#; text-align:center" title="Work_injury_1">#numberFormat((eprza.Work_injury_1),'_,9.99')#</td>
<cfset t_17_sum= t_17_sum + val(NumberFormat((eprza.Work_injury_1),'0000.00'))>
<!--- this for Total_deduction --->
<td   style="#row_color#; text-align:center;background:##D9D9D9;"  title="total dedection"> #numberFormat((eprza.Total_deduction),'_,9.99')#</td>
<cfset t_18_sum= t_18_sum + val(NumberFormat(eprza.Total_deduction,'0000.00'))>



<!--- this for Net_benefit --->
<td   style="#row_color#; text-align:center" title="Net_benefit">#numberFormat((eprza.syspand_per + eprza.syspand_amount ),'_,9.99')#</td>
<cfset t_21_sum= t_21_sum + val(NumberFormat((eprza.syspand_per + eprza.syspand_amount ),'0000.00'))>



<!--- this for Net_benefit --->
<td   style="#row_color#; text-align:center" title="Net_benefit">#numberFormat((eprza.Net_benfit_1),'_,9.99')#</td>
<cfset t_19_sum= t_19_sum + val(NumberFormat((eprza.Net_benfit_1),'0000.00'))>




  </cfif>                     
<!---</cfloop>--->
 <cfset sub_total_1=0>
 <cfset sub_total_2=0>
 <cfset sub_total_3=0>
 <cfset DAMGA_VERGISI_MATRAH_calc=0>
 <cfset ISSIZLIK_ISVEREN_HISSESI_calc=0>

 
                    
                 
              
            </cfoutput>
            
            <cfset count_ = 0>
            <cfloop list="#odenek_names#" index="cc">
                <cfset count_ = count_ + 1>
                <cfset 'd_t_odenek_#count_#' = 0>
                <cfset 'd_t_odenek_net_#count_#' = 0>
            </cfloop>
            <cfset count_ = 0>
            <cfloop list="#kesinti_names#" index="cc">
                <cfset count_ = count_ + 1>
                <cfset 'd_t_kesinti_#count_#' = 0>
            </cfloop>
            <cfset d_t_avans = 0>
            </cfoutput>
            </cfif>
			  
    </tbody>	 <cfif get_puantaj_rows.recordcount>
    
  
    <cfoutput>
                   <tr height="25" class="total">
                    <cfset row_color="border:1px solid ##000;">
                    
					<td   colspan="<cfif not len(attributes.col_option)>9<cfelse>8</cfif>" style="#row_color#" ><strong>اجمالي</strong></td>
                    <td  style="#row_color#; text-align:center">#tlformat(t_salba_sum)#</td>
					<td  style="#row_color#; text-align:center">#tlformat(t_dec_sum)#</td>
					<td  style="#row_color#; text-align:center">#tlformat(t_15_sum)#</td>
					
					
					
			<cfif ListFind(attributes.allowance,1,',') OR  len(attributes.allowance)> 		
  <cfloop query="GET_allow_name">
   
	<td  style="#row_color#; text-align:center"> #numberFormat(evaluate('ALLOW_#CURRENTROW#_TOTAL'),'_,9.99')#</td>
	
  </cfloop>
 </cfif>
     
					<td  style="#row_color#; text-align:center">#tlformat(t_col9_sum)#</td>
					 <td   style="#row_color#; text-align:center;background:##D9D9D9;"  title="total allow">#tlformat(t_col13_sum)#</td>
					
				
	<cfif ListFind(attributes.deduction,1,',') OR  len(attributes.deduction)> 		
  <cfloop query="GET_ded_name">
   
	<td  style="#row_color#; text-align:center"> #numberFormat(evaluate('ded#CURRENTROW#_T'),'_,9.99')#</td>
	 </cfloop>
	  <cfloop query="GET_ded1_name">
	<td  style="#row_color#; text-align:center"> #numberFormat(evaluate('ded#CURRENTROW#_T1'),'_,9.99')#</td>
	 </cfloop>
 
 </cfif>
				
		
				   <td  style="#row_color#; text-align:center">#tlformat(t_col14_sum)#</td>
				 <td  style="#row_color#; text-align:center">#tlformat(t_20_sum)#</td>
					<td  style="#row_color#; text-align:center">#tlformat(t_16_sum)#</td>
					<td  style="#row_color#; text-align:center">#tlformat(t_17_sum)#</td>
					<td   style="#row_color#; text-align:center;background:##D9D9D9;"  title="total ded">#tlformat(t_18_sum)#</td>
                    <td  style="#row_color#; text-align:center">#tlformat(t_21_sum)#</td>					
                    <td  style="#row_color#; text-align:center">#tlformat(t_19_sum)#</td>
				
                   
                    <cfif not len(attributes.col_option) >     
                                        <!---<cfif attributes.sal_mon lt 11 and attributes.sal_year eq 2019>
                    <cfelse></cfif>--->
                    
					
                      
                   
                    
                    </cfif>
                
                    <!--- Total set for Deduction and Allowance --->
            
                
				 
               
              <!-----end----->
                    <!---<td><div align="left">#Dedection1#</div></td>--->
                   
                    <cfset t1=0>
                    <cfset t2=0>
                    <cfset t3=0>
                     
                    </tr>
                    </tr>
                    
					
				
				
					
					
                    <cfif Get_signs.RECORDCOUNT OR Get_REVIEW.RECORDCOUNT>
                    <cfset REC_EMP=-1>
					<cfSET REC_POS='Finance Manager'>
                    <cfset REC_DATE=''>
                    <cfset SR_ID=''>
                    <cfset HR_REC_EMP=-1>
                    <cfSET HR_REC_POS='HR & Admin Manager'>
                    <cfset HR_REC_DATE=''>
                    <cfif Get_signs.RECORDCOUNT>
                    <cfset SR_ID=Get_signs.SR_ID>
                    <cfSET REC_POS=Get_signs.POSITION_NAME1>
                    <cfSET HR_REC_POS=Get_signs.HR_POSITION_NAME>
					<cfset REC_EMP=Get_signs.RECORD_EMP>
                    
                    <cfif NOT FIND('Finance',Get_signs.POSITION_NAME1) OR NOT FIND('Manager',Get_signs.POSITION_NAME1)>
					<cfSET REC_POS='مدير الموارد البشرية'>
                    </cfif>
                     <cfset REC_DATE=Get_signs.RECORD_DATE>
                    <cfset HR_REC_EMP=Get_signs.HR_ID>
                    
                    <cfif NOT FIND('HR',Get_signs.HR_POSITION_NAME) OR NOT FIND('Manager',Get_signs.HR_POSITION_NAME)>
					<cfSET HR_REC_POS='Acting HR & Admin Manager'>
                    </cfif>
                    
                    <cfset HR_REC_DATE=Get_signs.HR_DATE>
                    <cfelse>
                    <cfset SR_ID=Get_REVIEW.SR_ID>
                    <cfSET REC_POS=Get_REVIEW.POSITION_NAME1>
                    <cfSET HR_REC_POS=Get_REVIEW.HR_POSITION_NAME>
                    <cfset REC_EMP=Get_REVIEW.RECORD_EMP>
                    <cfif NOT FIND('Finance',Get_REVIEW.POSITION_NAME1) OR NOT FIND('Manager',Get_REVIEW.POSITION_NAME1)>
					<cfSET REC_POS='Acting Finance Manager'>
                    </cfif>
                     <cfset REC_DATE=Get_REVIEW.RECORD_DATE>
                    <cfset HR_REC_EMP=Get_REVIEW.HR_ID>
                    <cfif NOT FIND('HR',Get_REVIEW.HR_POSITION_NAME) OR NOT FIND('Manager',Get_REVIEW.HR_POSITION_NAME)>
					<cfSET HR_REC_POS='Acting HR & Admin Manager'>
                    </cfif>
                    <cfset HR_REC_DATE=Get_REVIEW.HR_DATE>
                    </cfif>
                    <tr id="sign">
                    <cfif len(attributes.col_option)>
                     <cfif attributes.Table eq 2>
                      <td colspan="#(GET_ALLOCATION_PROJECT.recordcount*LISTlen(attributes.col_option))+10+LISTlen(attributes.col_option)#"></td>
                     <cfelse>
                    <td colspan="#GET_ALLOCATION_PROJECT.recordcount+10+LISTlen(attributes.col_option)#"></td>
                    </cfif>
                    <cfelse>
                    <cfif attributes.Table eq 2><td colspan="#(GET_ALLOCATION_PROJECT.recordcount)+30#">
                    <cfelse><td colspan="#GET_ALLOCATION_PROJECT.recordcount+27#"></cfif>
                    </cfif>
                    <table style="width:100%">
                    <tr>
                    <cfset column_total='text-align:center; font-size:12px; width:15%'>
                      <td style="#column_total#"><cfscript>getimpdata(1,HR_REC_EMP);</cfscript>Prepared BY<BR />#get_emp_info(HR_REC_EMP,0,0)#<BR  />#HR_REC_POS#<br /><br />#dateformat(HR_REC_DATE, 'dd-MMM-yyyy ')##TimeFormat(HR_REC_DATE,"HH:mm")#
                      </td>
                     <td style="#column_total#"><cfscript>getimpdata(1,REC_EMP);</cfscript>Reviewed BY<BR />#get_emp_info(REC_EMP,0,0)#<BR  />#REC_POS#<br /><br />#dateformat(REC_DATE, 'dd-MMM-yyyy ')##TimeFormat(REC_DATE,"HH:mm")#
                      </td>
                     
                      <cfif not len(Get_REVIEW.WARNING_RESULT)>
                        <td style="#column_total#">
                        <font color="RED"> NOT Reviewed YET<br />#get_emp_info(Get_REVIEW.POSITION_CODE,1,0)#<br /><cfif NOT FIND('Compliance',Get_REVIEW.POSITION_NAME) OR NOT FIND('Manager',Get_REVIEW.POSITION_NAME)>المدير المالي<cfelse>#Get_REVIEW.POSITION_NAME#</cfif></font><br /><br />
                        <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=report.detail_report&report_id=#attributes.report_id#&resend_email&POSITION_CODE=#Get_REVIEW.POSITION_CODE#&SR_ID=#Get_REVIEW.SR_ID#&W_ID_=#Get_REVIEW.W_ID#&REPORT_NAME=KOA_#attributes.sal_mon#_#attributes.sal_year#&type=-1','small');"><font color="blue"><strong>Resend an E-mail</strong></font></a><br />
                        last sent on #dateformat(Get_REVIEW.EMAIL_WARNING_DATE, 'dd-MMM-yyyy')# #TimeFormat(Get_REVIEW.EMAIL_WARNING_DATE,"HH:mm")#<br />
                        <cfif (len(REVIEWER1_code) and REVIEWER1_code eq Get_REVIEW.POSITION_CODE) or not len(REVIEWER1_code)>
                            to change the reviewer please choose the Reviewer employee from above and click search then use the link here
                        <cfelseif len(REVIEWER1_code) and REVIEWER1_code neq Get_REVIEW.POSITION_CODE>
                             <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=report.detail_report&report_id=#attributes.report_id#&resend_email&POSITION_CODE=#REVIEWER1_code#&SR_ID=#SR_ID#&W_ID_2=#Get_REVIEW.W_ID#&REPORT_NAME=KOA_#attributes.sal_mon#_#attributes.sal_year#&type=-1','small');"><font color="blue"><strong>change the reviwer and send an e-mail to #get_emp_info(attributes.REVIEWER1_id,0,0)#</strong></font></a><br />
                        </cfif>
                        </td>
                        <cfelseif find('Rejec',Get_REVIEW.WARNING_RESULT)>
                        <td style="#column_total#">
                        <font color="RED"> Rejected BY<br />#get_emp_info(Get_REVIEW.POSITION_CODE,1,0)#<br /><cfif NOT FIND('Compliance',Get_REVIEW.POSITION_NAME) OR NOT FIND('Manager',Get_REVIEW.POSITION_NAME)>المدير المالي<cfelse>#Get_REVIEW.POSITION_NAME#</cfif></font></td>
                        <cfelseif find('Appro',Get_REVIEW.WARNING_RESULT)>
                        <td style="text-align:center; font-size:12px">
						<cfscript>getimpdata(2,Get_REVIEW.POSITION_CODE);</cfscript>
                        Verified By<br />#get_emp_info(Get_REVIEW.POSITION_CODE,1,0)#<br /><cfif NOT FIND('Compliance',Get_REVIEW.POSITION_NAME) OR NOT FIND('Manager',Get_REVIEW.POSITION_NAME)>المدير المالي<cfelse>#Get_REVIEW.POSITION_NAME#</cfif><br /><br />#dateformat(Get_REVIEW.APPROVE_DATE, 'dd-MMM-yyyy ')##TimeFormat(Get_REVIEW.APPROVE_DATE,"HH:mm")#</td>
                        </cfif>
                       <td style="text-align:center; font-size:12px; width:25%"></td>
                       
                       <cfloop query="Get_signs">
					   <cfset sign_possition=Get_signs.POSITION_NAME>
                       
                       <cfif currentrow eq 1>
                       
                       <cfif NOT FIND('Finance',Get_signs.POSITION_NAME) OR NOT FIND('Director',Get_signs.POSITION_NAME)>
                       <cfset sign_possition='المرجع المالي'>
                       </cfif>
                       
                       <cfelse>
                       
                       <cfif NOT FIND('Country',Get_signs.POSITION_NAME) OR NOT FIND('Director',Get_signs.POSITION_NAME)>
                       <cfset sign_possition='المدير التنفيذي'>
                       </cfif>
                       
                       </cfif>
                       
                        <cfif not len(Get_signs.WARNING_RESULT)>
                        <td style="#column_total#">
                        <font color="RED"> NOT APPROVED YET<br />#get_emp_info(Get_signs.POSITION_CODE,1,0)#<br />#sign_possition#</font><br /><br />
                        
                        <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=report.detail_report&report_id=#attributes.report_id#&resend_email&POSITION_CODE=#Get_signs.POSITION_CODE#&SR_ID=#SR_ID#&W_ID_=#Get_signs.W_ID#&REPORT_NAME=KOA_#attributes.sal_mon#_#attributes.sal_year#&type=#Get_signs.SETUP_WARNING_ID#','small');"><font color="blue"><strong>Resend an E-mail</strong></font></a></a><br />
                        last sent on #dateformat(Get_signs.EMAIL_WARNING_DATE, 'dd-MMM-yyyy')# #TimeFormat(Get_signs.EMAIL_WARNING_DATE,"HH:mm")#<br />
                        <cfif currentrow eq 1>
                        <cfif (len(APPROVAL1_code) and APPROVAL1_code eq Get_signs.POSITION_CODE) or not len(APPROVAL1_code)>
                            to change the Approval FAD please choose the Approval FAD employee from above and click search then use the link here
                        <cfelseif len(APPROVAL1_code) and APPROVAL1_code neq Get_signs.POSITION_CODE>
                             <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=report.detail_report&report_id=#attributes.report_id#&resend_email&POSITION_CODE=#APPROVAL1_code#&SR_ID=#SR_ID#&W_ID_2=#Get_signs.W_ID#&REPORT_NAME=KOA_#attributes.sal_mon#_#attributes.sal_year#&type=-3','small');"><font color="blue"><strong>change the reviwer and send an e-mail to #get_emp_info(attributes.APPROVAL1_id,0,0)#</strong></font></a><br />
                        </cfif>
                        <cfelse>
                          <cfif (len(APPROVAL2_code) and APPROVAL2_code eq Get_signs.POSITION_CODE) or not len(APPROVAL2_code)>
                            to change the Approval CD please choose the Approval CD employee from above and click search then use the link here
                        <cfelseif len(APPROVAL2_code) and APPROVAL2_code neq Get_signs.POSITION_CODE>
                             <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=report.detail_report&report_id=#attributes.report_id#&resend_email&POSITION_CODE=#APPROVAL2_code#&SR_ID=#SR_ID#&W_ID_2=#Get_signs.W_ID#&REPORT_NAME=KOA_#attributes.sal_mon#_#attributes.sal_year#&type=-2','small');"><font color="blue"><strong>change the reviwer and send an e-mail to #get_emp_info(attributes.APPROVAL2_id,0,0)#</strong></font></a><br />
                        </cfif>
                        </cfif>
                        </td>
                        <cfelseif find('Rejec',Get_signs.WARNING_RESULT)>
                        <td style="#column_total#">
                        <font color="RED"> Rejected BY<br />#get_emp_info(Get_signs.POSITION_CODE,1,0)#<br />#sign_possition#</font></td>
                        <cfelseif find('Appro',Get_signs.WARNING_RESULT)>
                        <td style="#column_total#"><cfscript>getimpdata(2,Get_signs.POSITION_CODE);</cfscript>
                        Approved BY<br />#get_emp_info(Get_signs.POSITION_CODE,1,0)#<br />#sign_possition#<br /><br />#dateformat(Get_signs.LAST_RESPONSE_DATE, 'dd-MMM-yyyy ')##TimeFormat(Get_signs.LAST_RESPONSE_DATE,"HH:mm")#</td>
                        </cfif>
                      </cfloop>
                    </tr>
                    </table>
                    </td>
                    </tr>
                    </cfif>
                
				</cfoutput>
				
                   </cfif>
				   
				   
				   
				   
   </table>
    </cfif>
	
  </div>
 
  <script>
	function re()
	{
     this.form.submit();
	}
	function state_color(typp)
	{
		if(typp != 3)
		  {
			  
              document.getElementById('collr').style.display='';
		  }
		  else
		  {
			 
			   document.getElementById('collr').style.display='none';
		  }
	}
	 <cfif len(attributes.Type_id) >
	   state_color(<cfoutput>#attributes.Type_id#</cfoutput>);
	 </cfif>
	//document.getElementById('detail_report_div').id="detail_report_divyy";
	//document.getElementById('detail_report_divxx').id="detail_report_div";
</script>

</cfif>