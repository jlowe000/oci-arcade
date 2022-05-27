declare
    l_source apex_t_export_files;
begin
    l_source := apex_t_export_files (
        apex_t_export_file (
            name     => 'customers.sql',
            contents => apex_web_service.make_rest_request (
                p_url         => 'https://github.com/oracle/apex/raw/21.2/starter-apps/customers/customers.sql',
                p_http_method => 'GET' )));

    apex_util.set_workspace('OCIARCADE');
    apex_application_install.generate_application_id;
    apex_application_install.generate_offset;
    apex_application_install.set_authentication_scheme ( p_name => null );
    apex_application_install.set_auto_install_sup_obj( p_auto_install_sup_obj => true );
    apex_application_install.install(p_source => l_source );
end;
/
commit;
