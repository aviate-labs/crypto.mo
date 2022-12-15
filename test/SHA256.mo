import Blob "mo:base-0.7.3/Blob";
import Hex "mo:encoding/Hex";
import Text "mo:base-0.7.3/Text";

import SHA256 "../src/SHA/SHA256";

let sum256 = SHA256.sum(Blob.toArray(Text.encodeUtf8("hello world\n")));
assert(Hex.encode(sum256) == "a948904f2f0f479b8f8197694b30184b0d2ed1c1cd2a1ec0fb85d299a192a447");

let h = SHA256.New();
h.write(Blob.toArray(Text.encodeUtf8("hello world\n")));
assert(Hex.encode(sum256) == Hex.encode(h.sum([])));

for (v in [
    ("", "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"),
    ("a", "ca978112ca1bbdcafac231b39a23dc4da786eff8147c4e72b9807785afee48bb"),
    ("ab", "fb8e20fc2e4c3f248c60c39bd652f3c1347298bb977b8b4d5903b85055620603"),
    ("abc", "ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad"),
    ("abcd", "88d4266fd4e6338d13b845fcf289579d209c897823b9217da3e161936f031589"),
    ("abcde", "36bbe50ed96841d10443bcb670d6554f0a34b761be67ec9c4a8ad2c0c44ca42c"),
    ("abcdef", "bef57ec7f53a6d40beb640a780a639c83bc29ac8a9816f1fc6c5c6dcd93c4721"),
    ("abcdefg", "7d1a54127b222502f5b79b5fb0803061152a44f92b37e23c6527baf665d4da9a"),
    ("abcdefgh", "9c56cc51b374c3ba189210d5b6d4bf57790d351c96c47c02190ecf1e430635ab"),
    ("abcdefghi", "19cc02f26df43cc571bc9ed7b0c4d29224a3ec229529221725ef76d021c8326f"),
    ("abcdefghij", "72399361da6a7754fec986dca5b7cbaf1c810a28ded4abaf56b2106d06cb78b0"),
].vals()) {
    assert(Hex.encode(SHA256.sum(Blob.toArray(Text.encodeUtf8(v.0)))) == v.1);
};

do {
    let h = SHA256.New();
    h.write(Blob.toArray(Text.encodeUtf8("hello")));
    h.write(Blob.toArray(Text.encodeUtf8(" ")));
    h.write(Blob.toArray(Text.encodeUtf8("world")));
    assert(Hex.encode(h.sum([])) == "b94d27b9934d3e08a52e52d7da7dabfac484efe37a5380ee9088f7ace2efcde9");
};
