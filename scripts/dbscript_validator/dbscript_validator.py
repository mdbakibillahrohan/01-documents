#!/usr/bin/env python3

'''
Usage:
./dbscript_validator.py /home/ashraf/Documents/repo/idra-doer/policy-repository/13-document/archived/services/antarika/script/postgres/01-table
'''

import os
import sys
import re
import json
import greptile
from functional import seq

def output(result,schema, out_tag):
    if not os.path.exists('./outputs/'+schema+'/'):
        os.mkdir('./outputs/'+schema+'/')
    with open('./outputs/{}/result_dbscript{}.json'.format(schema, out_tag), 'w') as outfile:
        json.dump(result, outfile, indent=2, separators=(',', ':'))


def parse_column(table_name, s):
    r = '^(?P<name>.+?)[\s]+(?P<type>[a-z0-9(),]+)'
    f = '[\s]+default[\s]+(?P<value>.+)'
    d = {}
    mo = re.search(r, s)
    d['name'] = mo.group('name')
    t = mo.group('type').replace(' ', '').rstrip(')').replace('(', ',').split(',')
    if len(t) >= 1:
        d['type'] = t[0]
    if len(t) >= 2:
        d['precision'] = int(t[1])
    if len(t) >= 3:
        # print(table_name, ' - ', d)
        d['scale'] = int(t[2])
    if 'not null' in s:
        d['required'] = True
    else:
        d['required'] = False

    if ' default ' in s:
        mo = re.search(f, s)
        d['default'] = mo.group('value')

    return d


def parse_constraint(table_name, s,schema):
    r = '^(?P<name>.+?)[\s]+(?P<text>.+$)'
    d = {}
    mo = re.search(r, s)
    d['name'] = mo.group('name')
    text = mo.group('text')
    if text.startswith('primary key'):
        d['type'] = 'primary key'
        text = re.sub('primary key\s+', '', text)
        d['column'] = seq(text.lstrip('(').rstrip(')').split(',')).map(lambda c: c.strip()).to_list()
    elif text.startswith('unique'):
        d['type'] = 'unique'
        text = re.sub('unique\s+', '', text)
        d['column'] = text.lstrip('(').rstrip(')')
    elif text.startswith('foreign key'):
        d['type'] = 'foreign key'
        text = re.sub('foreign key\s+', '', text).split('references')
        if len(text) >= 1:
            d['column'] = text[0].strip().rstrip(')').lstrip('(')
        if len(text) >= 2:
            str = text[1]
            str = str[:str.index(')') + 1].strip().rstrip(')').split('(')
            if len(str) >= 1:
                d['referenceTable'] = str[0]
            if len(str) >= 2:
                d['referenceColumn'] = str[1]
    elif text.startswith('check'):
        d['type'] = 'check'
        text = re.sub('check\s+', '', text).lstrip('(').rstrip(')')
        mo_col = re.search('^[\s]*(?P<col_name>.+?)[\s]+', text)
        col_name = mo_col.group('col_name')
        d['column'] = col_name
        r = '\s*' + col_name + '\s*=\s*\'([A-Za-z0-9-_ ]*)\''
        d['values'] = re.findall(r, text)
    else:
        d['type'] = 'none'
        d['text'] = text
        pass
    return d


def get_columns(tableObject, sqlText, schema):
    tableObject['columns'] = seq(sqlText).filter_not(lambda l: re.search(r'^constraint\s', l)).map(lambda s: parse_column(tableObject['table'], s)).to_list()
    tableObject['constraints'] = seq(sqlText).filter(lambda l: re.search(r'^constraint\s', l)).map(
        lambda l: re.sub('constraint\s+', '', l)).map(lambda s: parse_constraint(tableObject['table'], s,schema)).to_list()
    return tableObject


def get_table_body(fileContent, table, schema):
    r = "create table[\s]+" +"\""+schema+"\"." +table + '\s*\(.+?;'
    ro = re.search(r, fileContent, re.DOTALL)
    if ro is not None:
        mo = re.search(r'\((?P<body>.+)\)', ro.group(), re.DOTALL)
        l = re.sub(r',[\s]*\n', ',,', mo.group('body')).split(',,')
        return seq(l).map(lambda s: re.sub(r'\s+', ' ', s)).map(lambda s: ' '.join(s.split())).to_list()
    else:
        return []


def list_tables(sql_file,schema):
    with open(sql_file, 'r') as content_file:
        fileContent = content_file.read()


    return (seq(fileContent.split('\n'))
            .filter(lambda l: re.search(r'create table[\s]+[".A-Za-z0-9_]+', l))
            .map(lambda l: re.sub('create table\s+"[a-z]+".', '', l).strip())
            .map(lambda t: {'table': t}) #"[a-z]+".
            .map(lambda d: get_columns(d, get_table_body(fileContent, d['table'],schema),schema))
            .to_list()
            )


def list_files(root_dir):
    # sql_generators = []
    #dir_list = os.listdir(root_dir)
    #for dir in dir_list:
    #     sql_generators.append(greptile.grep_rl('create table\s+[."A-Za-z0-9_]+', root_dir+'/'+dir, '.sql'))
    sql_generators = [greptile.grep_rl('create table\s+[."A-Za-z0-9_]+', root_dir, '.sql')]
    return sql_generators


def browse(root_dir, schema):
    sql_data = []
    generators = list_files(root_dir + '/' + schema)
    for gen in generators:
        data =(seq(gen).map(lambda f: {'filePath': f, 'tables': list_tables(f, schema.split('-')[1])}).to_list())
        sql_data += data
    return sql_data


def main():
    if (len(sys.argv) < 2):
        print('Usage:', sys.argv[0], 'rootPath')
        exit(-1)
    rootPath=sys.argv[1]
    out_tag =sys.argv[2]
    schemas = sys.argv[3:]
    print('schemas to compare in DBscript: ', schemas)
    # schemas= os.listdir(rootPath)

    for schema in schemas:
        print("processing schema: "+schema)
        result = browse(rootPath, schema)
        tables = []
        for f in result:
            tables += f['tables']
        output(tables,schema.split('-')[1], out_tag)


if __name__ == '__main__':
    main()
