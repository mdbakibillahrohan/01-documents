#!/usr/bin/env python3

import os
import json
import re
import sys
from copy import copy
from postgres_connector import Connector

db_connector = None

def connect(user, password, host, port, database):
    global db_connector
    db_connector = Connector(user=user, password=password, host=host, port=port, database=database)
    if db_connector is None:
        print("Connection failed!!!!!")
        exit(-1)


def get_check_values(obj):
    obj['values'] = re.findall(r'=\s*\'([A-Za-z0-9_ -]+)\'', obj['values'])
    return obj


def process_columns(columns):
    for key in list(columns.keys()):
        if columns[key] is None:
            del columns[key]

    if 'required' in columns.keys():
        columns['required'] = False if columns['required']!='NO' else True

    return columns


def output(result,schema_name, out_tag):
    if not os.path.exists('./outputs/'+schema_name+'/'):
        os.mkdir('./outputs/'+schema_name+'/')
    with open('./outputs/{}/result_livedb{}.json'.format(schema_name, out_tag), 'w') as outfile:
        json.dump(result, outfile, indent=2, separators=(',', ':'))


def get_foreign_key_constraints(table_name, schema_name):
    sql = "SELECT tc.constraint_name \"name\", kcu.column_name \"column\", LOWER(constraint_type) \"type\", " \
          "ccu.table_schema as \"schema\",ccu.table_name AS \"referenceTable\", ccu.column_name AS \"referenceColumn\" " \
          "FROM information_schema.table_constraints AS tc, " \
          "information_schema.key_column_usage AS kcu, " \
          "information_schema.constraint_column_usage AS ccu " \
          "where 1 = 1 and tc.constraint_schema = kcu.constraint_schema " \
          "and tc.constraint_name = kcu.constraint_name " \
          "and tc.table_schema = kcu.table_schema " \
          "and tc.table_name = kcu.table_name " \
          "and tc.constraint_schema = ccu.constraint_schema " \
          "and tc.constraint_name = ccu.constraint_name " \
          "and tc.constraint_type = 'FOREIGN KEY' and tc.table_name='" + table_name + "' "\
          "and tc.table_schema = '"+ schema_name+"' and tc.constraint_schema = '"+ schema_name+"'"

    return [{'name':x['name'],'type':x['type'],'column':x['column'],
            'referenceTable': '\"'+x['schema']+'\".'+x['referenceTable'],'referenceColumn': x['referenceColumn']}
            for x in db_connector.post(sql)]


def get_check_constraints(table_name, schema_name):
    sql = "select tc.constraint_name \"name\", LOWER(tc.constraint_type) \"type\", " \
          "cc.check_clause \"values\", ccu.column_name \"column\"" \
          "from information_schema.table_constraints tc, " \
          "information_schema.check_constraints cc, " \
          "information_schema.constraint_column_usage ccu " \
          "where 1 = 1 and tc.constraint_schema = cc.constraint_schema " \
          "and tc.constraint_name = cc.constraint_name " \
          "and tc.constraint_schema = ccu.constraint_schema " \
          "and tc.constraint_name = ccu.constraint_name " \
          "and tc.table_schema = ccu.table_schema " \
          "and tc.table_name = ccu.table_name " \
          "and tc.constraint_type = 'CHECK' and cc.check_clause not like '%NULL%' "\
          "and tc.table_name='" + table_name + "' " \
          "and tc.table_schema = '"+ schema_name +"' and tc.constraint_schema = '"+ schema_name +"'"
    return [get_check_values(dict(x.items())) for x in db_connector.post(sql)]


def get_contraints(table_name,schema_name):
    sql = "select kcu.column_name \"column\", tc.constraint_name \"name\", LOWER(tc.constraint_type) \"type\" " \
          "from information_schema.table_constraints tc, " \
          "information_schema.key_column_usage kcu " \
          "where 1 = 1 and tc.constraint_schema = kcu.constraint_schema " \
          "and tc.table_schema = kcu.table_schema " \
          "and tc.table_name = kcu.table_name " \
          "and tc.constraint_name = kcu.constraint_name " \
          "and tc.constraint_type IN ('UNIQUE', 'PRIMARY KEY') and tc.table_name='" + table_name + "' "\
          "and tc.table_schema = '"+ schema_name +"' and tc.constraint_schema = '"+ schema_name +"'"
    constrains = [dict(x.items()) for x in db_connector.post(sql)]

    constrains_new = []
    constrains_names = []
    for c in constrains:
        if c['type'] == 'primary key':
            if c['name'] not in constrains_names:
                c['column'] = [c['column']]
                constrains_new.append(c)
                constrains_names.append(c['name'])
            else:
                constrains_new[constrains_names.index(c['name'])]['column'].append(c['column'])
        else:
            constrains_new.append(c)
    constrains_new.extend(get_check_constraints(table_name,schema_name))
    constrains_new.extend(get_foreign_key_constraints(table_name,schema_name))
    return constrains_new


def get_columns(table_name,schema_name):

    sql =   "select IS_NULLABLE as required, COLUMN_NAME as name, " \
            "(CASE WHEN UDT_NAME = 'numeric' THEN numeric_precision ELSE CHARACTER_MAXIMUM_LENGTH END) " \
            "as \"precision\", (CASE WHEN UDT_NAME = 'numeric' THEN numeric_scale END) as scale, " \
            "UDT_NAME as type, COALESCE((CASE "\
            "WHEN UDT_NAME = 'varchar' and COLUMN_NAME = 'createdby' and column_default is NOT NULL THEN '''System''' " \
            "WHEN UDT_NAME = 'varchar' and column_default is NOT NULL " \
            "THEN trim(both '::character varying' from column_default) " \
            "WHEN UDT_NAME = 'text' and column_default is NOT NULL THEN trim(both '::text' from column_default) " \
            "WHEN UDT_NAME = 'numeric' and column_default is NOT NULL THEN replace(trim(both '::numeric' from column_default), '''', '')"\
            "when UDT_NAME = 'timestamp' and column_default is NOT NULL " \
            "THEN 'current_timestamp' else column_default END), null) as default " \
            "from information_schema.columns where  table_name ='" + table_name + "' and table_schema = '"+ schema_name+"'"
    return [process_columns(dict(x.items())) for x in db_connector.post(sql)]


def get_all_tables(schema_name):
    # print("Getting data from ", base_test_case._URL)
    sql = "SELECT table_name as table FROM information_schema.tables " \
          "WHERE table_schema='"+schema_name+"' and table_name not like 'qrtz_%' " \
          "and table_name not like 'batch_%' and table_name != 'schema_version' " \
          "and table_name not ilike '%_y20%' and table_name not like 'flyway_%' " \
          "and table_type='BASE TABLE' " \
          "order by table_name"
    return [x['table'] for x in db_connector.post(sql)]

def get_all_schemas(owner):
    sql = "select schema_name as schema from information_schema.schemata where schema_owner = '"+owner+"'"
    return [x['schema'] for x in db_connector.post(sql)]

def collect_livedb_data():
    if (len(sys.argv) < 2):
        print('Usage:', sys.argv[0], 'user, password, host, port, database, owner')
        exit(-1)
    user = sys.argv[1]
    password = sys.argv[2]
    host = sys.argv[3]
    port = sys.argv[4]
    database = sys.argv[5]
    owner = sys.argv[6]
    out_tag =sys.argv[7]
    schemas = [x.split('-')[1] if '-'in x else x for x in sys.argv[8:]]
    print('Schemas to compare in liveDB: ', schemas)
    connect(user, password, host, port, database)
    # schemas = get_all_schemas(owner)

    for schema_name in schemas:
        table_data = []
        print("processing schema: "+schema_name)
        tables = get_all_tables(schema_name)
        for table in tables:
            data = {}
            data['table']=table
            data['columns'] = get_columns(table,schema_name)
            data['constraints']= get_contraints(table,schema_name)
            table_data.append(data)
        output(table_data,schema_name, out_tag)
    db_connector.close()


if __name__ == '__main__':
    collect_livedb_data()
