package [% module %];
use Moose;

=head1 NAME

[% module %] -

=head1 SYNOPSIS


=head1 DESCRIPTION


=cut

__PACKAGE__->meta->make_immutable;
no Moose;

=head1 BUGS

No known bugs.

Please report any bugs through RT: email
C<bug-[% dist FILTER lower %] at rt.cpan.org>, or browse to
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=[% dist %]>.

=head1 SEE ALSO


=head1 SUPPORT

You can find this documentation for this module with the perldoc command.

    perldoc [% module %]

You can also look for information at:

=over 4

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/[% dist %]>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/[% dist %]>

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=[% dist %]>

=item * Search CPAN

L<http://search.cpan.org/dist/[% dist %]>

=back

=head1 AUTHOR

  Jesse Luehrs <doy at tozt dot net>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Jesse Luehrs.

This is free software; you can redistribute it and/or modify it under
the same terms as perl itself.

=cut

1;
