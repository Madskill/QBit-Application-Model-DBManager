package TestApplication::TestModel::TestDB;

use qbit;

use base qw(
  TestApplication::TestModel::TestDB::Model1
  TestApplication::TestModel::TestDB::Model2
  );

sub _connect {
    my ($self) = @_;

    unless (defined($self->{'__DBH__'})) {
        $self->{'__DBH__'}{$$} = DBI->connect('DBI:Mock:', '', '') || throw DBI::errstr();
    }

}

sub _get_all {
    my ($self, $sql) = @_;

    my $sql1 = q{SELECT
    "table1"."idential" AS "idential",
    "table1"."m1_field1" AS "m1_field1",
    "table1"."m1_field2" AS "m1_field2",
    "table1"."m1_field3" AS "m1_field3"
FROM "table1"
WHERE (
    (
        "table1"."m1_field1" = '1'
    )
)};

    my $sql_pre_m2 = q{SELECT
    "table2"."m2_field1" AS "m2_field1",
    "table3"."m2_field3" AS "m2_field3"
FROM "table2"
INNER JOIN "table3" ON (
    "table3"."t3_field2" = "table2"."m2_field2"
)
WHERE (
    (
        "table2"."m2_field1" IN ('1')
    )
)};

    my $sql2 = q{SELECT
    "table2"."idential" AS "idential",
    "table2"."m2_field1" AS "m2_field1",
    "table2"."m2_field2" AS "m2_field2",
    "table3"."m2_field3" AS "m2_field3",
    CONCAT("table2"."t2_field3", "table2"."idential") AS "m2_field6"
FROM "table2"
INNER JOIN "table3" ON (
    "table3"."t3_field2" = "table2"."m2_field2"
)
WHERE (
    (
        "table2"."m2_field1" = '1'
    )
)};

    my $sql_pre_m1 = q{SELECT
    "table1"."m1_field1" AS "m1_field1",
    "table1"."m1_field3" AS "m1_field3"
FROM "table1"
WHERE (
    (
        "table1"."m1_field1" IN ('1')
    )
)};

    my $sql3 = q{SELECT
    "table1"."m1_field1" AS "m1_field1",
    "table1"."m1_field2" AS "m1_field2",
    "table1"."m1_field3" AS "m1_field3",
    "table2"."m2_field2" AS "m2_field2",
    "table3"."m2_field3" AS "m2_field3",
    CONCAT("table2"."t2_field3", "table2"."idential") AS "m2_field6"
FROM "table1"
INNER JOIN "table2" ON (
    "table2"."m2_field1" = "table1"."m1_field1"
)
INNER JOIN "table3" ON (
    "table3"."t3_field2" = "table2"."m2_field2"
)
WHERE (
    (
        "table1"."m1_field1" = '1'
    )
)};

    my $sql4 = q{SELECT
    "table1"."idential" AS "idential",
    "table1"."m1_field1" AS "m1_field1",
    "table2"."idential" AS "model2_idential",
    "table2"."m2_field2" AS "model2_m2_field2",
    "table3"."m2_field3" AS "model2_m2_field3",
    CONCAT("table2"."t2_field3", "table2"."idential") AS "model2_m2_field6"
FROM "table1"
LEFT JOIN "table2" ON (
    "table2"."m2_field1" = "table1"."m1_field1"
)
INNER JOIN "table3" ON (
    "table3"."t3_field2" = "table2"."m2_field2"
)
WHERE (
    (
        "table1"."m1_field1" = '1'
    )
)};

    if ($sql eq $sql1) {
        return [{'idential' => 'iDeNTiaL', 'm1_field1' => 1, 'm1_field2' => 100, 'm1_field3' => 'm1_field3'}];
    } elsif ($sql eq $sql_pre_m2) {
        return [{'m2_field1' => 1, 'm2_field3' => 'field_from_t3'}];
    } elsif ($sql eq $sql2) {
        return [
            {
                'idential'  => 'iDeNTiaL',
                'm2_field1' => 1,
                'm2_field2' => 200,
                'm2_field3' => 'field_from_t3',
                'm2_field6' => 't2_field3iDeNTiaL'
            }
        ];
    } elsif ($sql eq $sql_pre_m1) {
        return [{'m1_field1' => 1, 'm1_field3' => 'm1_field3'}];
    } elsif ($sql eq $sql3) {
        return [
            {
                'm1_field1' => 1,
                'm1_field2' => 100,
                'm1_field3' => 'm1_field3',
                'm2_field2' => 200,
                'm2_field3' => 'field_from_t3',
                'm2_field6' => 't2_field3iDeNTiaL',
            }
        ];
    } elsif ($sql eq $sql4) {
        return [
            {
                'idential'         => 'iDeNTiaL',
                'm1_field1'        => 1,
                'model2_idential'  => 'iDeNTiaL',
                'model2_m2_field2' => 200,
                'model2_m2_field3' => 'field_from_t3',
                'model2_m2_field6' => 't2_field3iDeNTiaL',
            }
        ];
    } else {
        throw gettext('Unknown sql query');
    }
}

TRUE;

