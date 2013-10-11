package Class::Inline;

use warnings;
use strict;
use Class::Inline::Object;

our $VERSION = 0.001;

sub import {
    my ($class, %args) = @_;
    my $caller = scalar caller;
    $^H{feature_say}    =
    $^H{feature_state}  = 1;
    warnings->import();
    strict->import();
    
    my @methods = qw(object class consume role lambda);
    {
        no strict 'refs';
        for (@methods) {
            *{"${caller}::$_"} = *{"${class}::$_"};
        }
    }
}

sub class(&;$) {
    my ($ref, $base) = @_;
    return Class::Inline::Object->create($base, $ref->($base));
}

sub role(&;$) {
    my ($ref) = @_;
    return Class::Inline::Object->create('Object', undef, { role => 1 });
}

sub consume(&;$) {
    my ($ref, $role) = @_;
    if (ref $role) {
        if ($role->{_meta} and not $role->{_meta}->{role}) {
            die ref($role) . " is not a valid role\n";
        }
        else {
            my $nc = Class::Inline::Object->create("Object", undef, { consume => ref($role) });
            Class::Inline::Object::_consume_role(ref($nc), ref($role));
            return $nc;
        }
    }
    else {
        die "Can only consume a Class::Inline role\n";
    }
}

sub object { return "Object" }

sub lambda(&$) {
    my ($block, $ref) = @_;

    if (ref $ref eq 'ARRAY') {
        for (@$ref) {
            $block->($_);
        }
    }
    elsif (ref $ref eq 'HASH') {
        for my $key (keys %$ref) {
            $block->($key, $ref->{$key});
        }
    }
    else {
        warn "lambda passed a non-valid reference";
    }
}

1;
__END__

=head1 NAME

Class::Inline - Create inline classes in a single line

=head1 DESCRIPTION

I'm not entirely sure why you'd need this module, or if it belongs in the Acme namespace, but I find it 
fun. Class::Inline allows you to create a class, or instance into a variable by calling C<class>. Yep, that's it. 
Well, it has a tiny meta protocol behind it that allows you to create methods on the fly, extend your object and even 
return a list of its superclasses.

=head1 SYNTAX

    use Class::Inline; # imports warnings/strict, state, say

    # simple class
    my $foo = class {} object;

    # make it more useful by adding a method
    $foo->_meta->method('greet', sub { say "Hello $_[1]!" });

    # we can now call it
    $foo->greet("World");

You can extend normal classes, or even other Class::Inline instances

    my $bar = class {} $foo;
    $bar->greet("Universe");

=head1 METHODS

=head2 class

Returns a Class::Inline::Object class with a unique identifier. Requires a coderef followed 
by a base class. At the least you should use "Object", or the exported function C<object>.

    my $foo = class {} object;
    
Which is really, just

    my $foo = class {} "Object";

=head2 object

Returns a string called "Object". Yeah, that's it. Mainly for convenience and to make the syntax look prettier.

=head2 lambda

Class::Inline exports a method called lambda you can use to iterate over hash or array references in an anonymous subroutine. Check it out!

    my @a = qw(foo bar world);
    lambda {
        say $_[0]
    } \@a; 
    
    my $h = { "foo" => "bar", "hello" => "world" };
    
    lambda {
        my ($key, $value) = @_;
        say $key . ' => ' . $value;
    } $h;
 
=cut
