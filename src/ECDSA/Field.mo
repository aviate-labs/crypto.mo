import Prim "mo:⛔";
import Int "mo:base/Int";

module {
    // Field ℤ/nℤ
    // NOTE: ℤ/nℤ is a field when nℤ is a maximal ideal (i.e., when n is prime).
    public class Field(n : Nat) {

        public let m = n;

        // Int to a ℤ/nℤ Nat.
        public func fromInt(x : Int) : Nat {
            let y = Int.abs(x);
            if (0 <= x) return y % n;
            Int.abs(x + n * (y / n + 1));
        };

        public func mod(x : Nat) : Nat = x % n;
        
        public func add(x : Nat, y : Nat) : Nat = mod(x + y);

        public func sub(x : Nat, y : Nat) : Nat {
            if (x > y) return x - y;
            x + n - y;
        };

        public func neg(x : Nat) : Int {
            let y = mod(x);
            if (y == 0) return 0;
            y - n;
        };

        // Multiplicative inverse.
        public func inv(x : Nat) : ?Nat {
            let (gcd, i, _) = gcdExt(x, n);
            if (gcd != 1) return null;
            ?fromInt(i);
        };

        // Invert with assertions.
        public func inv_(x : Nat) : Nat {
            let (gcd, i, _) = gcdExt(x, n);
            assert(gcd == 1);
            fromInt(i);
        };

        public func mult(x : Nat, y : Nat) : Nat = mod(x * y);

        public func div(x : Nat, y : Nat) : Nat = mod(x * inv_(y));

        public func dbl(x : Nat) : Nat = mult(x, x);

        // Modular exponentiation (~ binary exponentiation).
        public func exp(x : Nat, y : Nat) : Nat = switch (y) {
            case (0) 1;
            case (_) {
                var r = 1;
                var e = y;
                var b = mod(x);
                while (0 < e) {
                    if (e % 2 == 1) r := mult(r, b);
                    e := Prim.shiftRight(e, 1);
                    b := mult(b, b);
                };
                r;
            };
        };
    };

    // Extended Euclidean Algorithm
    public func gcdExt(x : Nat, y : Nat) : (Nat, Int, Int) {
        if (x == 0) return (y, 0, 1);
        let (g, a, b) = gcdExt(y % x, x);
        return (g, b - (y / x) * a, a);
    }
};
