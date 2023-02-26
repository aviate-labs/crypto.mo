import Blob "mo:base-0.7.3/Blob";
import Hex "mo:encoding/Hex";
import Text "mo:base-0.7.3/Text";

import Debug "mo:base-0.7.3/Debug";

import SHA3_512 "../src/SHA/SHA3_512";

//Debug.print("Testing SHA3_512");
let shasum = SHA3_512.sum(Blob.toArray(Text.encodeUtf8("hello world\n")));
//Debug.print(Hex.encode(shasum));
assert(Hex.encode(shasum) == "4a936cbc1db296bd08d1c0bbf5a66a1897f35ee6d93047e0edff893dfbcba02f1e1570e85d1187ea26bea6d54199e0656f1b7c21b9cc2102b8ed2a12769f4531");

//Debug.print("Testing SHA3_512 sum");
let h = SHA3_512.New();
h.write(Blob.toArray(Text.encodeUtf8("hello world\n")));
assert(Hex.encode(shasum) == Hex.encode(h.sum([])));

//Debug.print("Testing SHA3_512 vectors");
for (v in [
       ("", "a69f73cca23a9ac5c8b567dc185a756e97c982164fe25859e0d1dcc1475c80a615b2123af1f5f94c11e3e9402c3ac558f500199d95b6d3e301758586281dcd26"),
       ("a", "697f2d856172cb8309d6b8b97dac4de344b549d4dee61edfb4962d8698b7fa803f4f93ff24393586e28b5b957ac3d1d369420ce53332712f997bd336d09ab02a"),
       ("ab", "01c87b5e8f094d8725ed47be35430de40f6ab6bd7c6641a4ecf0d046c55cb468453796bb61724306a5fb3d90fbe3726a970e5630ae6a9cf9f30d2aa062a0175e"),
       ("abc", "b751850b1a57168a5693cd924b6b096e08f621827444f70d884f5d0240d2712e10e116e9192af3c91a7ec57647e3934057340b4cf408d5a56592f8274eec53f0"),
       ("abcd", "6eb7b86765bf96a8467b72401231539cbb830f6c64120954c4567272f613f1364d6a80084234fa3400d306b9f5e10c341bbdc5894d9b484a8c7deea9cbe4e265"),
       ("abcde", "1d7c3aa6ee17da5f4aeb78be968aa38476dbee54842e1ae2856f4c9a5cd04d45dc75c2902182b07c130ed582d476995b502b8777ccf69f60574471600386639b"),
       ("abcdef", "01309a45c57cd7faef9ee6bb95fed29e5e2e0312af12a95fffeee340e5e5948b4652d26ae4b75976a53cc1612141af6e24df36517a61f46a1a05f59cf667046a"),
       ("abcdefg", "9c93345c31ecffe20a95eca8db169f1b3ee312dd75fb3494cc1dc2f9a2b6092b6cbebf1299ec6d5ba46b08f728f3075109582bc71b97b4deac5122433732234c"),
       ("abcdefgh", "c9f25eee75ab4cf9a8cfd44f4992b282079b64d94647edbd88e818e44f701edeb450818f7272cba7a20205b3671ce1991ce9a6d2df8dbad6e0bb3e50493d7fa7"),
       ("abcdefghi", "4dbdf4a9fc84c246217a68d5a8f3d2a761766cf78752057d60b730a4a8226ef99bbf580c85468f5e93d8fb7873bbdb0de44314e3adf4b94a4fc37c64ca949c6e"),
       ("123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890", "42987b893dea6fc14fe56928ddbae6ccae1d3e8afc52e6b19bafe3a34ab35c84ed01cfa9fd18f6edf1c92f04f0666a99b6a067213cf2538ea05716bab570af99"),
     ].vals()) {
    let hv = Hex.encode(SHA3_512.sum(Blob.toArray(Text.encodeUtf8(v.0))));
    // Debug.print(hv);
    assert(hv == v.1);
};

//Debug.print("Testing SHA3_512 write pieces");
do {
    let h = SHA3_512.New();
    h.write(Blob.toArray(Text.encodeUtf8("hello")));
    h.write(Blob.toArray(Text.encodeUtf8(" ")));
    h.write(Blob.toArray(Text.encodeUtf8("world\n")));
    assert(Hex.encode(h.sum([])) == "4a936cbc1db296bd08d1c0bbf5a66a1897f35ee6d93047e0edff893dfbcba02f1e1570e85d1187ea26bea6d54199e0656f1b7c21b9cc2102b8ed2a12769f4531");
};

