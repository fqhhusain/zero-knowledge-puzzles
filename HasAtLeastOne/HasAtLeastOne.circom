pragma circom 2.1.8;

// Create a circuit that takes an array of signals `in[n]` and
// a signal k. The circuit should return 1 if `k` is in the list
// and 0 otherwise. This circuit should work for an arbitrary
// length of `in`.

include "../node_modules/circomlib/circuits/comparators.circom";
include "../node_modules/circomlib/circuits/gates.circom";



template HasAtLeastOne(n) {
    signal input in[n];
    signal input k;
    signal output out;
    signal inter[3];
    component eq[4]; 
    component orGates[3];
    for (var i = 0; i < 4; i++ ){

        eq[i] = IsEqual();
        eq[i].in[0] <== in[i];
        eq[i].in[1] <== k;
    }
    orGates[0] = OR();
    orGates[1] = OR();
    orGates[2] = OR();
    orGates[0].a <== eq[0].out;
    orGates[0].b <== eq[1].out;
    orGates[1].a <== eq[2].out;
    orGates[1].b <== eq[3].out;
    orGates[2].a <== orGates[0].out;
    orGates[2].b <== orGates[1].out;
    out <==  orGates[2].out;
    

}

component main = HasAtLeastOne(4);
