package GoIDN;
use Moose;
use IPC::Open2;
use IO::Handle;

has 'program' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

has 'pid' => (
    is        => 'ro',
    isa       => 'Int',
    writer    => '_set_pid',
    clearer   => 'clear_pid',
);

has 'reader' => (
    is        => 'ro',
    isa       => 'IO::Handle',
    writer    => '_set_reader',
    clearer   => 'clear_reader',
);

has 'writer' => (
    is        => 'ro',
    isa       => 'IO::Handle',
    writer    => '_set_writer',
    clearer   => 'clear_writer',
);

sub BUILD {
    my ($self) = @_;
    my ($reader, $writer);

    my $pid = open2($reader, $writer, $self->program)
        or die "Unable to open process: $!";

    $self->_set_pid($pid);

    my $io_reader = IO::Handle->new_from_fd(fileno($reader), 'r');
    $io_reader->autoflush(1);

    my $io_writer = IO::Handle->new_from_fd(fileno($writer), 'w');
    $io_writer->autoflush(1);

    unless(defined $io_reader) {
        die "Unable to create IO::Handle for reader: $!";
    }
    unless(defined $io_writer) {
        die "Unable to create IO::Handle for writer: $!";
    }

    $self->_set_reader(  $io_reader);
    $self->_set_writer( $io_writer);
    
}

sub to_ascii {
    my ($self, $input) = @_;
    my $writer = $self->writer;
    my $reader = $self->reader;

    $writer->say("$input\n");
    my $output = $reader->getline();
    chomp($output);
    return $output;
}

sub DEMOLISH {
    my ($self) = @_;
    close($self->writer) if $self->writer;
    close($self->reader) if $self->reader;
    waitpid($self->pid, 0) if $self->pid;
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;
