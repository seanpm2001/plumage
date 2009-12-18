#! parrot-nqp

MAIN();

sub MAIN () {
    # Load testing tools
    pir::load_language('parrot');
    pir::compreg__PS('parrot').import('Test::More');

    # Load library to be tested
    pir::load_bytecode('src/lib/Glue.pbc');

    # Run all tests for this library
    run_tests();
}

sub run_tests () {
    plan(4);

    test_subst();
}

sub test_subst() {
    my $string := 'chewbacca';
    my $subst  := subst($string, rx('a'), 'x');
    is($subst,  'chewbxccx', 'subst works with plain string replacement');
    is($string, 'chewbacca', 'plain string subst edits a clone');

    my $text  := 'wookie';
    my $fixed := subst($text, rx('w|k'), replacement);
    is($fixed, 'wwookkie', 'subst works with code replacement');
    is($text,  'wookie',   'code replacement subst edits a clone');
}

sub replacement($match) {
    my $orig := ~$match;

    return $orig ~ $orig;
}
