package TestApplication::TestModel::Model1;

use qbit;

use base qw(QBit::Application::Model::DBManager);

__PACKAGE__->model_accessors(
    db      => 'TestApplication::TestModel::TestDB',
    model_2 => 'TestApplication::TestModel::Model2',
);

__PACKAGE__->model_fields(
    m1_field1 => {db => TRUE, pk      => TRUE, default => TRUE,},
    m1_field2 => {db => TRUE, default => TRUE,},
    m1_field3 => {db => TRUE,},
    m1_field4 => {
        depends_on => [qw(m1_field2 m1_field3)],
        get        => sub {
            return $_[1]->{'m1_field2'} . ' - ' . $_[1]->{'m1_field3'};
          }
    },
    m1_field5 => {
        depends_on => [qw(m1_field1)],
        get        => sub {
            return $_[0]->{'__M2__'}{$_[1]->{'m1_field1'}} // {};
          }
    },
    idential => {db => TRUE,},
);

__PACKAGE__->model_filter(
    db_accessor => 'db',
    fields      => {m1_field1 => {type => 'number'},},
);

sub pre_process_fields {
    my ($self, $fields, $result) = @_;

    if ($fields->need('m1_field5')) {
        $fields->{'__M2__'} = {
            map {$_->{'m2_field1'} => $_} @{
                $self->model_2->get_all(
                    fields => [qw(m2_field1 m2_field3)],
                    filter => {m2_field1 => array_uniq(map {$_->{'m1_field1'}} @$result)}
                )
              }
        };
    }
}

sub query {
    my ($self, %opts) = @_;

    my $filter = $self->db->filter($opts{'filter'});

    return $self->db->query->select(
        table  => $self->db->table1,
        fields => $opts{'fields'}->get_db_fields(),
        filter => $filter,
    );
}

TRUE;
