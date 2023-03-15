import Blob "mo:base-0.7.3/Blob";
import Hex "mo:encoding/Hex";
import Text "mo:base-0.7.3/Text";

import Debug "mo:base-0.7.3/Debug";

import SHA3_384 "../src/SHA/SHA3_384";

//Debug.print("Testing SHA3_384");
let shasum = SHA3_384.sum(Blob.toArray(Text.encodeUtf8("hello world\n")));
//Debug.print(Hex.encode(shasum));
assert(Hex.encode(shasum) == "28fc308d4d5c1ef9e60acedb13c3a1fcf7266560602c639000580ae3541dea5ce78a685de897e96b65a0fc15515c3780");

//Debug.print("Testing SHA3_384 sum");
let h = SHA3_384.New();
h.write(Blob.toArray(Text.encodeUtf8("hello world\n")));
assert(Hex.encode(shasum) == Hex.encode(h.sum([])));

//Debug.print("Testing SHA3_384 vectors");
for (v in [
       ("", "0c63a75b845e4f7d01107d852e4c2485c51a50aaaa94fc61995e71bbee983a2ac3713831264adb47fb6bd1e058d5f004"),
       ("a", "1815f774f320491b48569efec794d249eeb59aae46d22bf77dafe25c5edc28d7ea44f93ee1234aa88f61c91912a4ccd9"),
       ("ab", "dc30f83fefe3396fa0bd9709bcad28394386aa4e28ae881dc6617b361b16b969fb6a50a109068f13127b6deffbc82d4b"),
       ("abc", "ec01498288516fc926459f58e2c6ad8df9b473cb0fc08c2596da7cf0e49be4b298d88cea927ac7f539f1edf228376d25"),
       ("abcd", "5af1d89732d4d10cc6e92a36756f68ecfbf7ae4d14ed4523f68fc304cccfa5b0bba01c80d0d9b67f9163a5c211cfd65b"),
       ("abcde", "348494236b82edda7602c78ba67fc3838e427c63c23e2c9d9aa5ea6354218a3c2ca564679acabf3ac6bf5378047691c4"),
       ("abcdef", "d77460b0ce6109168480e279a81af32facb689ab96e22623f0122ff3a10ead263db6607f83876a843d3264dc2a863805"),
       ("abcdefg", "49fbbd02884ae664e095edce429aa5b33d85886466de599eff29e1a0367eb16ff7e749d3966c0d4ade9903bd5867d051"),
       ("abcdefgh", "f4d9fc5e9f44eb87fe968fc8e4e4691eb1dab6d821fb77550b527f71ccfb1ba043851bb054f281364c44d8541904db5a"),
       ("abcdefghi", "36e2a92c181adfd48e897f8041e31bbf3a89fbcf50911e686343aa33c165553b5da8cc2d9b2acc943687e540388d4233"),
       ("123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890", "f817aec70c33ab0a9435bb6e6cde3682093e9916c21d04e45473f989be87405ee50f43170f816b714e41395eb695dd43"),
     ].vals()) {
    let hv = Hex.encode(SHA3_384.sum(Blob.toArray(Text.encodeUtf8(v.0))));
    // Debug.print(hv);
    assert(hv == v.1);
};

//Debug.print("Testing SHA3_384 write pieces");
do {
    let h = SHA3_384.New();
    h.write(Blob.toArray(Text.encodeUtf8("hello")));
    h.write(Blob.toArray(Text.encodeUtf8(" ")));
    h.write(Blob.toArray(Text.encodeUtf8("world\n")));
    assert(Hex.encode(h.sum([])) == "28fc308d4d5c1ef9e60acedb13c3a1fcf7266560602c639000580ae3541dea5ce78a685de897e96b65a0fc15515c3780");
};
