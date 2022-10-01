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
// "A948904F2F0F479B8F8197694B30184B0D2ED1C1CD2A1EC0FB85D299A192A447"

let h = SHA256.New();
h.write(Blob.toArray(Text.encodeUtf8("hello world\n")));
h.sum([]);
// "A948904F2F0F479B8F8197694B30184B0D2ED1C1CD2A1EC0FB85D299A192A447"
```

### HMAC

```motoko
let h = HMAC.New(SHA256.New, []);
h.write(Blob.toArray(Text.encodeUtf8("hello world\n")));
h.sum([]);
// "D4452DBFE1FE25BF6C2FA79172DAE3D7E2950DE69F76E6C23188C49BFBA4372F"
```
