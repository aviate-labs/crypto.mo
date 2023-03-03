import Blob "mo:base-0.7.3/Blob";
import Hex "mo:encoding/Hex";
import Text "mo:base-0.7.3/Text";

import Debug "mo:base-0.7.3/Debug";

import SHA3_224 "../src/SHA/SHA3_224";

//Debug.print("Testing SHA3_224");
let shasum = SHA3_224.sum(Blob.toArray(Text.encodeUtf8("hello world\n")));
//Debug.print(Hex.encode(shasum));
assert(Hex.encode(shasum) == "7eda3e8d26f147821a258850956f9ed640fb0b3a8a04ae56a2f58a32");

//Debug.print("Testing SHA3_224 sum");
let h = SHA3_224.New();
h.write(Blob.toArray(Text.encodeUtf8("hello world\n")));
assert(Hex.encode(shasum) == Hex.encode(h.sum([])));

//Debug.print("Testing SHA3_224 vectors");
for (v in [
       ("", "6b4e03423667dbb73b6e15454f0eb1abd4597f9a1b078e3f5b5a6bc7"),
       ("a", "9e86ff69557ca95f405f081269685b38e3a819b309ee942f482b6a8b"),
       ("ab", "09d27a15bcbab5da828d84dbd66062e5d37049f9b165a65dc581e853"),
       ("abc", "e642824c3f8cf24ad09234ee7d3c766fc9a3a5168d0c94ad73b46fdf"),
       ("abcd", "dd886b5fd8421fb3871d24e39e53967ce4fc80dd348bedbea0109c0e"),
       ("abcde", "6acfaab70afd8439cea3616b41088bd81c939b272548f6409cf30e57"),
       ("abcdef", "ceb3f4cd85af081120bf69ecf76bf61232bd5d810866f0eca3c8907d"),
       ("abcdefg", "8a00ff4ec6b96377f1e69b2f72ed3c8da4bfe2f2f8357dc2aac13433"),
       ("abcdefgh", "48bf2e8640cffe77b67c6182a6a47f8b5af73f60bd204ef348371d03"),
       ("abcdefghi", "e7b4cd92a5ab3abc2c08841d0f6aa49f88f9f39be40b5a104dd0f114"),
       ("123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890", "4223016829bb302b45e0825d085bbcb579d0638462543f341dcb0ef7"),
     ].vals()) {
    let hv = Hex.encode(SHA3_224.sum(Blob.toArray(Text.encodeUtf8(v.0))));
    // Debug.print(hv);
    assert(hv == v.1);
};

//Debug.print("Testing SHA3_224 write pieces");
do {
    let h = SHA3_224.New();
    h.write(Blob.toArray(Text.encodeUtf8("hello")));
    h.write(Blob.toArray(Text.encodeUtf8(" ")));
    h.write(Blob.toArray(Text.encodeUtf8("world\n")));
    assert(Hex.encode(h.sum([])) == "7eda3e8d26f147821a258850956f9ed640fb0b3a8a04ae56a2f58a32");
};
