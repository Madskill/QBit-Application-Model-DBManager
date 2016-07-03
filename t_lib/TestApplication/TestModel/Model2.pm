package TestApplication::TestModel::Model2;

use qbit;

use base qw(QBit::Application::Model::DBManager);

__PACKAGE__->model_accessors(
    db      => 'TestApplication::TestModel::TestDB',
    model_1 => 'TestApplication::TestModel::Model1',
);

__PACKAGE__->model_fields(
    m2_field1 => {db => 'table2', pk      => TRUE, default => TRUE,},
    m2_field2 => {db => 'table2', default => TRUE,},
    m2_field3 => {db => 'table3',},
    m2_field4 => {
        depends_on => [qw(m2_field2 m2_field3)],
        get        => sub {
            return $_[1]->{'m2_field2'} . ' - ' . $_[1]->{'m2_field3'};
          }
    },
    m2_field5 => {
        depends_on => [qw(m2_field1)],
        get        => sub {
            return $_[0]->{'__M1__'}{$_[1]->{'m2_field1'}} // [];
          }
    },
    idential  => {db => 'table2',},
    m2_field6 => {
        db      => 'table2',
        db_expr => {CONCAT => ['t2_field3', 'idential']}
    }
);

__PACKAGE__->model_filter(db_accessor => 'db', fields => {m2_field1 => {type => 'number'}},);

sub pre_process_fields {
    my ($self, $fields, $result) = @_;

    if ($fields->need('m2_field5')) {
        $fields->{'__M1__'} = {};

        foreach my $m1 (
            @{
                $self->model_1->get_all(
                    fields => [qw(m1_field1 m1_field3)],
                    filter => {m1_field1 => array_uniq(map {$_->{'m2_field1'}} @$result)}
                )
            }
          )
        {
            push(@{$fields->{'__M1__'}{$m1->{'m1_field1'}}}, $m1->{'m1_field3'});
        }
    }
}

sub query {
    my ($self, %opts) = @_;

    my $filter = $self->db->filter($opts{'filter'});

    my $query = $self->db->query->select(
        table  => $self->db->table2,
        fields => $opts{'fields'}->get_db_fields('table2'),
        filter => $filter,
    );

    my $fields = $opts{'fields'}->get_db_fields('table3');

    if (%$fields) {
        $query->join(
            table   => $self->db->table3,
            fields  => $fields,
            join_on => ['t3_field2' => '=' => {'m2_field2' => $self->db->table2}]
        );
    }

    return $query;
}

TRUE;
