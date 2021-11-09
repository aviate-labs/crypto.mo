module Hash {
    public type Hash = {
        // Returns the block size of the hash.
        blockSize() : Nat;
        // Returns the checksum data.
        checkSum() : [Nat8];
        // Resets the hash to its initial state.
        reset() : ();
        // Returns the number of bytes that sum will return.
        size() : Nat;
        // Adds the current hash to the resulting slice.
        // The underlying hash is not modified.
        sum(bs : [Nat8]) : [Nat8];
        // Adds data to the running hash.
        write(bs : [Nat8]) : ();
    };
};
