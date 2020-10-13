prompt --application/set_environment
set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- ORACLE Application Express (APEX) export file
--
-- You should run the script connected to SQL*Plus as the Oracle user
-- APEX_200100 or as the owner (parsing schema) of the application.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_api.import_begin (
 p_version_yyyy_mm_dd=>'2020.03.31'
,p_default_workspace_id=>9274776821789346
);
end;
/
prompt  WORKSPACE 9274776821789346
--
-- Workspace, User Group, User, and Team Development Export:
--   Date and Time:   11:06 Monday September 28, 2020
--   Exported By:     ADMIN
--   Export Type:     Workspace Export
--   Version:         20.1.0.00.13
--   Instance ID:     9274409283856676
--
-- Import:
--   Using Instance Administration / Manage Workspaces
--   or
--   Using SQL*Plus as the Oracle user APEX_200100
 
begin
    wwv_flow_api.set_security_group_id(p_security_group_id=>9274776821789346);
end;
/
----------------
-- W O R K S P A C E
-- Creating a workspace will not create database schemas or objects.
-- This API creates only the meta data for this APEX workspace
prompt  Creating workspace OCIARCADE...
begin
wwv_flow_fnd_user_api.create_company (
  p_id => 9275171072789579
 ,p_provisioning_company_id => 9274776821789346
 ,p_short_name => 'OCIARCADE'
 ,p_display_name => 'OCIARCADE'
 ,p_first_schema_provisioned => 'OCIARCADE'
 ,p_company_schemas => 'OCIARCADE'
 ,p_account_status => 'ASSIGNED'
 ,p_allow_plsql_editing => 'Y'
 ,p_allow_app_building_yn => 'Y'
 ,p_allow_packaged_app_ins_yn => 'Y'
 ,p_allow_sql_workshop_yn => 'Y'
 ,p_allow_websheet_dev_yn => 'Y'
 ,p_allow_team_development_yn => 'Y'
 ,p_allow_to_be_purged_yn => 'Y'
 ,p_allow_restful_services_yn => 'Y'
 ,p_source_identifier => 'OCIARCAD'
 ,p_webservice_logging_yn => 'Y'
 ,p_path_prefix => 'OCIARCADE'
 ,p_files_version => 1
);
end;
/
----------------
-- G R O U P S
--
prompt  Creating Groups...
begin
wwv_flow_fnd_user_api.create_user_group (
  p_id => 1201745853168287,
  p_GROUP_NAME => 'OAuth2 Client Developer',
  p_SECURITY_GROUP_ID => 10,
  p_GROUP_DESC => 'Users authorized to register OAuth2 Client Applications');
end;
/
begin
wwv_flow_fnd_user_api.create_user_group (
  p_id => 1201600093168287,
  p_GROUP_NAME => 'RESTful Services',
  p_SECURITY_GROUP_ID => 10,
  p_GROUP_DESC => 'Users authorized to use RESTful Services with this workspace');
end;
/
begin
wwv_flow_fnd_user_api.create_user_group (
  p_id => 1201558893168285,
  p_GROUP_NAME => 'SQL Developer',
  p_SECURITY_GROUP_ID => 10,
  p_GROUP_DESC => 'Users authorized to use SQL Developer with this workspace');
end;
/
prompt  Creating group grants...
----------------
-- U S E R S
-- User repository for use with APEX cookie-based authentication.
--
prompt  Creating Users...
begin
wwv_flow_fnd_user_api.create_fnd_user (
  p_user_id                      => '9274972013789348',
  p_user_name                    => 'OCIARCADE',
  p_first_name                   => '',
  p_last_name                    => '',
  p_description                  => '',
  p_email_address                => 'demo@gmail.com',
  p_web_password                 => '75BF6CBFF2146A4E97D7BAAADE400E032576EF2940638602C5599C2067B3300B226FB65F3740CA0648260E9F8B42B5C8AF52D377BB81452179FC5A2E4526C4B1',
  p_web_password_format          => '5;5;10000',
  p_group_ids                    => '1201558893168285:1201600093168287:1201745853168287:',
  p_developer_privs              => 'ADMIN:CREATE:DATA_LOADER:EDIT:HELP:MONITOR:SQL',
  p_default_schema               => 'OCIARCADE',
  p_account_locked               => 'N',
  p_account_expiry               => to_date('202009281031','YYYYMMDDHH24MI'),
  p_failed_access_attempts       => 0,
  p_change_password_on_first_use => 'N',
  p_first_password_use_occurred  => 'Y',
  p_allow_app_building_yn        => 'Y',
  p_allow_sql_workshop_yn        => 'Y',
  p_allow_websheet_dev_yn        => 'Y',
  p_allow_team_development_yn    => 'Y',
  p_allow_access_to_schemas      => '');
end;
/
----------------
--App Builder Preferences
--
----------------
--Click Count Logs
--
----------------
--mail
--
----------------
--mail log
--
----------------
--app models
--
----------------
--password history
--
begin
  wwv_flow_api.create_password_history (
    p_id => 9275336955789596,
    p_user_id => 9274972013789348,
    p_password => '75BF6CBFF2146A4E97D7BAAADE400E032576EF2940638602C5599C2067B3300B226FB65F3740CA0648260E9F8B42B5C8AF52D377BB81452179FC5A2E4526C4B1');
end;
/
----------------
--preferences
--
begin
  wwv_flow_api.create_preferences$ (
    p_id => 9276539468817335,
    p_user_id => 'OCIARCADE',
    p_preference_name => 'FSP4500_P3110_R1595347007342836_SORT',
    p_attribute_value => 'fsp_sort_1_desc',
    p_tenant_id => '');
end;
/
begin
  wwv_flow_api.create_preferences$ (
    p_id => 9278864071837908,
    p_user_id => 'OCIARCADE',
    p_preference_name => 'FSP_IR_4850_P190_W732599130544206031',
    p_attribute_value => '737087273050512628____',
    p_tenant_id => '');
end;
/
begin
  wwv_flow_api.create_preferences$ (
    p_id => 9275689438805078,
    p_user_id => 'OCIARCADE',
    p_preference_name => 'FSP4500_P3002_R24083118039996911_SORT',
    p_attribute_value => 'fsp_sort_1_desc',
    p_tenant_id => '');
end;
/
begin
  wwv_flow_api.create_preferences$ (
    p_id => 9276177716814478,
    p_user_id => 'OCIARCADE',
    p_preference_name => 'FSP4500_P3100_R82702857605738101_SORT',
    p_attribute_value => 'fsp_sort_1_desc',
    p_tenant_id => '');
end;
/
begin
  wwv_flow_api.create_preferences$ (
    p_id => 9279385262994987,
    p_user_id => 'OCIARCADE',
    p_preference_name => 'FSP4350_P33_R47031617128214415_SORT',
    p_attribute_value => 'fsp_sort_1_desc',
    p_tenant_id => '');
end;
/
begin
  wwv_flow_api.create_preferences$ (
    p_id => 9277272356831236,
    p_user_id => 'OCIARCADE',
    p_preference_name => 'FSP_IR_4350_P55_W10236304983033455',
    p_attribute_value => '10238325656034902____',
    p_tenant_id => '');
end;
/
begin
  wwv_flow_api.create_preferences$ (
    p_id => 9279051209838631,
    p_user_id => 'OCIARCADE',
    p_preference_name => 'APEX_IG_754958438006534386_CURRENT_REPORT',
    p_attribute_value => '754972509561557896:GRID',
    p_tenant_id => '');
end;
/
----------------
--query builder
--
----------------
--sql scripts
--
----------------
--sql commands
--
----------------
--user access log
--
begin
  wwv_flow_api.create_user_access_log2$ (
    p_login_name => 'OCIARCADE',
    p_auth_method => 'Internal Authentication',
    p_app => 4500,
    p_owner => 'APEX_200100',
    p_access_date => to_date('202009281034','YYYYMMDDHH24MI'),
    p_ip_address => '124.148.86.244',
    p_remote_user => 'ORDS_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
 
prompt ...workspace objects
 
 
prompt ...RESTful Services
 
-- SET SCHEMA
 
begin
 
   wwv_flow_api.g_id_offset := 0;
   wwv_flow_hint.g_schema   := 'OCIARCADE';
   wwv_flow_hint.check_schema_privs;
 
end;
/

 
--------------------------------------------------------------------
prompt  SCHEMA OCIARCADE - User Interface Defaults, Table Defaults
--
-- Import using sqlplus as the Oracle user: APEX_200100
-- Exported 11:06 Monday September 28, 2020 by: ADMIN
--
 
--------------------------------------------------------------------
prompt User Interface Defaults, Attribute Dictionary
--
-- Exported 11:06 Monday September 28, 2020 by: ADMIN
--
-- SHOW EXPORTING WORKSPACE
 
begin
 
   wwv_flow_api.g_id_offset := 0;
   wwv_flow_hint.g_exp_workspace := 'OCIARCADE';
 
end;
/

begin
wwv_flow_api.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false));
commit;
end;
/
set verify on feedback on define on
prompt  ...done


