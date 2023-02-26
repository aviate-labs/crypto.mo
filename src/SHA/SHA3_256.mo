import SHA3 "SHA3";

import Hash "../Hash";

module SHA3_256 {

    /// Returns the SHA256 checksum of the data.
    public func sum(bs : [Nat8]) : [Nat8] {
        let h = SHA3.SHA3([], 256);
        h.write(bs);
        h.checkSum();
    };

    public func New() : Hash.Hash { SHA3.SHA3([], 256); };
};
