import Keccak "Keccak";

import Hash "../Hash";

module SHA3_256 {

    public func New() : Hash.Hash { Keccak.Keccak([], 256, 0x06); };

    /// Returns the SHA3-256 checksum of the data.
    public func sum(bs : [Nat8]) : [Nat8] {
        let h = New();
        h.write(bs);
        h.checkSum();
    };

};
