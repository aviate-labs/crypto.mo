import Keccak "Keccak";

import Hash "../Hash";

module SHA3_512 {

    public func New() : Hash.Hash { Keccak.Keccak([], 512, 0x06); };

    /// Returns the SHA3-512 checksum of the data.
    public func sum(bs : [Nat8]) : [Nat8] {
        let h = New();
        h.write(bs);
        h.checkSum();
    };

};
