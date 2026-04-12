pragma circom 2.1.4;

// Create a circuit which takes an input 'a',(array of length 2 ) , then  implement power modulo 
// and return it using output 'c'.

// HINT: Non Quadratic constraints are not allowed. 
include "../node_modules/circomlib/circuits/bitify.circom";

template Pow() {
   signal input a[2];
   signal output c;
   component tobit = Num2Bits(10);
   tobit.in <== a[1];

   signal acc[11];
   signal sqr[10];
   signal factor[10];

   acc[0] <== 1;
   sqr[0] <== a[0];

   for (var i = 0; i < 10; i++) {
      factor[i] <== 1 + tobit.out[i] * (sqr[i] - 1);
      acc[i + 1] <== acc[i] * factor[i];

      if (i < 9) {
         sqr[i + 1] <== sqr[i] * sqr[i];
      }
   }

   c <== acc[10];
}

component main = Pow();

