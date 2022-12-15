import Array "mo:base-0.7.3/Array";
import Hash "Hash";
import Util "Utilities";

module HMAC {
    private class HMAC(
        h : () -> Hash.Hash
    ) : Hash.Hash {
        public var outer : Hash.Hash = h();
        public var inner : Hash.Hash = h();
        private let bSize = inner.blockSize();
        public var opad : [var Nat8] = Array.init<Nat8>(bSize, 0);
        public var ipad : [var Nat8] = Array.init<Nat8>(bSize, 0);

        public func blockSize() : Nat { bSize };

        public func reset() : () {
            inner.reset();
            inner.write(Array.freeze(ipad));
        };

        public func size() : Nat { outer.size() };

        public func sum(bs : [Nat8]) : [Nat8] {
            let l = bs.size();
            let p = inner.sum(bs);
            outer.reset();
            outer.write(Array.freeze(opad));
            outer.write(Util.removeN(l, p));
            outer.sum(Util.takeN(l, p))
        };

        public func write(bs : [Nat8]) : () {
            inner.write(bs);
        };
    };

    public func New(h : () -> Hash.Hash, bs : [Nat8]) : Hash.Hash {
        let hmac = HMAC(h);
        let bSize = hmac.blockSize();
        var p = bs;
        if (bs.size() > bSize) {
            hmac.outer.write(p);
            p := hmac.outer.sum([]);
        };

        ignore Util.copy<Nat8>(0, hmac.ipad, p);
        ignore Util.copy<Nat8>(0, hmac.opad, p);

        var i = 0;
        for (_ in hmac.ipad.vals()) {
            hmac.ipad[i] ^= 0x36;
            i += 1;
        };
        var j = 0;
        for (_ in hmac.opad.vals()) {
            hmac.opad[j] ^= 0x5c;
            j += 1;
        };
        hmac.inner.write(Array.freeze(hmac.ipad));
        hmac;
    };
};
