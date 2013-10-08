package Class::Inline::Object;

use warnings;
use strict;
use feature 'state';

use Class::Inline::Object::Meta;

sub create {
    my ($class, $base, $res) = @_;
    if (not $base) {
        print STDERR "Can't initialise class{} without base object\n";
        exit 1;
    }

    state $ref = 0;
    $ref += 1;
    my $resclass = "${class}::Ref${ref}";
    my $new = {
      _meta => {
          ref => $ref,
      },
    };

    if ($res and ref($res) eq 'HASH') {
        $new = { %$new, %$res };
    }

    $new = bless $new, $resclass;
    {
        no strict 'refs';
        @{"${resclass}::Meta::ISA"} = qw(Class::Inline::Object::Meta);
        if ($base ne 'Object') {
            my $baseclass = "Class::Inline::Object::Ref$base->{_meta}->{ref}";
            @{"${resclass}::ISA"} = ("Class::Inline::Object", "$baseclass");
        } else {
            @{"${resclass}::ISA"} = ("Class::Inline::Object");
        }
    }

    return $new;
}

sub _meta {
    my $class = ref $_[0];
    return bless {}, "${class}::Meta";
}

sub isobject { return 1 }
sub new { return bless $_[0], ref($_[0]) }

1;
__END__
