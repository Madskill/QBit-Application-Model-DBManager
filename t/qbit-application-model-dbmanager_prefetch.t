#!/usr/bin/perl

use lib::abs qw(../lib);

use Test::More tests => 4;
use Test::Deep;

use qbit;

use TestApplication;

my $app = TestApplication->new();

$app->pre_run();

cmp_deeply(
    $app->model_1->prefetch(
        fields => [keys(%{$app->model_1->get_model_fields})],
        filter => {m1_field1 => 1}
    ),
    [
        {
            'idential'  => 'iDeNTiaL',
            'm1_field5' => {
                'm2_field1' => 1,
                'm2_field3' => 'field_from_t3'
            },
            'm1_field3' => 'm1_field3',
            'm1_field4' => '100 - m1_field3',
            'm1_field2' => 100,
            'm1_field1' => 1
        },
    ],
    'get_all from one model_1'
);

cmp_deeply(
    $app->model_2->prefetch(
        fields => [keys(%{$app->model_2->get_model_fields})],
        filter => {m2_field1 => 1}
    ),
    [
        {
            'm2_field2' => 200,
            'm2_field3' => 'field_from_t3',
            'm2_field6' => 't2_field3iDeNTiaL',
            'idential'  => 'iDeNTiaL',
            'm2_field4' => '200 - field_from_t3',
            'm2_field5' => ['m1_field3'],
            'm2_field1' => 1
        }
    ],
    'get_all from one model_2'
);

cmp_deeply(
    $app->model_1->prefetch(
        fields => [qw(m1_field1 m1_field2 m1_field4)],
        filter => {m1_field1 => 1},
        models => [
            {
                accessor => 'model_2',
                fields   => [qw(m2_field2 m2_field4 m2_field6)],
            }
        ],
    ),
    [
        {
            'm1_field2' => 100,
            'm2_field2' => 200,
            'm1_field1' => 1,
            'm2_field4' => '200 - field_from_t3',
            'm1_field4' => '100 - m1_field3',
            'm2_field6' => 't2_field3iDeNTiaL'
        }
    ],
    'prefetch models with difference fields'
);

cmp_deeply(
    $app->model_1->prefetch(
        fields => [qw(m1_field1 idential)],
        filter => {m1_field1 => 1},
        models => [
            {
                accessor  => 'model_2',
                fields    => [qw(m2_field2 m2_field3 m2_field4 idential m2_field6)],
                prefix    => 'model2',
                join_type => 'LEFT JOIN',
            }
        ],
    ),
    [
        {
            'model2_m2_field3' => 'field_from_t3',
            'model2_m2_field2' => 200,
            'model2_idential'  => 'iDeNTiaL',
            'm1_field1'        => 1,
            'model2_m2_field6' => 't2_field3iDeNTiaL',
            'model2_m2_field4' => '200 - field_from_t3',
            'idential'         => 'iDeNTiaL'
        }
    ],
    'prefetch models with prefix'
);

$app->post_run();
