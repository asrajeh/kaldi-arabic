no warnings;
use utf8;
LINE: while (defined($_ = readline ARGV)) {
    sub BEGIN {
        use IO::Handle;
        'STDOUT'->autoflush(1);
    }
    use utf8 ();
    tr/$&'*<>ADEFHKNSTYZ_`abdfghijklmnopqrstuvwxyz{|}~/\x{634}\x{624}\x{621}\x{630}\x{625}\x{623}\x{627}\x{636}\x{639}\x{64b}\x{62d}\x{64d}\x{64c}\x{635}\x{637}\x{649}\x{638}\x{640}\x{670}\x{64e}\x{628}\x{62f}\x{641}\x{63a}\x{647}\x{650}\x{62c}\x{643}\x{644}\x{645}\x{646}\x{652}\x{629}\x{642}\x{631}\x{633}\x{62a}\x{64f}\x{62b}\x{648}\x{62e}\x{64a}\x{632}\x{671}\x{622}\x{626}\x{651}/;
}
continue {
    die "-p destination: $!\n" unless print $_;
}
