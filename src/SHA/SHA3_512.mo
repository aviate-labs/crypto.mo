import SHA3 "SHA3";

import Hash "../Hash";

module SHA3_512 {

    /// Returns the SHA512 checksum of the data.
    public func sum(bs : [Nat8]) : [Nat8] {
        let h = SHA3.SHA3([], 512);
        h.write(bs);
        h.checkSum();
    };

    public func New() : Hash.Hash { SHA3.SHA3([], 512); };
};
