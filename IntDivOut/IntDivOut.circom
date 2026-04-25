pragma circom 2.1.8;
include "../node_modules/circomlib/circuits/comparators.circom";

// Use the same constraints from IntDiv, but this
// time assign the quotient in `out`. You still need
// to apply the same constraints as IntDiv

template IntDivOut(n) {
    signal input numerator;
    signal input denominator;
    signal output out;
    signal remainder;
    component zero = IsZero();
    zero.in <== denominator;
    zero.out === 0;
    signal quotient <-- numerator  \  denominator;
    remainder <-- numerator % denominator;
    numerator === quotient * denominator + remainder; 
    out <== quotient;
}

component main = IntDivOut(252);
