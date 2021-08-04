declare
    id number;
begin
    apex_util.set_workspace ('OCIARCADE');
    id := APEX_PKG_APP_INSTALL.INSTALL('Customer Tracker',APEX_AUTHENTICATION.C_TYPE_APEX_ACCOUNTS,'OCIARCADE');
end;
/
commit;
