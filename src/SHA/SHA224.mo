import SHA2 "SHA2";

import Hash "../Hash";

module SHA224 {
    // Initial hash value, H(0).
    private let H224 : [Nat32] = [
        0xc1059ed8, 0x367cd507, 0x3070dd17, 0xf70e5939, 0xffc00b31, 0x68581511,
        0x64f98fa7, 0xbefa4fa4,
    ];

    /// Returns the SHA224 checkum of the data.
    public func sum(bs : [Nat8]) : [Nat8] {
        let h = SHA2.SHA2(H224, 28);
        h.write(bs);
        h.checkSum()
    };

    public func New() : Hash.Hash { SHA2.SHA2(H224, 28); };
};
