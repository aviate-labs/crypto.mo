import Array "mo:base-0.7.3/Array";
import Iter "mo:base-0.7.3/Iter";
import Nat8 "mo:base-0.7.3/Nat8";
import Nat32 "mo:base-0.7.3/Nat32";

module Utilities {
    public func copy<T>(
        n   : Nat, // Position to start writing.
        dst : [var T], 
        src : [T]
    ) : Nat {
        let l = dst.size();
        if (l < n) return 0;
        for (i in src.keys()) {
            if (l <= n + i) return i;
            dst[n + i] := src[i];
        };
        src.size();
    };

    public func copy_offset<T>(
        n   : Nat, // Position to start writing.
        o   : Nat, //offset
        dst : [var T], 
        src : [T]
    ) : Nat {
        let l = dst.size();
        if (l < n) return 0;
        label search for (i in Iter.range(0, src.size() - o - 1)) {
            if (l <= n + i) return (i);
            dst[n + i] := src[i + o];
        };
        src.size() - o;
    };

    public func removeN<T>(
        n  : Nat, // Number to remove.
        xs : [T]
    ) : [T] {
        Array.tabulate<T>(
            xs.size() - n,
            func (i : Nat) : T {
                xs[i + n];
            }
        );
    };

    public func takeN<T>(
        n  : Nat, // Number to take.
        xs : [T]
    ) : [T] {
        Array.tabulate<T>(
            n,
            func (i : Nat) : T {
                xs[i];
            }
        );
    };

    public func select<T>(
        start : Nat,
        end   : Nat, // excl.
        xs    : [T]
    ) : [T] {
        Array.tabulate<T>(
            end - start : Nat,
            func (i : Nat) : T {
                xs[start + i]
            }
        );
    };

    public func nat32to8(n : Nat32) : Nat8 {
        Nat8.fromIntWrap(Nat32.toNat(n));
    };

    public func nat8to32(n : Nat8) : Nat32 {
        Nat32.fromIntWrap(Nat8.toNat(n));
    };
};
