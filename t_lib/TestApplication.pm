package TestApplication;

use qbit;

use base qw(QBit::Application);

use TestApplication::TestModel::Model1 accessor => 'model_1';
use TestApplication::TestModel::Model2 accessor => 'model_2';
use TestApplication::TestModel::TestDB accessor => 'db';

TRUE;
