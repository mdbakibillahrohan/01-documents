#!/usr/bin/env python3

import os
import sys
import json
from functional import seq

summary = {
    'matched_tables': 0,
    'unmatched_script_tables': 0,
    'unmatched_livedb_tables': 0,
    'matched_columns': 0,
    'unmatched_script_columns': 0,
    'unmatched_livedb_columns': 0,
    'matched_constraints': 0,
    'unmatched_script_constraints': 0,
    'unmatched_livedb_constraints': 0,
    'column_common_keys' : 0,
    'column_unmatched_script_unique_keys' : 0,
    'column_unmatched_livedb_unique_keys' : 0,
    'column_unmatched_value_keys' : 0,
    'constraint_common_keys' : 0,
    'constraint_unmatched_script_unique_keys' : 0,
    'constraint_unmatched_livedb_unique_keys' : 0,
    'constraint_unmatched_value_keys' : 0
}

db1 = 'dbscript'
db2 = 'livedb'
outdir = './outputs/'
schema =''

if len(sys.argv) == 3:

    db1 = 'livedb{}'.format(sys.argv[1])
    db2 = 'livedb{}'.format(sys.argv[2])
    print("Comparing jsons: {} and {}".format(db1, db2))

else :
    db1 = 'dbscript{}'.format(sys.argv[1])
    db2 = 'livedb{}'.format(sys.argv[1])
    print("Comparing jsons: {} and {}".format(db1, db2))


def output_total_data(result):
    with open(outdir+schema+'/compare_data.json', 'w') as outfile:
        json.dump(result, outfile, indent=2, separators=(',', ':'))


def output(code=None, result=None, id=None):
    msg = ""
    if code is None:
        with open(outdir+schema+'/compare_result.html', 'w') as outfile:
            outfile.write("")
    elif code == 'l':
        msg = "<html><head><title>Database testing report</title>" \
            "<style> .success, .success a{color:green;} " \
              " .error{color:red;} div{padding:5px 10px 5px 20px}</style></head><body>"
        if result:
            msg += "<h2><div class='error'>Result - Failed</div></h2>"
        else:
            msg += "<h2><div class='success'>Result - Success</div></h2>"
        with open(outdir+schema+'/compare_result.html', "r+") as f:
            s = f.read();
            f.seek(0);
            f.write(msg + "\n" + s)
        return;
    elif code == 'h':
        if id:
            msg = "<h2 id='{}'>{}</h2>".format(id, result)
        else:
            msg = "<h2>" + result + "</h2>"
    elif code == 'h2':
        if id:
            msg = "<h4 id='{}'>{}</h4>".format(id, result)
        else:
            msg = "<h4>" + result + "</h4>"
    elif code == 's':
        msg = "<div class='success'>" + result + "</div>"
    elif code == 'e':
        msg = "<div class='error'>" + result + "</div>"
    elif code == 'x':
        msg = "</body></html>"

    with open(outdir+schema+'/compare_result.html', 'a') as outfile:
        outfile.write(msg)


def load_data():
    data = {}
    with open(outdir+schema+'/result_{}.json'.format(db1), 'r') as data_file:
        db_script = json.loads(data_file.read())
        # data['db_script'] = seq(db_script).map(lambda a: a['tables']).reduce(lambda a, b: a + b).to_list()
        data['db_script'] = db_script
    with open(outdir+schema+'/result_{}.json'.format(db2), 'r') as data_file:
        data['db_live'] = json.loads(data_file.read())
    return data


def compare_tables(data):
    script_tables = set((seq(data['db_script']).map(lambda a: a['table'].lower()).to_list()))
    livedb_tables = set((seq(data['db_live']).map(lambda a: a['table'].lower()).to_list()))

    output('h', 'Comparing All Tables between {} and {} of {}'.format(db1, db2,schema), 'top')
    txt = 'Total tables found in {} - {} and in {} - {}'.format(db1, len(script_tables), db2, len(livedb_tables))
    if len(script_tables) == len(livedb_tables):
        output('s', 'Success : ' + txt)
    else:
        output('e', 'Failed : ' + txt)

    matched_tables = list(script_tables & livedb_tables)
    script_unique_tables = list(script_tables - livedb_tables)
    livedb_unique_tables = list(livedb_tables - script_tables)

    summary['matched_tables'] += len(matched_tables)
    summary['unmatched_script_tables'] += len(script_unique_tables)
    summary['unmatched_livedb_tables'] += len(livedb_unique_tables)

    matched_tables.sort()
    script_unique_tables.sort()
    livedb_unique_tables.sort()
    matched_table_str = seq(matched_tables).map(lambda t: "<li><a href='#{}'>{}</a></li>\n".format(t.lower(), t)).reduce(lambda a, b: a + b)
    output('s', "Success : Tables matched - {}. Those are - <ol>{}</ol>".format(str(len(matched_tables)), matched_table_str))
    if len(script_unique_tables) > 0:
        output('e', 'Failed : Tables found in {} but not in {} - {}'.format(db1, db2, str(len(script_unique_tables)))
               + ' ; Those are - <ol><li>' + '</li><li>'.join(script_unique_tables) + '</li></ol>')
    if len(livedb_unique_tables) > 0:
        output('e', 'Failed : Tables found in {} but not in {} - {}'.format(db2, db1, str(len(livedb_unique_tables)))
               + ' ; Those are - <ol><li>' + '</li><li>'.join(livedb_unique_tables) + '</li></ol>')

    return seq(matched_tables).map(lambda a: compare_single_table(a, data)).to_list()


def compare_single_table(table_name, data):
    script_table = seq(data['db_script']).filter(lambda t: t['table'].lower() == table_name).to_list()[0]
    livedb_table = seq(data['db_live']).filter(lambda t: t['table'].lower() == table_name).to_list()[0]
    return {'compareColumn': compare_columns(script_table, livedb_table),
            'compareConstraints': compare_constraints(script_table, livedb_table)}


def compare_columns(script_table, livedb_table):
    script_column_names = set((seq(script_table['columns']).map(lambda a: a['name'].lower()).to_list()))
    livedb_column_names = set((seq(livedb_table['columns']).map(lambda a: a['name'].lower()).to_list()))
    space = '&nbsp;' * 20
    output('h', 'Table name : ' + script_table['table'] + space + "<a href='#top'><sub>!</sub>^<sub>!</sub><a/>", script_table['table'].lower())

    txt = 'Total columns found in {} - {} and in {} - {}'.format(db1, len(script_column_names), db2, len(livedb_column_names))
    if len(script_column_names) == len(livedb_column_names):
        output('s', 'Success : ' + txt)
    else:
        output('e', 'Failed : ' + txt)

    matched_columns = list(script_column_names & livedb_column_names)
    script_unique_columns = list(script_column_names - livedb_column_names)
    livedb_unique_columns = list(livedb_column_names - script_column_names)

    summary['matched_columns'] += len(matched_columns)
    summary['unmatched_script_columns'] += len(script_unique_columns)
    summary['unmatched_livedb_columns'] += len(livedb_unique_columns)

    matched_columns.sort()
    script_unique_columns.sort()
    livedb_unique_columns.sort()

    output('s', 'Success : Total columns matched - ' + str(len(matched_columns))
           + '. Those are - <ol><li>' + '</li><li>'.join(matched_columns) + '</li></ol>')
    if len(script_unique_columns) > 0:
        output('e', 'Failed : Columns found in {} but not in {} - {}'.format(db1, db2, len(script_unique_columns))
               + '. Those are - <ol><li>' + '</li><li>'.join(script_unique_columns) + '</li></ol>')
    if len(livedb_unique_columns) > 0:
        output('e', 'Failed : Columns found in {} but not in {} - {}'.format(db2, db1, str(len(livedb_unique_columns)))
               + '; Those are - <ol><li>' + '</li><li>'.join(livedb_unique_columns) + '</li></ol>')

    output('h2', "Comparing Columns Properties of table - <b>{}</b> : ".format(script_table['table']))
    for c in matched_columns:
        compare_column_properties(script_table, get_column_obj(c, script_table), get_column_obj(c, livedb_table))

    return matched_columns


def get_column_obj(column_name, table_obj):
    column = seq(table_obj['columns']).filter(lambda c: c['name'].lower() == column_name.lower()).to_list()
    if len(column) > 0:
        return column[0]
    return {}


def compare_column_properties(table_obj, script_column, livedb_column):
    script_column_keys = set(script_column.keys())
    livedb_column_keys = set(livedb_column.keys())

    common_keys = script_column_keys & livedb_column_keys
    script_unique_keys = script_column_keys - livedb_column_keys
    livedb_unique_keys = livedb_column_keys - script_column_keys
    unmatched_value_keys = []
    for k in common_keys:
        if k == 'name':
            continue
        if script_column[k] != livedb_column[k]:
            unmatched_value_keys.append(k)

    summary['column_common_keys'] += len(common_keys)
    summary['column_unmatched_script_unique_keys'] += len(script_unique_keys)
    summary['column_unmatched_livedb_unique_keys'] += len(livedb_unique_keys)
    summary['column_unmatched_value_keys'] += len(unmatched_value_keys)

    # output('s', "Total Proparties matched - "+str(len(common_keys))
    #            + '; Those are - <ul><li>'+"</li><li>".join(common_keys)+"</li></ul>")
    if len(script_unique_keys) > 0 or len(livedb_unique_keys) > 0 or len(unmatched_value_keys) != 0:
        output('e', "<b>Failed :  Column name - " + script_column['name'] + "</b>")

    if len(script_unique_keys) > 0:
        output('e', "Properites found in {} but not in {} - {}".format(db1, db2, str(len(script_unique_keys)))
               + '; Those are - <ul><li>' + "</li><li>".join(script_unique_keys) + "</li></ul>")
    if len(livedb_unique_keys) > 0:
        output('e', "Properites found in {} but not in {} - {}".format(db2, db1, str(len(livedb_unique_keys)))
               + '; Those are - <ul><li>' + "</li><li>".join(livedb_unique_keys) + "</li></ul>")
    if len(unmatched_value_keys) != 0:
        for i in unmatched_value_keys:
            output('e', "Property value doesn't match. Property Name - {}, value in {} - {}, value in {} - {}"
                   .format(i, db1, script_column[i], db2, livedb_column[i]))
    return unmatched_value_keys


def compare_constraints(script_table, livedb_table):
    script_constraints_names = set((seq(script_table['constraints']).map(lambda a: a['name'].lower()).to_list()))
    livedb_constraints_names = set((seq(livedb_table['constraints']).map(lambda a: a['name'].lower()).to_list()))

    output('h2', "Comparing columns constraints of table - <b>{}</b>  : ".format(script_table['table']))

    txt = 'Total constraints found in {} - {} and in {} - {}'.format(db1, len(script_constraints_names), db2, len(livedb_constraints_names))

    if len(script_constraints_names) == len(livedb_constraints_names):
        output('s', 'Success : ' + txt)
    else:
        output('e', 'Failed : ' + txt)

    matched_constraints = list(script_constraints_names & livedb_constraints_names)
    script_unique_constraints = list(script_constraints_names - livedb_constraints_names)
    livedb_unique_constraints = list(livedb_constraints_names - script_constraints_names)

    '''
    for c in script_table['constraints']:
        # print(c)
        if c['type'] == 'primary key':
            print('alter table {}.{} add constraint {} primary key (oid);'.format(schema, script_table['table'], c['name'], ','.join(c['column']) ))
        elif c['type'] == 'foreign key':
            print('alter table {}.{} add constraint {} foreign key ({}) references {}({});'.format(schema, script_table['table'], c['name'], c['column'], c['referenceTable'], c['referenceColumn'] ))
        elif c['type'] == 'check':
            l = seq(c['values']).map(lambda a: "{} = '{}'".format(c['column'], a)).to_list()
            print('alter table {}.{} add constraint {} check ({});'.format(schema, script_table['table'], c['name'], " or ".join(l) ))
        elif c['type'] == 'unique':
             print('alter table {}.{} add constraint {} unique ({});'.format(schema, script_table['table'], c['name'], c['column'] ))
    '''

    summary['matched_constraints'] += len(matched_constraints)
    summary['unmatched_script_constraints'] += len(script_unique_constraints)
    summary['unmatched_livedb_constraints'] += len(livedb_unique_constraints)

    matched_constraints.sort()
    script_unique_constraints.sort()
    livedb_unique_constraints.sort()

    output('s', 'Success : Total constraints matched - ' + str(len(matched_constraints))
           + '. Those are - <ol><li>' + '</li><li>'.join(matched_constraints) + '</li></ol>')
    if len(script_unique_constraints) > 0:
        output('e', 'Failed : Constraints found in {} but not in {} - {}'.format(db1, db2, len(script_unique_constraints))
               + '. Those are - <ol><li>' + '</li><li>'.join(script_unique_constraints) + '</li></ol>')
    if len(livedb_unique_constraints) > 0:
        output('e', 'Failed : Constraints found in {} but not in {} - {}'.format(db2, db1, str(len(livedb_unique_constraints)))
               + '; Those are - <ol><li>' + '</li><li>'.join(livedb_unique_constraints) + '</li></ol>')

    output('h2', "Comparing Constraints Properties ..............")
    for c in matched_constraints:
        compare_constraint_properties(get_constraint_obj(c, script_table), get_constraint_obj(c, livedb_table))

    return matched_constraints


def get_constraint_obj(constraint_name, table_obj):
    column = seq(table_obj['constraints']).filter(lambda c: c['name'].lower() == constraint_name.lower()).to_list()
    if len(column) > 0:
        return column[0]
    return {}


def compare_constraint_properties(script_constraint, livedb_constraint):
    script_constraint_keys = set(script_constraint.keys())
    livedb_constraint_keys = set(livedb_constraint.keys())

    common_keys = script_constraint_keys & livedb_constraint_keys
    script_unique_keys = script_constraint_keys - livedb_constraint_keys
    livedb_unique_keys = livedb_constraint_keys - script_constraint_keys
    unmatched_value_keys = []

    for k in common_keys:
        if k == 'name':
            continue
        if script_constraint['type'] == 'primary key':
            if script_constraint['type'] not in livedb_constraint['type'].lower():
                unmatched_value_keys.append('type')
                break
            script_pri_col = seq(script_constraint['column']).map(lambda c: c.lower()).to_set()
            livedb_pri_col = seq(livedb_constraint['column']).map(lambda c: c.lower()).to_set()
            if len(script_pri_col - livedb_pri_col) != 0:
                unmatched_value_keys.append('column')
            break
        elif script_constraint['type'] == 'check':
            if script_constraint['type'] != livedb_constraint['type'].lower():
                unmatched_value_keys.append('type')
                break
            if script_constraint['column'].lower() != livedb_constraint['column'].lower():
                unmatched_value_keys.append('column')
            script_chk_col = seq(script_constraint['values']).map(lambda c: c.lower()).to_set()
            livedb_chk_col = seq(livedb_constraint['values']).map(lambda c: c.lower()).to_set()
            if len(script_chk_col - livedb_chk_col) != 0:
                unmatched_value_keys.append('values')
            break
        elif script_constraint[k].lower().strip() != livedb_constraint[k].lower().strip():
            unmatched_value_keys.append(k)

    summary['constraint_common_keys'] += len(common_keys)
    summary['constraint_unmatched_script_unique_keys'] += len(script_unique_keys)
    summary['constraint_unmatched_livedb_unique_keys'] += len(livedb_unique_keys)
    summary['constraint_unmatched_value_keys'] += len(unmatched_value_keys)

    if len(script_unique_keys) > 0 or len(livedb_unique_keys) > 0 or len(unmatched_value_keys) != 0:
        output('e', "<b>Failed : Column name - {}, Constraint name - {} : </b>".format(str(script_constraint['column']), script_constraint['name']))
    if len(script_unique_keys) > 0:
        output('e', "Properites found in {} but not in {} - {}".format(db1, db2, str(len(script_unique_keys)))
               + '; Those are - <ul><li>' + "</li><li>".join(script_unique_keys) + "</li></ul>")
    if len(livedb_unique_keys) > 0:
        output('e', "Properites found in {} but not in {} - {}".format(db2, db1, str(len(livedb_unique_keys)))
               + '; Those are - <ul><li>' + "</li><li>".join(livedb_unique_keys) + "</li></ul>")
    if len(unmatched_value_keys) != 0:
        for i in unmatched_value_keys:
            output('e', "Property value doesn't match. Property Name - {}, value in {} - {}, value in {} - {}"
                   .format(i, db1, str(script_constraint[i]), db2, str(livedb_constraint[i])))

    return unmatched_value_keys


def compare_db():
    data = load_data()
    compare_tables(data)


def print_summary():
    print("Total tables matched : {}\n"
          "Unmatched tables in Script : {}\n"
          "Unmatched tables in livedb : {}\n\n"
          "Total columns matched : {}\n"
          "Unmatched columns in Script : {}\n"
          "Unmatched columns in livedb : {}\n\n"
          "Total constraint matched : {}\n"
          "Unmatched constraint in Script : {}\n"
          "Unmatched constraint in livedb : {}\n"
          .format(summary['matched_tables'],
                  summary['unmatched_script_tables'],
                  summary['unmatched_livedb_tables'],
                  summary['matched_columns'],
                  summary['unmatched_script_columns'],
                  summary['unmatched_livedb_columns'],
                  summary['matched_constraints'],
                  summary['unmatched_script_constraints'],
                  summary['unmatched_livedb_constraints'])
          )


def last():
    failed = False
    if(summary['unmatched_script_tables'] > 0
        or summary['unmatched_livedb_tables'] > 0
        or summary['unmatched_script_columns'] > 0
        or summary['unmatched_livedb_columns'] > 0
        or summary['unmatched_script_constraints'] > 0
        or summary['unmatched_livedb_constraints'] > 0
        or summary['column_unmatched_script_unique_keys'] > 0
        or summary['column_unmatched_livedb_unique_keys'] > 0
        or summary['column_unmatched_value_keys'] > 0
        or summary['constraint_unmatched_script_unique_keys'] > 0
        or summary['constraint_unmatched_livedb_unique_keys'] > 0
        or summary['constraint_unmatched_value_keys'] > 0):
        failed = True
    output('l', failed)



def main():
    schemas = [f for f in os.listdir('./outputs/') if os.path.isdir('./outputs/'+f)]
    global schema
    for schema_name in schemas:
        print("Comparing schema: " + schema)
        schema=schema_name
        output()
        compare_db()
        print_summary()
        last()
        output('x')


if __name__ == '__main__':
    main()
    # print()
