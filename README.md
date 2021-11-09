# Crypto Package for Motoko

## Packages

| Package Name | Description | Path |
|--------------|-------------|------|
| SHA | SHA224 and SHA256 hash algorithms as defined in FIPS 180-4 | crypto/SHA |

## Usage

```motoko
SHA256.sum(Blob.toArray(Text.encodeUtf8("hello world\n"))
// "A948904F2F0F479B8F8197694B30184B0D2ED1C1CD2A1EC0FB85D299A192A447"

let h = SHA256.New();
h.write(Blob.toArray(Text.encodeUtf8("hello world\n")));
h.sum([]);
// "A948904F2F0F479B8F8197694B30184B0D2ED1C1CD2A1EC0FB85D299A192A447"
```
