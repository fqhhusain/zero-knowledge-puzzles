const chai = require('chai');
const path = require("path");
const fs = require("fs");
const { execSync } = require("child_process");
const {groth16} = require("snarkjs");
const {expect} = require("chai");


function unstringifyBigInts(o) {
    if ((typeof (o) == "string") && (/^[0-9]+$/.test(o))) {
        return BigInt(o);
    } else if ((typeof (o) == "string") && (/^0x[0-9a-fA-F]+$/.test(o))) {
        return BigInt(o);
    } else if (Array.isArray(o)) {
        return o.map(unstringifyBigInts);
    } else if (typeof o == "object") {
        if (o === null) return null;
        const res = {};
        const keys = Object.keys(o);
        keys.forEach((k) => {
            res[k] = unstringifyBigInts(o[k]);
        });
        return res;
    } else {
        return o;
    }
}

describe("Should verify correctly  ", function (){
    this.timeout(300000);

    const compileDir = path.join(__dirname, "../Compile");
    const wasmPath = path.join(compileDir, "Mul_js/Mul.wasm");
    const zkeyPath = path.join(compileDir, "Mul_0001.zkey");
    const vkPath = path.join(compileDir, "verification_key.json");

    before(async () => {
        if (fs.existsSync(wasmPath) && fs.existsSync(zkeyPath) && fs.existsSync(vkPath)) {
            return;
        }

        // Generate proving artifacts only when they do not exist.
        execSync("circom Mul.circom --r1cs --wasm --sym -o .", { cwd: compileDir, stdio: "inherit" });
        execSync("snarkjs powersoftau new bn128 12 pot12_0000.ptau -v", { cwd: compileDir, stdio: "inherit" });
        execSync("snarkjs powersoftau contribute pot12_0000.ptau pot12_0001.ptau --name='First contribution' -e='zk-puzzles' -v", { cwd: compileDir, stdio: "inherit" });
        execSync("snarkjs powersoftau prepare phase2 pot12_0001.ptau pot12_final.ptau -v", { cwd: compileDir, stdio: "inherit" });
        execSync("snarkjs groth16 setup Mul.r1cs pot12_final.ptau Mul_0000.zkey", { cwd: compileDir, stdio: "inherit" });
        execSync("snarkjs zkey contribute Mul_0000.zkey Mul_0001.zkey --name='1st Contributor Name' -e='zk-puzzles' -v", { cwd: compileDir, stdio: "inherit" });
        execSync("snarkjs zkey export verificationkey Mul_0001.zkey verification_key.json", { cwd: compileDir, stdio: "inherit" });
    });

    it("Should compile the circuit and generate the proofs and verify them ", async()=> {
        const { proof, publicSignals } = await groth16.fullProve(
            { "a": "23", "b": "2" }, 
            wasmPath,
            zkeyPath);
           
        const vKey = unstringifyBigInts(JSON.parse(fs.readFileSync(vkPath, "utf8")));
        const check = await groth16.verify(vKey, publicSignals, proof);
        expect(check).to.be.true;
    })
})

