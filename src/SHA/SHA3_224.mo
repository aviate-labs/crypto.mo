import Keccak "Keccak";

import Hash "../Hash";

module SHA3_224 {

    public func New() : Hash.Hash { Keccak.Keccak([], 224, 0x06); };

    /// Returns the SHA3-224 checksum of the data.
    public func sum(bs : [Nat8]) : [Nat8] {
        let h = New();
        h.write(bs);
        h.checkSum();
    };

};
