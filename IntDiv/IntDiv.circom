pragma circom 2.1.8;
include "../node_modules/circomlib/circuits/comparators.circom";

// Create a circuit that is satisfied if `numerator`,
// `denominator`, `quotient`, and `remainder` represent
// a valid integer division. You will need a comparison check, so
// we've already imported the library and set n to be 252 bits.
//
// Hint: integer division in Circom is `\`.
// `/` is modular division
// `%` is integer modulus

include "../node_modules/circomlib/circuits/comparators.circom";


template IntDiv(n) {
    signal input numerator;
    signal input denominator;
    signal input quotient;
    signal input remainder;
    component zero = IsZero();
    zero.in <== denominator;
    zero.out === 0;
    component kurang = LessThan(252);
    kurang.in[0] <== remainder;
    kurang.in[1] <== denominator;
    kurang.out === 1;
    numerator === denominator * quotient + remainder;
}

component main = IntDiv(252);
