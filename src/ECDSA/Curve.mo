module {
    public type Point = (Nat, Nat);

    public type Interface = {
        // Returns the parameters for the curve.
        params    : () -> Params;
        // Returns whether the given (x, y) lies on the curve.
        onCurve   : (p : Point) -> Bool;
        // Returns the sum of (x1, y1) and (x2, y2).
        add       : (p1 : Point, p2 : Point) -> Point;
        // Returns 2 * (x, y).
        double    : (p : Point) -> Point;
        // Returns k * (x, y) where k is a number in big-endian form.
        sMult     : (p : Point, k : [Nat8]) -> Point;
        // Returns k * G, where G is the base point of the group and k is an integer in big-endian form.
        sBaseMult : (k : [Nat8]) -> Point;
    };

    public type Params = {
        p : Nat; // Order of the underlying field.
        n : Nat; // Order of the base point.
        a : Nat;
        b : Nat;
        g : Point; // (x,y) of the base point.
        bitSize : Nat;
    };

    let P256k1 : Params = { 
        p = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFC2F;
        n = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141;
        a = 0; b = 7;
        g = (
            0x79BE667EF9DCBBAC55A06295CE870B07029BFCDB2DCE28D959F2815B16F81798,
            0x483ADA7726A3C4655DA4FBFC0E1108A8FD17B448A68554199C47D08FFB10D4B8
        );
        bitSize = 256;
    };
};
