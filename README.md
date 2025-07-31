# S.Lee
# Collection of Labs on ARM assembly (32bit)

This is a collection of labs on written in 32 bit ARM assembly, and a project on demonstrating the concept of RSA encryption.

Final product is the project of RSA encryption and below is the summary of the library file written in 32-bit ARM assembly, containing functions to perform key generations, encryption and decryption calculations

| List of function | Purpose                                                                                                                                     | Input                                                                                                                         | Output                                             |
|------------------|---------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------|
|  cprivexp        | To calculate the private key or in other word a function to find the modular inverse d of integer a s.t. da = 1 (mod b)                     | r0: phi n ( integer b) <br>r1: e (integer a)                                                                                  | r0: the value private key d                        |
| cpubexp          | To calculate and return the public key n = p*q and the phi n = (p-1)*(q-1)                                                                  | r0: P r1: Q                                                                                                                   | r0: p*q <br>r1: (p-1)*(q-1)                        |
| decryptChar      | To decrypt a cipher character c using private key d and product p*q = n                                                                     | r0: c (cipher value to be decrypted) <br>r1: d (private key d) <br>r2: n (user chosen public key n)                           | r0: the decrypted value                            |
| encryptChar      | To encrypt a character c using public key e and product p*q = n                                                                             | r0: m (ascii value of character to be encrypted) <br>r1: e (user chosen public key e) <br>r2: n (user chosen public key n p*q)| r0: cipher text/encrypted value                    |
| euclidmodfast    | To perform the actual calculation of: a^b mod(c) Using exponential squaring, bit shifts and multiplicative properties of modulus arithmetic | r0: integer a <br>r1: integer b <br>r2: integer c                                                                             | r0: the solution                                   |
| gcd              | To find the GCD of two positive integers                                                                                                    | r0: integer1 <br>r1: integer2                                                                                                 | r0: GCD of r0 and r1                               |
| legitE           | To prompt user for a public key exponent e                                                                                                  | r0: phi n / totient                                                                                                           | r0: value of a valid e or -1 to quit               |
| legitK           | To prompt user for two valid prime number as keys                                                                                           | None                                                                                                                          | r0: P r1: Q or r0: -1 to quit                      |
| mod              | To find the remainder of a division                                                                                                         | r0: dividend <br>r1: divisor                                                                                                  | r0: divisor <br> r1: remainder                     |
| pow              | To calculate positive power of an integer                                                                                                   | r0: integer <br>r1: power index                                                                                               | r0: r0^r1                                          |
| primeness        | To check if an integer is prime or not                                                                                                      | r0: integer                                                                                                                   | r0: 1 if input is prime or 0 if input is not prime |

## How to run:

1. Modify / code your own program in arm assembly and call the functions when needed.
2. Use any 32bit OS ARM based machine and gcc/make to link and produce your own program with the library file

