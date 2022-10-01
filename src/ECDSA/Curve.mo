import Prim "mo:⛔";
import Field "Field";

// SOURCES:
// - https://hyperelliptic.org/EFD/g1p/auto-shortw-jacobian-3.html

module {
    public type Point = (Nat, Nat);

    public type AffinePoint = (Nat, Nat);

    public type JacobianPoint = (Nat, Nat, Nat);

    public type Interface = {
        // Returns the parameters for the curve.
        params    : () -> Params;
        // Returns whether the given (x, y) lies on the curve.
        onCurve   : (p : Point) -> Bool;
        // Returns the sum of (x1, y1) and (x2, y2).
        add       : (p1 : AffinePoint, p2 : AffinePoint) -> AffinePoint;
        // Returns 2 * (x, y).
        double    : (p : Point) -> Point;
        // Returns k * (x, y) where k is a number in big-endian form.
        sMult     : (p : Point, k : [Nat8]) -> Point;
        // Returns k * G, where G is the base point of the group and k is an integer in big-endian form.
        sBaseMult : (k : [Nat8]) -> Point;
    };

    public type Params = {
        p : Field.Field; // Order of the underlying field.
        n : Field.Field; // Order of the base point.
        a : Nat;
        b : Nat;
        g : Point; // (x,y) of the base point.
        bitSize : Nat;
    };

    // x³ + ax + b (Weierstrass-form elliptic)
    private func polynomial({ p; a; b } : Params, x : Nat) : Nat {
        p.add(p.mult(p.add(p.dbl(x) , a), x), b);
    };

    public func onCurve(params : Params, (x, y) : Point) : Bool {
        params.p.dbl(y) == polynomial(params, x);
    };

    private func toJacobian((x, y) : AffinePoint) : JacobianPoint = switch (x, y) {
        case (0, 0) (0, 0, 0); // ∞, not on curve...
        case (_)    (x, y, 1);
    };

    private func toAffine({ p } : Params, (x, y, z) : JacobianPoint) : AffinePoint = switch (z) {
        case (0) (0, 0);
        case (_) {
            let zi = p.inv_(z);
            let zi_2 = p.dbl(zi);
            (p.mult(x, zi_2), p.mult(y, p.mult(zi_2, zi)));
        };
    };

    public func add(params : Params, x : AffinePoint, y : AffinePoint) : AffinePoint {
        toAffine(params, addJ(params, toJacobian(x), toJacobian(y)));
    };

    // Bernstein–Lange: add-2007-bl
    private func addJ({ p } : Params, (x1, y1, z1) : JacobianPoint, (x2, y2, z2) : JacobianPoint) : JacobianPoint {
        if (z1 == 0) return (x2, y2, z2);
        if (z2 == 0) return (x1, y1, z1);

        let z1z1 = p.dbl(z1);                     // Z1Z1 = Z1²
        let z2z2 = p.dbl(z2);                     // Z2Z2 = Z2²
        let u1 = p.mult(x1, z2z2);                // U1 = X1 * Z2Z2
        let u2 = p.mult(x2, z1z1);                // U2 = X2 * Z1Z1
        let s1 = p.mult(y1, p.mult(z2, z2z2));    // S1 = Y1 * Z2 * Z2Z2
        let s2 = p.mult(y2, p.mult(z1, z1z1));    // S2 = Y2 * Z1 * Z1Z1
        let h = p.sub(u2, u1);                    // H = U2 - U1
        let i = p.dbl(Prim.shiftLeft(h, 1));      // I = (H << 1)²
        let j = p.mult(h, i);                     // J = H * I
        let r = Prim.shiftLeft(p.sub(s2, s1), 1); // R = (S2 - S1) << 1
        let v = p.mult(u1, i);                    // V = U1 * I

        // X3 = R² - J - (V << 1)
        let x3 = p.sub(p.dbl(r), p.sub(j, Prim.shiftLeft(v, 1)));
        // Y3 = R * (V - X3) - ((S1 * J) << 1)
        let y3 = p.mult(r, p.sub(p.sub(v, x3), Prim.shiftLeft(p.mult(s1, j), 1)));
        // Z3 = ((Z1 + Z2)² - Z1Z1 - Z2Z2) * H
        let z3 = p.mult(p.sub(p.dbl(p.add(z1, z2)), p.sub(z1z1, z2z2)), h);

        (x3, y3, z3);
    };

    public func double(params: Params, x : AffinePoint) : AffinePoint {
        toAffine(params, dblJ(params, toJacobian(x)));
    };

    // Bernstein: dbl-2001-b
    private func dblJ({ p } : Params, (x1, y1, z1) : JacobianPoint) : JacobianPoint {
        let z1z1 = p.dbl(z1);                              // Z1Z1 = Z1²
        let y1y1 = p.dbl(y1);                              // Y1Y1 = Y1²
        let b = p.mult(x1, y1y1);                          // B = X1 * Y1Y1
        let a_ = p.mult(p.sub(x1, z1z1), p.add(x1, z1z1)); // A = (X1 - Z1Z1) * (X1 + Z1Z1)
        let a = p.add(a_, Prim.shiftLeft(a_, 2));          // A3 = A_ + A_ << 1
        let b4 = Prim.shiftLeft(b, 2);                     // B4 = B << 2

        // X3 = A3² - (B4 << 1)
        let x3 = p.sub(p.dbl(a), Prim.shiftLeft(b4, 1));
        // Y3 = A3 * (B4 - X3) - (Y1Y1² << 3)
        let y3 = p.sub(p.mult(a, p.sub(b4, x3)), Prim.shiftLeft(p.dbl(y1y1), 3));
        // Z3 = (Y1 + Z1)² - Y1Y1 - Z1Z1
        let z3 = p.sub(p.dbl(p.add(y1, z1)), p.sub(y1y1, z1z1));

        (x3, y3, z3);
    }
};
