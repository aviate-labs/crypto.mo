import Array "mo:base-0.7.3/Array";
import Nat "mo:base-0.7.3/Nat";
import Nat8 "mo:base-0.7.3/Nat8";
import Nat64 "mo:base-0.7.3/Nat64";
import Int "mo:base-0.7.3/Int";
import Iter "mo:base-0.7.3/Iter";

import Hash "../Hash";

import Hex "mo:encoding/Hex";
import Debug "mo:base-0.7.3/Debug";

module {

    // Keccak constants
    private let keccakf_rndc : [Nat64] = [
        0x0000000000000001, 0x0000000000008082, 0x800000000000808a,
        0x8000000080008000, 0x000000000000808b, 0x0000000080000001,
        0x8000000080008081, 0x8000000000008009, 0x000000000000008a,
        0x0000000000000088, 0x0000000080008009, 0x000000008000000a,
        0x000000008000808b, 0x800000000000008b, 0x8000000000008089,
        0x8000000000008003, 0x8000000000008002, 0x8000000000000080,
        0x000000000000800a, 0x800000008000000a, 0x8000000080008081,
        0x8000000000008080, 0x0000000080000001, 0x8000000080008008
    ];

    // Keccak constants
    private let keccakf_rotc : [Nat64] = [
        1,  3,  6,  10, 15, 21, 28, 36, 45, 55, 2,  14,
        27, 41, 56, 8,  25, 43, 62, 18, 39, 61, 20, 44
    ];

    // Keccak constants
    private let keccakf_piln : [Nat] = [
        10, 7,  11, 17, 18, 3, 5,  16, 8,  21, 24, 4,
        15, 23, 19, 13, 12, 2, 20, 14, 22, 9,  6,  1
    ];

    public class SHA3(
      initialState : [Nat64], // unused for now
      hashSize     : Nat,
    ) : Hash.Hash = {
        // Keccak l-parameter selects "bus size". For SHA3, l = 6 and
        // this is the only value supported at this time.
        private let keccakf_l : Nat = 6;

        // Number of rounds
        private let n_rounds: Nat = 12 + 2*keccakf_l;

        // Bus sizes in bits
        private let bsize: Nat = 25 * 2**keccakf_l;

        // Capactiy in bits
        private let cap: Nat = hashSize * 2;

        // Block size in bytes
        // No operator warning for Nat arithmetic?
        assert(bsize > cap+8);
        private let rsize: Nat = (bsize - cap)/8;

        // Internal state
        private let state: [var Nat64] = Array.init<Nat64>(bsize/64, 0);

        // Current write state index
        private var pt: Nat = 0;

        // blockSize in bytes
        public func blockSize() : Nat { rsize; };

        // Function to initialize
        public func reset() : () {
            for (i in Iter.range(0, state.size()-1)) {
                state[i] := 0;
            };
            pt := 0;
        };

        // Return size of hash in bits
        public func size() : Nat { hashSize; };

        // Turn array of Nat8s into Nat64, LSB first
        private func pack64(data : [Nat8]) : Nat64 {
            let dsize = data.size();
            assert(dsize <= 8 and dsize > 0);

            var q: Nat64 = 0;
            // Avoid reverse() here to optimize? Maybe unroll?
            for (i in Iter.range(0, dsize-1:Nat)) {
                q |= Nat64.fromNat(Nat8.toNat(data[dsize-1:Nat-i]));
                if (i < (dsize-1:Nat)) {
                    q <<= 8;
                };
            };
            return q;
        };

        // Unpack Nat64 into array of Nat8s, LSB first
        private func unpack64(q : Nat64) : [Nat8] {
            var t = q;
            let qbuf = Array.init<Nat8>(8, 0);
            for (i in Iter.range(0, qbuf.size()-1)) {
                qbuf[i] := Nat8.fromNat(Nat64.toNat(t & 0xff));
                t >>= 8;
            };
            return Array.freeze<Nat8>(qbuf);
        };

        private func dump() {
            Debug.print("State");
            for (i in Iter.range(0, state.size()-1)) {
                let b = Array.reverse<Nat8>(unpack64(state[i]));
                Debug.print(Hex.encode(b));
            };
        };

        // Repeated from SHA2. Candidate for DRY principle refactor?
        public func sum(bs : [Nat8]) : [Nat8] {
            let cs = checkSum();
            let size = bs.size();
            Array.tabulate<Nat8>(
                size + cs.size(),
                func (x : Nat) {
                    if (x < size) return bs[x];
                    cs[x - size];
                }
            );
        };

        // Function to finalize hashing
        public func checkSum() : [Nat8] {
            state[pt/8] ^= 0x06 : Nat64 << Nat64.fromNat((pt%8)*8);
            state[(rsize-1:Nat)/8] ^= 0x80 : Nat64 << Nat64.fromNat(((rsize-1):Nat%8)*8);

            //dump();
            keccak_f(state);

            let md = Array.init<Nat8>(hashSize/8, 0);

            for (i in Iter.range(0, hashSize/64-1)) {
                let qbuf = unpack64(state[i]);
                for (j in Iter.range(0, 7)) {
                    md[i*8+j] := qbuf[j];
                };
            };
            return Array.freeze<Nat8>(md);
        };

        // Function to update internal state with content
        // TODO: should data be a blob? Sticking with Array from Hash type
        public func write(data : [Nat8]) : () {
            if (data.size() == 0) {
                return;
            };

            // Creating qbuf to apply against the entire Nat64 to
            // avoid repacking because we don't have unions in
            // Motoko. First time might require leading zeros, so it's
            // initialized to zero
            let qbuf = Array.init<Nat8>(8, 0);
            let dlast = data.size()-1:Nat;

            for (i in Iter.range(0, dlast)) {
                qbuf[pt % 8] := data[i];

                // Set zeros at the end of our quad-word before submitting
                if (i >= dlast and (pt+1) % 8 != 0) {
                    for (j in Iter.range((pt+1) % 8, 7)) {
                        qbuf[j] := 0;
                    };
                };

                // Finished 8 bytes (64-bits) chunk to apply to state
                if (i >= dlast or (pt+1) % 8 == 0) {
                    // Debug.print(Nat.toText(pt/8));
                    // Debug.print(Hex.encode(Array.freeze<Nat8>(qbuf)));
                    // let b = Array.reverse<Nat8>(unpack64(state[pt/8]));
                    // Debug.print(Hex.encode(b));
                    state[pt/8] ^= pack64(Array.freeze<Nat8>(qbuf));
                };
                pt += 1;

                if (pt >= rsize) {
                    keccak_f(state);
                    pt := 0;
                };
            };
            //dump();

            // Sanitize buffer for sensitive information
            for (j in Iter.range(0, 7)) {
                qbuf[j] := 0;
            };
        };

        // Main Keccak hashing function. See:
        // https://nvlpubs.nist.gov/nistpubs/FIPS/NIST.FIPS.202.pdf
        func keccak_f(st : [var Nat64]) {
            var t : Nat64 = 0;
            let bc = Array.init<Nat64>(5, 0);
            var j: Nat = 0;

            for (r in Iter.range(0, n_rounds - 1)) {
                // Theta
                for (i in Iter.range(0, 4)) {
                    bc[i] := st[i] ^ st[i + 5] ^ st[i + 10] ^ st[i + 15] ^ st[i + 20];
                };
                for (i in Iter.range(0, 4)) {
                    t := bc[(i + 4) % 5] ^ Nat64.bitrotLeft(bc[(i + 1) % 5], 1);
                    for (j in Iter.range(0, 4)) {
                        st[j*5 + i] ^= t;
                    };
                };

                // Rho Pi
                t := st[1];
                for (i in Iter.range(0, keccakf_piln.size()-1)) {
                    j := keccakf_piln[i];
                    bc[0] := st[j];
                    st[j] := Nat64.bitrotLeft(t, keccakf_rotc[i]);
                    t := bc[0];
                };

                // Chi
                for (j in Iter.range(0, 4)) {
                    for (i in Iter.range(0, 4)) {
                        bc[i] := st[j*5 + i];
                    };
                    for (i in Iter.range(0, 4)) {
                        st[j*5 + i] ^= (^bc[(i + 1) % 5]) & bc[(i + 2) % 5];
                    };
                };

                // Iota
                st[0] ^= keccakf_rndc[r];
            };
        };
    };
};
