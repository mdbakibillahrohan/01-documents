#!/usr/bin/env python3

import psycopg2
import psycopg2.extras as extras


class Connector:

    def __init__(self, user, password, host, port, database):
        try:
            self.connection = psycopg2.connect(user=user, password=password, host=host, port=port, database=database)

            self.cursor = self.connection.cursor(cursor_factory=extras.DictCursor)
        except (Exception, psycopg2.DatabaseError) as error:

            print("Error while connecting to PostgreSQL database", error)


    def post(self, table_query):
        try:
            self.cursor.execute(table_query)
            # records = [x[0] for x in cursor.fetchall()]
            records = self.cursor.fetchall()
            self.connection.commit()

        except (Exception, psycopg2.DatabaseError) as error:
            print("Error while executing PostgreSQL query", error)
            records=None

        finally:
            return records

    def close(self):
        try:
            if (self.connection):
                self.cursor.close()
                self.connection.close()
                print("PostgreSQL connection is closed")

        except (Exception, psycopg2.DatabaseError) as error:
            print("Error while closing PostgreSQL connection", error)



if __name__=='__main__':
    obj = Connector('postgres', 'admin', 'localhost', '5432', 'ump')
    out = obj.post( "select IS_NULLABLE as required, COLUMN_NAME as name, " \
            "(CASE WHEN UDT_NAME = 'numeric' THEN numeric_precision ELSE CHARACTER_MAXIMUM_LENGTH END) " \
            "as \"precision\", (CASE WHEN UDT_NAME = 'numeric' THEN numeric_scale END) as scale, " \
            "UDT_NAME as type, COALESCE((CASE "\
            "WHEN UDT_NAME = 'varchar' and COLUMN_NAME = 'createdby' and column_default is NOT NULL THEN 'current_user' " \
            "WHEN UDT_NAME = 'varchar' and column_default is NOT NULL " \
            "THEN trim(both '::character varying' from column_default) " \
            "WHEN UDT_NAME = 'text' and column_default is NOT NULL THEN trim(both '::text' from column_default) " \
            "WHEN UDT_NAME = 'numeric' and column_default is NOT NULL THEN replace(trim(both '::numeric' from column_default), '''', '')"\
            "when UDT_NAME = 'timestamp' and column_default is NOT NULL " \
            "THEN 'current_timestamp' else column_default END), null) as default " \
            "from information_schema.columns where  table_name ='" + 'allowance_setup' + "' and table_schema = '"+ 'cmn'+"'")
    # out = [x[0]]
    # out = re.findall(r'=\s*\'([A-Za-z0-9_ -]+)\'', out[0][2])
    print(([dict(x.items()) for x in out]))
