pragma circom 2.1.4;

// In this exercise , we will learn how to check the range of a private variable and prove that 
// it is within the range . 

// For example we can prove that a certain person's income is within the range
// Declare 3 input signals `a`, `lowerbound` and `upperbound`.
// If 'a' is within the range, output 1 , else output 0 using 'out'

include "../node_modules/circomlib/circuits/bitify.circom";



template Range() {
    // your code here
   signal input a;
   signal input lowerbound;
   signal input upperbound;
   signal output out;

   component less = LessEqThan(10);
   less.in[0] <== a;
   less.in[1] <== upperbound;
   component big = GreaterEqThan(10);
   big.in[0] <== a;
   big.in[1] <== lowerbound;
   out <== big.out * less.out;

}

component main  = Range();


