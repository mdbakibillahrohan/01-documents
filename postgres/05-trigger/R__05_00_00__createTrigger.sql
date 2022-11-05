DROP TRIGGER IF EXISTS update_menu_json_login ON Role;
DROP FUNCTION IF EXISTS update_menu_json_login();
CREATE OR REPLACE FUNCTION update_menu_json_login()
RETURNS TRIGGER AS $update_menu_json_login$
    BEGIN
        update Login l
        set menuJson = r.menuJson, reportJson = r.reportJson
        from Role r
        where 1 = 1
        and r.oid = l.roleOid;
        RETURN NULL;
    END;
$update_menu_json_login$ LANGUAGE plpgsql;

CREATE TRIGGER update_menu_json_login AFTER UPDATE ON Role
FOR EACH ROW EXECUTE PROCEDURE update_menu_json_login();
