pragma circom 2.1.8;

// Create a circuit that takes an array of four signals
// `in`and a signal s and returns is satisfied if `in`
// is the binary representation of `n`. For example:
// 
// Accept:
// 0,  [0,0,0,0]
// 1,  [1,0,0,0]
// 15, [1,1,1,1]
// 
// Reject:
// 0, [3,0,0,0]
// 
// The circuit is unsatisfiable if n > 15

include "../node_modules/circomlib/circuits/comparators.circom";


template FourBitBinary() {
    signal input in[4];
    signal input n;
    signal acc[4];
    for (var i = 0; i < 4; i++ ){
        in[i] * (in[i] - 1) === 0;
    }
    acc[0] <== in[0] * 1;
    acc[1] <== in[1] * 2 + acc[0];
    acc[2] <== in[2] * 4 + acc[1];
    acc[3] <== in[3] * 8 + acc[2];

    n === acc[3];

}

component main{public [n]} = FourBitBinary();
