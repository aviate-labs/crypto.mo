import Blob "mo:base-0.7.3/Blob";
import Hex "mo:encoding/Hex";
import Text "mo:base-0.7.3/Text";

import SHA224 "../src/SHA/SHA224";

let sum224 = SHA224.sum(Blob.toArray(Text.encodeUtf8("hello world\n")));
assert(Hex.encode(sum224) == "95041dd60ab08c0bf5636d50be85fe9790300f39eb84602858a9b430");

for (v in [
    ("", "d14a028c2a3a2bc9476102bb288234c415a2b01f828ea62ac5b3e42f"),
    ("a", "abd37534c7d9a2efb9465de931cd7055ffdb8879563ae98078d6d6d5"),
    ("ab", "db3cda86d4429a1d39c148989566b38f7bda0156296bd364ba2f878b"),
    ("abc", "23097d223405d8228642a477bda255b32aadbce4bda0b3f7e36c9da7"),
    ("abcd", "a76654d8e3550e9a2d67a0eeb6c67b220e5885eddd3fde135806e601"),
    ("abcde", "bdd03d560993e675516ba5a50638b6531ac2ac3d5847c61916cfced6"),
    ("abcdef", "7043631cb415556a275a4ebecb802c74ee9f6153908e1792a90b6a98"),
    ("abcdefg", "d1884e711701ad81abe0c77a3b0ea12e19ba9af64077286c72fc602d"),
    ("abcdefgh", "17eb7d40f0356f8598e89eafad5f6c759b1f822975d9c9b737c8a517"),
    ("abcdefghi", "aeb35915346c584db820d2de7af3929ffafef9222a9bcb26516c7334"),
    ("abcdefghij", "d35e1e5af29ddb0d7e154357df4ad9842afee527c689ee547f753188"),
].vals()) {
    assert(Hex.encode(SHA224.sum(Blob.toArray(Text.encodeUtf8(v.0)))) == v.1);
};
