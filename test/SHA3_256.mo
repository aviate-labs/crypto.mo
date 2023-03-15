import Blob "mo:base-0.7.3/Blob";
import Hex "mo:encoding/Hex";
import Text "mo:base-0.7.3/Text";

import Debug "mo:base-0.7.3/Debug";

import SHA3_256 "../src/SHA/SHA3_256";

//Debug.print("Testing SHA3_256");
let shasum = SHA3_256.sum(Blob.toArray(Text.encodeUtf8("hello world\n")));
//Debug.print(Hex.encode(shasum));
assert(Hex.encode(shasum) == "a8009a7a528d87778c356da3a55d964719e818666a04e4f960c9e2439e35f138");

//Debug.print("Testing SHA3_256 sum");
let h = SHA3_256.New();
h.write(Blob.toArray(Text.encodeUtf8("hello world\n")));
assert(Hex.encode(shasum) == Hex.encode(h.sum([])));

//Debug.print("Testing SHA3_256 vectors");
for (v in [
       ("", "a7ffc6f8bf1ed76651c14756a061d662f580ff4de43b49fa82d80a4b80f8434a"),
       ("a", "80084bf2fba02475726feb2cab2d8215eab14bc6bdd8bfb2c8151257032ecd8b"),
       ("ab", "5c828b33397f4762922e39a60c35699d2550466a52dd15ed44da37eb0bdc61e6"),
       ("abc", "3a985da74fe225b2045c172d6bd390bd855f086e3e9d525b46bfe24511431532"),
       ("abcd", "6f6f129471590d2c91804c812b5750cd44cbdfb7238541c451e1ea2bc0193177"),
       ("abcde", "d716ec61e18904a8f58679b71cb065d4d5db72e0e0c3f155a4feff7add0e58eb"),
       ("abcdef", "59890c1d183aa279505750422e6384ccb1499c793872d6f31bb3bcaa4bc9f5a5"),
       ("abcdefg", "7d55114476dfc6a2fbeaa10e221a8d0f32fc8f2efb69a6e878f4633366917a62"),
       ("abcdefgh", "3e2020725a38a48eb3bbf75767f03a22c6b3f41f459c831309b06433ec649779"),
       ("abcdefghi", "f74eb337992307c22bc59eb43e59583a683f3b93077e7f2472508e8c464d2657"),
       ("123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890", "4298644d87cdeed3d444d8514c7830ad12f4bc196d90652a6aa03c885494ae55"),
     ].vals()) {
    let hv = Hex.encode(SHA3_256.sum(Blob.toArray(Text.encodeUtf8(v.0))));
    // Debug.print(hv);
    assert(hv == v.1);
};

//Debug.print("Testing SHA3_256 write pieces");
do {
    let h = SHA3_256.New();
    h.write(Blob.toArray(Text.encodeUtf8("hello")));
    h.write(Blob.toArray(Text.encodeUtf8(" ")));
    h.write(Blob.toArray(Text.encodeUtf8("world\n")));
    assert(Hex.encode(h.sum([])) == "a8009a7a528d87778c356da3a55d964719e818666a04e4f960c9e2439e35f138");
};
