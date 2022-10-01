# Crypto Package for Motoko

## Packages

| Package Name | Description | Spec | Path |
|--------------|-------------|------|------|
| SHA  | SHA224 and SHA256 hash algorithms             | FIPS 180-4 | `crypto/SHA/..` |
| AES  | Advanced Encryption Standard (AES)            | FIPS 197   | `crypto/AES`    |
| HMAC | Keyed-Hash Message Authentication Code (HMAC) | FIPS 198-1 | `crypto/HMAC`   |

## Usage

### SHA

```motoko
SHA256.sum(Blob.toArray(Text.encodeUtf8("hello world\n"));
// "a948904f2f0f479b8f8197694b30184b0d2ed1c1cd2a1ec0fb85d299a192a447"

let h = SHA256.New();
h.write(Blob.toArray(Text.encodeUtf8("hello world\n")));
h.sum([]);
// "a948904f2f0f479b8f8197694b30184b0d2ed1c1cd2a1ec0fb85d299a192a447"
```

### HMAC

```motoko
let h = HMAC.New(SHA256.New, []);
h.write(Blob.toArray(Text.encodeUtf8("hello world\n")));
h.sum([]);
// "d4452dbfe1fe25bf6c2fa79172dae3d7e2950de69f76e6c23188c49bfba4372f"
```
