import Field "../src/ECDSA/Field";

let Z7 = Field.Field(7);

assert(Z7.fromInt(-10) == 4);
assert(Z7.add(2, 5) == 0);
assert(Z7.sub(4, 10) == 1);
assert(Z7.inv(5) == ?3);

let Z497 = Field.Field(497);
assert(Z497.exp(4, 13) == 445);
