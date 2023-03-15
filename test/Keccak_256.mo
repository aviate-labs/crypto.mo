import Blob "mo:base-0.7.3/Blob";
import Hex "mo:encoding/Hex";
import Text "mo:base-0.7.3/Text";

import Debug "mo:base-0.7.3/Debug";

import Keccak_256 "../src/SHA/Keccak_256";

//Debug.print("Testing Keccak_256");
let shasum = Keccak_256.sum(Blob.toArray(Text.encodeUtf8("hello world\n")));
//Debug.print(Hex.encode(shasum));
assert(Hex.encode(shasum) == "70e3788906c57c18999ba6b0389a768ff3333e3d6136fdf85743e66a03bc29f9");

//Debug.print("Testing Keccak_256 sum");
let h = Keccak_256.New();
h.write(Blob.toArray(Text.encodeUtf8("hello world\n")));
assert(Hex.encode(shasum) == Hex.encode(h.sum([])));

//Debug.print("Testing Keccak_256 vectors");
for (v in [
       ("", "c5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470"),
       ("a", "3ac225168df54212a25c1c01fd35bebfea408fdac2e31ddd6f80a4bbf9a5f1cb"),
       ("ab", "67fad3bfa1e0321bd021ca805ce14876e50acac8ca8532eda8cbf924da565160"),
       ("abc", "4e03657aea45a94fc7d47ba826c8d667c0d1e6e33a64a036ec44f58fa12d6c45"),
       ("abcd", "48bed44d1bcd124a28c27f343a817e5f5243190d3c52bf347daf876de1dbbf77"),
       ("abcde", "6377c7e66081cb65e473c1b95db5195a27d04a7108b468890224bedbe1a8a6eb"),
       ("abcdef", "acd0c377fe36d5b209125185bc3ac41155ed1bf7103ef9f0c2aff4320460b6df"),
       ("abcdefg", "a82aec019867b7307551dc397acde18b541e742fa1a4e53df4ce3b02d462f524"),
       ("abcdefgh", "48624fa43c68d5c552855a4e2919e74645f683f5384f72b5b051b71ea41d4f2d"),
       ("abcdefghi", "34fb2702da7001bf4dbf26a1e4cf31044bd95b85e1017596ee2d23aedc90498b"),
       ("123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890", "9f475334b0dafde0fdbe358fbe2b65b7129e0b52e242e2e1317479f9b590f581"),
     ].vals()) {
    let hv = Hex.encode(Keccak_256.sum(Blob.toArray(Text.encodeUtf8(v.0))));
    //Debug.print(hv);
    assert(hv == v.1);
};

//Debug.print("Testing Keccak_256 write pieces");
do {
    let h = Keccak_256.New();
    h.write(Blob.toArray(Text.encodeUtf8("hello")));
    h.write(Blob.toArray(Text.encodeUtf8(" ")));
    h.write(Blob.toArray(Text.encodeUtf8("world\n")));
    assert(Hex.encode(h.sum([])) == "70e3788906c57c18999ba6b0389a768ff3333e3d6136fdf85743e66a03bc29f9");
};
