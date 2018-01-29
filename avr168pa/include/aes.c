#include "aes.h"

flash unsigned char sbox[256] = 
 {
    0x63, 0x7C, 0x77, 0x7B, 0xF2, 0x6B, 0x6F, 0xC5, 0x30, 0x01, 0x67, 0x2B, 0xFE, 0xD7, 0xAB, 0x76,
    0xCA, 0x82, 0xC9, 0x7D, 0xFA, 0x59, 0x47, 0xF0, 0xAD, 0xD4, 0xA2, 0xAF, 0x9C, 0xA4, 0x72, 0xC0,
    0xB7, 0xFD, 0x93, 0x26, 0x36, 0x3F, 0xF7, 0xCC, 0x34, 0xA5, 0xE5, 0xF1, 0x71, 0xD8, 0x31, 0x15,
    0x04, 0xC7, 0x23, 0xC3, 0x18, 0x96, 0x05, 0x9A, 0x07, 0x12, 0x80, 0xE2, 0xEB, 0x27, 0xB2, 0x75,
    0x09, 0x83, 0x2C, 0x1A, 0x1B, 0x6E, 0x5A, 0xA0, 0x52, 0x3B, 0xD6, 0xB3, 0x29, 0xE3, 0x2F, 0x84,
    0x53, 0xD1, 0x00, 0xED, 0x20, 0xFC, 0xB1, 0x5B, 0x6A, 0xCB, 0xBE, 0x39, 0x4A, 0x4C, 0x58, 0xCF,
    0xD0, 0xEF, 0xAA, 0xFB, 0x43, 0x4D, 0x33, 0x85, 0x45, 0xF9, 0x02, 0x7F, 0x50, 0x3C, 0x9F, 0xA8,
    0x51, 0xA3, 0x40, 0x8F, 0x92, 0x9D, 0x38, 0xF5, 0xBC, 0xB6, 0xDA, 0x21, 0x10, 0xFF, 0xF3, 0xD2,
    0xCD, 0x0C, 0x13, 0xEC, 0x5F, 0x97, 0x44, 0x17, 0xC4, 0xA7, 0x7E, 0x3D, 0x64, 0x5D, 0x19, 0x73,
    0x60, 0x81, 0x4F, 0xDC, 0x22, 0x2A, 0x90, 0x88, 0x46, 0xEE, 0xB8, 0x14, 0xDE, 0x5E, 0x0B, 0xDB,
    0xE0, 0x32, 0x3A, 0x0A, 0x49, 0x06, 0x24, 0x5C, 0xC2, 0xD3, 0xAC, 0x62, 0x91, 0x95, 0xE4, 0x79,
    0xE7, 0xC8, 0x37, 0x6D, 0x8D, 0xD5, 0x4E, 0xA9, 0x6C, 0x56, 0xF4, 0xEA, 0x65, 0x7A, 0xAE, 0x08,
    0xBA, 0x78, 0x25, 0x2E, 0x1C, 0xA6, 0xB4, 0xC6, 0xE8, 0xDD, 0x74, 0x1F, 0x4B, 0xBD, 0x8B, 0x8A,
    0x70, 0x3E, 0xB5, 0x66, 0x48, 0x03, 0xF6, 0x0E, 0x61, 0x35, 0x57, 0xB9, 0x86, 0xC1, 0x1D, 0x9E,
    0xE1, 0xF8, 0x98, 0x11, 0x69, 0xD9, 0x8E, 0x94, 0x9B, 0x1E, 0x87, 0xE9, 0xCE, 0x55, 0x28, 0xDF,
    0x8C, 0xA1, 0x89, 0x0D, 0xBF, 0xE6, 0x42, 0x68, 0x41, 0x99, 0x2D, 0x0F, 0xB0, 0x54, 0xBB, 0x16
 };
 
//flash unsigned char inv_sbox[256] = 
// {
//    0x52, 0x09, 0x6A, 0xD5, 0x30, 0x36, 0xA5, 0x38, 0xBF, 0x40, 0xA3, 0x9E, 0x81, 0xF3, 0xD7, 0xFB,
//    0x7C, 0xE3, 0x39, 0x82, 0x9B, 0x2F, 0xFF, 0x87, 0x34, 0x8E, 0x43, 0x44, 0xC4, 0xDE, 0xE9, 0xCB,
//    0x54, 0x7B, 0x94, 0x32, 0xA6, 0xC2, 0x23, 0x3D, 0xEE, 0x4C, 0x95, 0x0B, 0x42, 0xFA, 0xC3, 0x4E,
//    0x08, 0x2E, 0xA1, 0x66, 0x28, 0xD9, 0x24, 0xB2, 0x76, 0x5B, 0xA2, 0x49, 0x6D, 0x8B, 0xD1, 0x25,
//    0x72, 0xF8, 0xF6, 0x64, 0x86, 0x68, 0x98, 0x16, 0xD4, 0xA4, 0x5C, 0xCC, 0x5D, 0x65, 0xB6, 0x92,
//    0x6C, 0x70, 0x48, 0x50, 0xFD, 0xED, 0xB9, 0xDA, 0x5E, 0x15, 0x46, 0x57, 0xA7, 0x8D, 0x9D, 0x84,
//    0x90, 0xD8, 0xAB, 0x00, 0x8C, 0xBC, 0xD3, 0x0A, 0xF7, 0xE4, 0x58, 0x05, 0xB8, 0xB3, 0x45, 0x06,
//    0xD0, 0x2C, 0x1E, 0x8F, 0xCA, 0x3F, 0x0F, 0x02, 0xC1, 0xAF, 0xBD, 0x03, 0x01, 0x13, 0x8A, 0x6B,
//    0x3A, 0x91, 0x11, 0x41, 0x4F, 0x67, 0xDC, 0xEA, 0x97, 0xF2, 0xCF, 0xCE, 0xF0, 0xB4, 0xE6, 0x73,
//    0x96, 0xAC, 0x74, 0x22, 0xE7, 0xAD, 0x35, 0x85, 0xE2, 0xF9, 0x37, 0xE8, 0x1C, 0x75, 0xDF, 0x6E,
//    0x47, 0xF1, 0x1A, 0x71, 0x1D, 0x29, 0xC5, 0x89, 0x6F, 0xB7, 0x62, 0x0E, 0xAA, 0x18, 0xBE, 0x1B,
//    0xFC, 0x56, 0x3E, 0x4B, 0xC6, 0xD2, 0x79, 0x20, 0x9A, 0xDB, 0xC0, 0xFE, 0x78, 0xCD, 0x5A, 0xF4,
//    0x1F, 0xDD, 0xA8, 0x33, 0x88, 0x07, 0xC7, 0x31, 0xB1, 0x12, 0x10, 0x59, 0x27, 0x80, 0xEC, 0x5F,
//    0x60, 0x51, 0x7F, 0xA9, 0x19, 0xB5, 0x4A, 0x0D, 0x2D, 0xE5, 0x7A, 0x9F, 0x93, 0xC9, 0x9C, 0xEF,
//    0xA0, 0xE0, 0x3B, 0x4D, 0xAE, 0x2A, 0xF5, 0xB0, 0xC8, 0xEB, 0xBB, 0x3C, 0x83, 0x53, 0x99, 0x61,
//    0x17, 0x2B, 0x04, 0x7E, 0xBA, 0x77, 0xD6, 0x26, 0xE1, 0x69, 0x14, 0x63, 0x55, 0x21, 0x0C, 0x7D
// };
unsigned char rcon[10] = { 0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80, 0x1b, 0x36};
 
void Encrypt(unsigned char *in,unsigned char *key,unsigned char *out);
//void Decrypt(unsigned char *in,unsigned char *key,unsigned char *out);

// OverView Function Encrypt
void Expankey(unsigned char *key,unsigned char *expkey);
void SubBytes(unsigned char *state);
void AddRoundKey(unsigned char *state,unsigned char *expkey,unsigned char n);
void MixColumns(unsigned char *state);
void ShiftRows(unsigned char *state);


//    OverView Function Decrypt
//void InvShiftRows(unsigned char *state);
//void InvSubBytes(unsigned char *state);
//void InvMixColumns(unsigned char *state);

// function for all
// function multilply 2 number
//unsigned char gmul(unsigned char a, unsigned char b) {
//    unsigned char p = 0; /* the product of the multiplication */
//    while (a && b) {
//            if (b & 1) /* if b is odd, then add the corresponding a to p (final product = sum of all a's corresponding to odd b's) */
//                p ^= a; /* since we're in GF(2^m), addition is an XOR */
//
//            if (a & 0x80) /* GF modulo: if a >= 128, then it will overflow when shifted left, so reduce */
//                a = (a << 1) ^ 0x11b; /* XOR with the primitive polynomial x^8 + x^4 + x^3 + x + 1 (0b1_0001_1011) � you can change it but it must be irreducible */
//            else
//                a <<= 1; /* equivalent to a*2 */
//            b >>= 1; /* equivalent to b // 2 */
//    }
//    return p;
//}

void Expankey(unsigned char *key,unsigned char *expkey)
{
    unsigned char j,i;
    for (j=0;j<16;j++)
    {
        expkey[j] = key[j];
    }
    
    for (i=1;i<11;i++)
    {
        for(j=0;j<16;j++)
        {
            if (j>=0&&j<4) {
                if (j==3) {
                    expkey[i*16+j] = sbox[expkey[i*16+j-7]];
                } else {
                    expkey[i*16+j] = sbox[expkey[i*16+j-3]];
                }
                if (j==0) expkey[i*16+j] ^= expkey[i*16+j-16] ^ rcon[i-1];
                else    expkey[i*16+j] ^= expkey[i*16+j-16];
            } else {
                expkey[i*16+j] = expkey[i*16+j-4] ^ expkey[i*16+j-16];
            }
        }
    }
}

void AddRoundKey(unsigned char *state,unsigned char *expkey,unsigned char n)
{
    unsigned char i;
    for (i=0;i<16;i++){
        state[i] ^= expkey[n-16+i];
    }
}

// Begin function Encrypt
void Encrypt(unsigned char *in,unsigned char *key,unsigned char *out)
{
    unsigned char expkey[176],i;
    unsigned char state[16];
    
    for (i=0;i<16;i++)
        state[i] = in[i];
    
    Expankey(key,expkey);
    AddRoundKey(state,expkey,16);
    for (i=2;i<11;i++)
    {
        SubBytes(state);
        ShiftRows(state);
        MixColumns(state);
        AddRoundKey(state,expkey,i*16);
    }
    SubBytes(state);
    ShiftRows(state);
    AddRoundKey(state,expkey,i*16);
    
    for (i=0;i<16;i++)
        out[i] = state[i];
}

void SubBytes(unsigned char *state)
{
    unsigned char i;
    for (i=0;i<16;i++)
        state[i] = sbox[state[i]];
}

void MixColumns(unsigned char *state)
{
    unsigned char a[16];
    unsigned char b[16];
    unsigned char c;
    unsigned char h;
    /* The array 'a' is simply a copy of the input array 'r'
     * The array 'b' is each element of the array 'a' multiplied by 2
     * in Rijndael's Galois field
     * a[n] ^ b[n] is element n multiplied by 3 in Rijndael's Galois field */ 
    for (c = 0; c < 16; c++) {
        a[c] = state[c];
        /* h is 0xff if the high bit of r[c] is set, 0 otherwise */
        h = (unsigned char)((signed char)state[c] >> 7); /* arithmetic right shift, thus shifting in either zeros or ones */
        b[c] = state[c] << 1; /* implicitly removes high bit because b[c] is an 8-bit char, so we xor by 0x1b and not 0x11b in the next line */
        b[c] ^= 0x1B & h; /* Rijndael's Galois field */
    }
    
    state[0] = b[0] ^ a[3] ^ a[2] ^ b[1] ^ a[1]; /* 2 * a0 + a3 + a2 + 3 * a1 */
    state[1] = b[1] ^ a[0] ^ a[3] ^ b[2] ^ a[2]; /* 2 * a1 + a0 + a3 + 3 * a2 */
    state[2] = b[2] ^ a[1] ^ a[0] ^ b[3] ^ a[3]; /* 2 * a2 + a1 + a0 + 3 * a3 */
    state[3] = b[3] ^ a[2] ^ a[1] ^ b[0] ^ a[0]; /* 2 * a3 + a2 + a1 + 3 * a0 */
    
    state[4] = b[4] ^ a[7] ^ a[6] ^ b[5] ^ a[5]; 
    state[5] = b[5] ^ a[4] ^ a[7] ^ b[6] ^ a[6]; 
    state[6] = b[6] ^ a[5] ^ a[4] ^ b[7] ^ a[7]; 
    state[7] = b[7] ^ a[6] ^ a[5] ^ b[4] ^ a[4];
    
    state[8] = b[8] ^ a[11] ^ a[10] ^ b[9] ^ a[9]; 
    state[9] = b[9] ^ a[8] ^ a[11] ^ b[10] ^ a[10]; 
    state[10] = b[10] ^ a[9] ^ a[8] ^ b[11] ^ a[11]; 
    state[11] = b[11] ^ a[10] ^ a[9] ^ b[8] ^ a[8];
    
    state[12] = b[12] ^ a[15] ^ a[14] ^ b[13] ^ a[13]; 
    state[13] = b[13] ^ a[12] ^ a[15] ^ b[14] ^ a[14]; 
    state[14] = b[14] ^ a[13] ^ a[12] ^ b[15] ^ a[15]; 
    state[15] = b[15] ^ a[14] ^ a[13] ^ b[12] ^ a[12];
    
}

void ShiftRows(unsigned char *state)
{
    unsigned char tmp[16],i;
    
    for (i=0;i<16;i++)
        tmp[i]=state[i];
        
    state[0]=tmp[0];
    state[1]=tmp[5];
    state[2]=tmp[10];
    state[3]=tmp[15];
    
    state[4]=tmp[4];
    state[5]=tmp[9];
    state[6]=tmp[14];
    state[7]=tmp[3];
    
    state[8]=tmp[8];
    state[9]=tmp[13];
    state[10]=tmp[2];
    state[11]=tmp[7];
    
    state[12]=tmp[12];
    state[13]=tmp[1];
    state[14]=tmp[6];
    state[15]=tmp[11];
}
// End function Encrypt

//Begin function Decrypt
//void Decrypt(unsigned char *in,unsigned char *key,unsigned char *out)
//{
//    unsigned char expkey[176],i,state[16];
//    
//    for(i=0;i<16;i++)
//        state[i]=in[i];
//    
//    Expankey(key,expkey);
//    AddRoundKey(state,expkey,176);
//    InvShiftRows(state);
//    InvSubBytes(state);
//    for (i=10;i>1;i--)
//    {
//        AddRoundKey(state,expkey,i*16);
//        InvMixColumns(state);
//        InvShiftRows(state);
//        InvSubBytes(state);
//    }
//    AddRoundKey(state,key,16);
//    for (i=0;i<16;i++)
//        out[i] = state[i];
//        
//}
//
//void InvShiftRows(unsigned char *state)
//{
//    unsigned char tmp[16],i;
//    for (i=0;i<16;i++)
//        tmp[i] = state[i];
//        
//    state[0] = tmp[0];
//    state[1] = tmp[13];
//    state[2] = tmp[10];
//    state[3] = tmp[7];
//    
//    state[4] = tmp[4];
//    state[5] = tmp[1];
//    state[6] = tmp[14];
//    state[7] = tmp[11];
//    
//    state[8] = tmp[8];
//    state[9] = tmp[5];
//    state[10] = tmp[2];
//    state[11] = tmp[15];
//    
//    state[12] = tmp[12];
//    state[13] = tmp[9];
//    state[14] = tmp[6];
//    state[15] = tmp[3];
//}
//
//void InvSubBytes(unsigned char *state)
//{
//    unsigned char i;
//    for (i=0;i<16;i++)
//        state[i] = inv_sbox[state[i]];
//}
//
//
//void InvMixColumns(unsigned char *state)
//{
//    unsigned char tmp[16],i;
//    for (i=0;i<16;i++)
//        tmp[i] = state[i];
//        
//    state[0] = gmul(0x09,tmp[3]) ^ gmul(0x0b,tmp[1]) ^ gmul(0x0d,tmp[2]) ^ gmul(0x0e,tmp[0]);
//    state[1] = gmul(0x09,tmp[0]) ^ gmul(0x0b,tmp[2]) ^ gmul(0x0d,tmp[3]) ^ gmul(0x0e,tmp[1]);
//    state[2] = gmul(0x09,tmp[1]) ^ gmul(0x0b,tmp[3]) ^ gmul(0x0d,tmp[0]) ^ gmul(0x0e,tmp[2]);
//    state[3] = gmul(0x09,tmp[2]) ^ gmul(0x0b,tmp[0]) ^ gmul(0x0d,tmp[1]) ^ gmul(0x0e,tmp[3]);
//    
//    state[4] = gmul(0x09,tmp[7]) ^ gmul(0x0b,tmp[5]) ^ gmul(0x0d,tmp[6]) ^ gmul(0x0e,tmp[4]);
//    state[5] = gmul(0x09,tmp[4]) ^ gmul(0x0b,tmp[6]) ^ gmul(0x0d,tmp[7]) ^ gmul(0x0e,tmp[5]);
//    state[6] = gmul(0x09,tmp[5]) ^ gmul(0x0b,tmp[7]) ^ gmul(0x0d,tmp[4]) ^ gmul(0x0e,tmp[6]);
//    state[7] = gmul(0x09,tmp[6]) ^ gmul(0x0b,tmp[4]) ^ gmul(0x0d,tmp[5]) ^ gmul(0x0e,tmp[7]);
//    
//    state[8] = gmul(0x09,tmp[11]) ^ gmul(0x0b,tmp[9]) ^ gmul(0x0d,tmp[10]) ^ gmul(0x0e,tmp[8]);
//    state[9] = gmul(0x09,tmp[8]) ^ gmul(0x0b,tmp[10]) ^ gmul(0x0d,tmp[11]) ^ gmul(0x0e,tmp[9]);
//    state[10] = gmul(0x09,tmp[9]) ^ gmul(0x0b,tmp[11]) ^ gmul(0x0d,tmp[8]) ^ gmul(0x0e,tmp[10]);
//    state[11] = gmul(0x09,tmp[10]) ^ gmul(0x0b,tmp[8]) ^ gmul(0x0d,tmp[9]) ^ gmul(0x0e,tmp[11]);
//    
//    state[12] = gmul(0x09,tmp[15]) ^ gmul(0x0b,tmp[13]) ^ gmul(0x0d,tmp[14]) ^ gmul(0x0e,tmp[12]);
//    state[13] = gmul(0x09,tmp[12]) ^ gmul(0x0b,tmp[14]) ^ gmul(0x0d,tmp[15]) ^ gmul(0x0e,tmp[13]);
//    state[14] = gmul(0x09,tmp[13]) ^ gmul(0x0b,tmp[15]) ^ gmul(0x0d,tmp[12]) ^ gmul(0x0e,tmp[14]);
//    state[15] = gmul(0x09,tmp[14]) ^ gmul(0x0b,tmp[12]) ^ gmul(0x0d,tmp[13]) ^ gmul(0x0e,tmp[15]);
//    
//}
// End function Decrypt
