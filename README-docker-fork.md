Minisign
========

Minisign is a dead simple tool to sign files and verify signatures.
It is portable, lightweight, and uses the highly secure Ed25519 public-key signature system.

**Compatibility with OpenBSD signify**

For more information, please refer to the
[Minisign documentation](https://jedisct1.github.io/minisign/)

    $ docker run -it --rm maxpeal/minisign

Supported architectures of this Dockerbuild: amd64, arm32v6, arm32v7, arm64v8, i386, ppc64le, s390x
-----------------------------------------------
* Source of this Dockerbuild: (https://github.com/MaxPeal/minisign)


Minisign is also available in Homebrew:

$ brew install minisign

Minisign is also available in Scoop on Windows:

$ scoop install minisign

Minisign is also available in chocolatey on Windows:

$ choco install minisign

Minisign is also available on Ubuntu as a PPA:

$ [sudo] add-apt-repository ppa:dysfunctionalprogramming/minisign


**Compatibility with OpenBSD signify**

Signatures written by `minisign` can be verified using OpenBSD's `signify` tool: public key files and signature files are compatible.

However, `minisign` uses a slightly different format to store secret keys.

`Minisign` signatures include trusted comments in addition to untrusted comments. Trusted comments are signed, thus verified, before being displayed.

This adds two lines to the signature files, that signify silently ignores.


Additional tools, libraries and implementations
-----------------------------------------------

* [minisign-misc](https://github.com/JayBrown/minisign-misc) is a very
nice set of workflows and scripts for macOS to verify and sign files
with minisign.
* [go-minisign](https://github.com/jedisct1/go-minisign) is a small module
in Go to verify Minisign signatures.
* [rust-minisign](https://github.com/jedisct1/rust-minisign) is a Minisign
library written in pure Rust, that can be embedded in other applications.
* [rsign2](https://github.com/jedisct1/rsign2) is a reimplementation of
the command-line tool in Rust.
* [minisign-verify](https://github.com/jedisct1/rust-minisign-verify) is
a small Rust crate to verify Minisign signatures.
* [minisign-net](https://github.com/bitbeans/minisign-net) is a .NET library
to handle and create Minisign signatures.
* [minisign](https://github.com/chm-diederichs/minisign) a Javascript
implementation.
* WebAssembly implementations of [rsign2](https://wapm.io/package/jedisct1/rsign2)
and [minisign-cli](https://wapm.io/package/jedisct1/minisign) are available on
WAPM.
* [minisign-php](https://github.com/soatok/minisign-php) is a PHP implementation.


Signature determinism
---------------------

This implementation uses deterministic signatures, unless libsodium
was compiled with the `ED25519_NONDETERMINISTIC` macro defined. This
adds random noise to the computation of EdDSA nonces.

Other implementations can choose to use non-deterministic signatures
by default. They will remain fully interoperable with implementations
using deterministic signatures.
