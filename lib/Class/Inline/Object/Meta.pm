package Class::Inline::Object::Meta;

use warnings;
use strict;

sub _pkg {
    my ($self) = @_;
    return substr(ref($self), 0, -6);
}

sub method {
    my ($self, $name, $code) = @_;
    my $package = $self->_pkg; 
    {
        no strict 'refs';
        *{"${package}::${name}"} = $code;
    }
}

sub extends {
    my ($self, $ob) = @_;
    my $pkg  = $self->_pkg;
    my $base = ref $ob ? ref $ob : $ob;
    eval "use $base";
    warn "Could not extend $base: $@"
        if $@;

    {
        no strict 'refs';
        @{"${pkg}::ISA"} = ("Class::Inline::Object", $base);
    }
}

sub superclasses {
    my ($self) = @_;
    my $pkg = $self->_pkg;
    {
        no strict 'refs';
        return @{"${pkg}::ISA"};
    }
}

1;
__END__
