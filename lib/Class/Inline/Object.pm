package Class::Inline::Object;

use warnings;
use strict;
use feature 'state';

use Class::Inline::Object::Meta;

sub create {
    my ($class, $base, $res, $opts) = @_;
    if (not $base) {
        print STDERR "Can't initialise class{} without base object\n";
        exit 1;
    }

    if (ref $base) {
        if ($base->{_meta} and $base->{_meta}->{role}) {
            die "Cannot extend a role\n";
        }
    }

    state $ref = 0;
    $ref += 1;
    my $resclass = "${class}::Ref${ref}";
    my $new = {
      _meta => {
          ref => $ref,
      },
    };

    if ($opts) { $new->{_meta} = { %{$new->{_meta}}, %$opts }; } 
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

        if ($opts and $opts->{role}) {
            @{"${resclass}::ISA"} = (@{"${resclass}::ISA"}, "Class::Inline::Object::Role");
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

sub _consume_role {
    my ($class, $role) = @_;
    {
        no strict 'refs';
        no warnings 'redefine';
        for my $method (keys %{"${role}::"}) {
            *{"${class}::${method}"} = *{"${role}::${method}"};
        }
    }
}

1;
__END__
