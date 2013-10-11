use Class::Inline;
my $moo = class {} object; 
$moo->_meta->method("greet", sub {
    my ($self, $name) = @_;
    say "Hello, $name!";
});

$moo->greet("World");

my $foo = class {} $moo;
$foo->greet("Universe");

lambda {
    say $_[0]
} [ 'foo', 'bar', 'world' ];

my $h = { "foo" => "bar", "hello" => "world" };

lambda {
    say $_[0] . ' => ' . $_[1];
} $h;
