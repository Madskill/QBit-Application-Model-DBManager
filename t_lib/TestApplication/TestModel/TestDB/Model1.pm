package TestApplication::TestModel::TestDB::Model1;

use qbit;

use base qw(QBit::Application::Model::DB::mysql);

__PACKAGE__->meta(
    tables => {
        table1 => {
            fields => [
                {name => 'm1_field1', type => 'BIGINT', unsigned => TRUE, not_null => TRUE, autoincrement => TRUE},
                {name => 'm1_field2', type => 'INT',    not_null => TRUE},
                {name => 'm1_field3', type => 'VARCHAR', length => 255, not_null => TRUE,},
                {name => 'idential', type => 'VARCHAR', length => 255, not_null => TRUE,},
            ],
            primary_key => ['m1_field1'],
        },
    },
);

TRUE;
