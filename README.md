
==============================================
  Scicoin release TOY #2, February 1st, 2014
==============================================
See http://www.scicoin.org for up-to-date info
==============================================

This source distribution is a clone of the Freicoin repository made around January 23rd, 2014, with some hacks on top to create a TOY, that is, COMPLETELY EXPERIMENTAL version of a new "crypto coin" called "Scicoin."

See FREICOIN_README for the README from the Freicoin project before this source fork. It has instructions on how to build, etc. The only difference is in the names: where you read "freicoin" write "scicoin" and it should work.

Scicoin differences to Freicoin in a nutshell:
1 - Unlimited coins (no hard cap on coins);
2 - Block reward is directly proportional (1:1) to the work done, i.e. the reward (block subsidy) is a linear function of the block difficulty (plus fees);
3 - A scheme to reward scientific computing projects (that may or may not work; essentially we award x100 / x1000 / x10000 more coins to a single miner that manages to control more than 50% / 66.6% / 80% of the hashing power. see the website for rationale/details);
4 - No "initial distribution" phase of coins to hard-coded wallets;

The scicoin hack was partly automated by the Perl script "makeanycoin.perl" which is also included here.

The source code probably needs a lot of cleanup, for which volunteers are much appreciated. This project currently has 1 (one) developer which is focusing on having this client correctly implement the protocol... what can be done regardless of whether the source tree is tidy or whether the client displays a version number that makes sense or whether the documentation still says "Freicoin" or "Bitcoin" in it.

There is a single hard-coded seed-node address in the code that should be up and running.

===========
LEGAL STUFF
===========

Most of the code is from the Bitcoin project. See COPYING for the legal stuff.

Some code is from the Freicoin project. See http://freico.in.

Some code is from the Scicoin project. That code is public domain.

The "recycle" project/icon image that's being used as a placeholder is from the Open Icon Library (http://openiconlibrary.sourceforge.net).


