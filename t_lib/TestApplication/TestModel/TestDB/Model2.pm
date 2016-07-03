package TestApplication::TestModel::TestDB::Model2;

use qbit;

use base qw(QBit::Application::Model::DB::mysql);

__PACKAGE__->meta(
    tables => {
        table2 => {
            fields => [
                {name => 'm2_field1',},
                {name => 'm2_field2', type => 'INT', not_null => TRUE},
                {name => 't2_field3', type => 'VARCHAR', length => 255, not_null => TRUE,},
                {name => 'idential', type => 'VARCHAR', length => 255, not_null => TRUE,},
            ],
            foreign_keys => [[['m2_field1'] => table1 => ['m1_field1']],]
        },

        table3 => {
            fields => [
                {name => 't3_field1', type => 'BIGINT', unsigned => TRUE, not_null => TRUE, autoincrement => TRUE},
                {name => 't3_field2',},
                {name => 'm2_field3', type => 'VARCHAR', length => 255, not_null => TRUE,},
            ],
            foreign_keys => [[['t3_field2'] => table2 => ['m2_field2']],]
        }
    },
);

TRUE;
