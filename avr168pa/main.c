/*******************************************************
This program was created by the
CodeWizardAVR V3.12 Advanced
Automatic Program Generator
© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : AES-128
Version : 1.0
Date    : 1/26/2018
Author  : Khang
Company : NoTime
Comments: 


Chip type               : ATmega168A
Program type            : Application
AVR Core Clock frequency: 8.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*******************************************************/

#include <mega168a.h>

// Declare your global variables here

#define DATA_REGISTER_EMPTY (1<<UDRE0)
#define RX_COMPLETE (1<<RXC0)
#define FRAMING_ERROR (1<<FE0)
#define PARITY_ERROR (1<<UPE0)
#define DATA_OVERRUN (1<<DOR0)

// USART Receiver buffer
#define RX_BUFFER_SIZE0 43
char rx_buffer0[RX_BUFFER_SIZE0];

#if RX_BUFFER_SIZE0 <= 256
unsigned char rx_wr_index0=0,rx_rd_index0=0;
#else
unsigned int rx_wr_index0=0,rx_rd_index0=0;
#endif

#if RX_BUFFER_SIZE0 < 256
unsigned char rx_counter0=0;
#else
unsigned int rx_counter0=0;
#endif
// This flag is set on USART Receiver buffer overflow
bit rx_buffer_overflow0;

// USART Receiver interrupt service routine
interrupt [USART_RXC] void usart_rx_isr(void)
{
char status,data;
status=UCSR0A;
data=UDR0;
if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
   {    
   rx_buffer0[rx_wr_index0++]=data;
#if RX_BUFFER_SIZE0 == 256
   // special case for receiver buffer size=256
   if (++rx_counter0 == 0) rx_buffer_overflow0=1;
#else
   if (rx_wr_index0 == RX_BUFFER_SIZE0) rx_wr_index0=0;
   if (++rx_counter0 == RX_BUFFER_SIZE0)
      {
      rx_counter0=0;
      rx_buffer_overflow0=1;
      }
#endif
   }
}

#ifndef _DEBUG_TERMINAL_IO_
// Get a character from the USART Receiver buffer
#define _ALTERNATE_GETCHAR_
#pragma used+
char getchar(void)
{
char data;
while (rx_counter0==0);
data=rx_buffer0[rx_rd_index0++];
#if RX_BUFFER_SIZE0 != 256
if (rx_rd_index0 == RX_BUFFER_SIZE0) rx_rd_index0=0;
#endif
#asm("cli")
--rx_counter0;
#asm("sei")                                               
return data;
}
#pragma used-
#endif

// Standard Input/Output functions
#include <stdio.h>
#include <delay.h>
#include "include/aes.h"

/*==========================================================*/
//// Begin function Encrypt
//flash unsigned char sbox[256] = 
// {
//    0x63, 0x7C, 0x77, 0x7B, 0xF2, 0x6B, 0x6F, 0xC5, 0x30, 0x01, 0x67, 0x2B, 0xFE, 0xD7, 0xAB, 0x76,
//    0xCA, 0x82, 0xC9, 0x7D, 0xFA, 0x59, 0x47, 0xF0, 0xAD, 0xD4, 0xA2, 0xAF, 0x9C, 0xA4, 0x72, 0xC0,
//    0xB7, 0xFD, 0x93, 0x26, 0x36, 0x3F, 0xF7, 0xCC, 0x34, 0xA5, 0xE5, 0xF1, 0x71, 0xD8, 0x31, 0x15,
//    0x04, 0xC7, 0x23, 0xC3, 0x18, 0x96, 0x05, 0x9A, 0x07, 0x12, 0x80, 0xE2, 0xEB, 0x27, 0xB2, 0x75,
//    0x09, 0x83, 0x2C, 0x1A, 0x1B, 0x6E, 0x5A, 0xA0, 0x52, 0x3B, 0xD6, 0xB3, 0x29, 0xE3, 0x2F, 0x84,
//    0x53, 0xD1, 0x00, 0xED, 0x20, 0xFC, 0xB1, 0x5B, 0x6A, 0xCB, 0xBE, 0x39, 0x4A, 0x4C, 0x58, 0xCF,
//    0xD0, 0xEF, 0xAA, 0xFB, 0x43, 0x4D, 0x33, 0x85, 0x45, 0xF9, 0x02, 0x7F, 0x50, 0x3C, 0x9F, 0xA8,
//    0x51, 0xA3, 0x40, 0x8F, 0x92, 0x9D, 0x38, 0xF5, 0xBC, 0xB6, 0xDA, 0x21, 0x10, 0xFF, 0xF3, 0xD2,
//    0xCD, 0x0C, 0x13, 0xEC, 0x5F, 0x97, 0x44, 0x17, 0xC4, 0xA7, 0x7E, 0x3D, 0x64, 0x5D, 0x19, 0x73,
//    0x60, 0x81, 0x4F, 0xDC, 0x22, 0x2A, 0x90, 0x88, 0x46, 0xEE, 0xB8, 0x14, 0xDE, 0x5E, 0x0B, 0xDB,
//    0xE0, 0x32, 0x3A, 0x0A, 0x49, 0x06, 0x24, 0x5C, 0xC2, 0xD3, 0xAC, 0x62, 0x91, 0x95, 0xE4, 0x79,
//    0xE7, 0xC8, 0x37, 0x6D, 0x8D, 0xD5, 0x4E, 0xA9, 0x6C, 0x56, 0xF4, 0xEA, 0x65, 0x7A, 0xAE, 0x08,
//    0xBA, 0x78, 0x25, 0x2E, 0x1C, 0xA6, 0xB4, 0xC6, 0xE8, 0xDD, 0x74, 0x1F, 0x4B, 0xBD, 0x8B, 0x8A,
//    0x70, 0x3E, 0xB5, 0x66, 0x48, 0x03, 0xF6, 0x0E, 0x61, 0x35, 0x57, 0xB9, 0x86, 0xC1, 0x1D, 0x9E,
//    0xE1, 0xF8, 0x98, 0x11, 0x69, 0xD9, 0x8E, 0x94, 0x9B, 0x1E, 0x87, 0xE9, 0xCE, 0x55, 0x28, 0xDF,
//    0x8C, 0xA1, 0x89, 0x0D, 0xBF, 0xE6, 0x42, 0x68, 0x41, 0x99, 0x2D, 0x0F, 0xB0, 0x54, 0xBB, 0x16
// };
// 
//unsigned char rcon[10] = { 0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80, 0x1b, 0x36};
//
//void Expankey(unsigned char *key,unsigned char *expkey)
//{
//    unsigned char j,i;
//    for (j=0;j<16;j++)
//    {
//        expkey[j] = key[j];
//    }
//    
//    for (i=1;i<11;i++)
//    {
//        for(j=0;j<16;j++)
//        {
//            if (j>=0&&j<4) {
//                if (j==3) {
//                    expkey[i*16+j] = sbox[expkey[i*16+j-7]];
//                } else {
//                    expkey[i*16+j] = sbox[expkey[i*16+j-3]];
//                }
//                if (j==0) expkey[i*16+j] ^= expkey[i*16+j-16] ^ rcon[i-1];
//                else    expkey[i*16+j] ^= expkey[i*16+j-16];
//            } else {
//                expkey[i*16+j] = expkey[i*16+j-4] ^ expkey[i*16+j-16];
//            }
//        }
//    }
//}
//
//void AddRoundKey(unsigned char *state,unsigned char *expkey,unsigned char n)
//{
//    unsigned char i;
//    for (i=0;i<16;i++){
//        state[i] ^= expkey[n-16+i];
//    }
//}
//
//void SubBytes(unsigned char *state)
//{
//    unsigned char i;
//    for (i=0;i<16;i++)
//        state[i] = sbox[state[i]];
//}
//
//void MixColumns(unsigned char *state)
//{
//    unsigned char a[16];
//    unsigned char b[16];
//    unsigned char c;
//    unsigned char h;
//    /* The array 'a' is simply a copy of the input array 'r'
//     * The array 'b' is each element of the array 'a' multiplied by 2
//     * in Rijndael's Galois field
//     * a[n] ^ b[n] is element n multiplied by 3 in Rijndael's Galois field */ 
//    for (c = 0; c < 16; c++) {
//        a[c] = state[c];
//        /* h is 0xff if the high bit of r[c] is set, 0 otherwise */
//        h = (unsigned char)((signed char)state[c] >> 7); /* arithmetic right shift, thus shifting in either zeros or ones */
//        b[c] = state[c] << 1; /* implicitly removes high bit because b[c] is an 8-bit char, so we xor by 0x1b and not 0x11b in the next line */
//        b[c] ^= 0x1B & h; /* Rijndael's Galois field */
//    }
//    
//    state[0] = b[0] ^ a[3] ^ a[2] ^ b[1] ^ a[1]; /* 2 * a0 + a3 + a2 + 3 * a1 */
//    state[1] = b[1] ^ a[0] ^ a[3] ^ b[2] ^ a[2]; /* 2 * a1 + a0 + a3 + 3 * a2 */
//    state[2] = b[2] ^ a[1] ^ a[0] ^ b[3] ^ a[3]; /* 2 * a2 + a1 + a0 + 3 * a3 */
//    state[3] = b[3] ^ a[2] ^ a[1] ^ b[0] ^ a[0]; /* 2 * a3 + a2 + a1 + 3 * a0 */
//    
//    state[4] = b[4] ^ a[7] ^ a[6] ^ b[5] ^ a[5]; 
//	state[5] = b[5] ^ a[4] ^ a[7] ^ b[6] ^ a[6]; 
//	state[6] = b[6] ^ a[5] ^ a[4] ^ b[7] ^ a[7]; 
//	state[7] = b[7] ^ a[6] ^ a[5] ^ b[4] ^ a[4];
//	
//	state[8] = b[8] ^ a[11] ^ a[10] ^ b[9] ^ a[9]; 
//	state[9] = b[9] ^ a[8] ^ a[11] ^ b[10] ^ a[10]; 
//	state[10] = b[10] ^ a[9] ^ a[8] ^ b[11] ^ a[11]; 
//	state[11] = b[11] ^ a[10] ^ a[9] ^ b[8] ^ a[8];
//	
//	state[12] = b[12] ^ a[15] ^ a[14] ^ b[13] ^ a[13]; 
//	state[13] = b[13] ^ a[12] ^ a[15] ^ b[14] ^ a[14]; 
//	state[14] = b[14] ^ a[13] ^ a[12] ^ b[15] ^ a[15]; 
//	state[15] = b[15] ^ a[14] ^ a[13] ^ b[12] ^ a[12];
//	
//}
//
//void ShiftRows(unsigned char *state)
//{
//	unsigned char tmp[16],i;
//	
//	for (i=0;i<16;i++)
//		tmp[i]=state[i];
//		
//	state[0]=tmp[0];
//	state[1]=tmp[5];
//	state[2]=tmp[10];
//	state[3]=tmp[15];
//	
//	state[4]=tmp[4];
//	state[5]=tmp[9];
//	state[6]=tmp[14];
//	state[7]=tmp[3];
//	
//	state[8]=tmp[8];
//	state[9]=tmp[13];
//	state[10]=tmp[2];
//	state[11]=tmp[7];
//	
//	state[12]=tmp[12];
//	state[13]=tmp[1];
//	state[14]=tmp[6];
//	state[15]=tmp[11];
//}
//
///**********************************************************************/
//void Encrypt(unsigned char *in,unsigned char *key,unsigned char *out)
//{
//    unsigned char expkey[176],i=0;
//    unsigned char state[16]; 
//    
//    for (i=0;i<16;i++)
//        state[i] = in[i];
//    
//    Expankey(key,expkey);
//    AddRoundKey(state,expkey,16);
//    for (i=2;i<11;i++)
//    {
//        SubBytes(state);
//        ShiftRows(state);
//        MixColumns(state);
//        AddRoundKey(state,expkey,i*16);
//    }
//    SubBytes(state);
//    ShiftRows(state);
//    AddRoundKey(state,expkey,i*16);
//    
//    for (i=0;i<16;i++)
//    {
//        out[i] = state[i];
//    }
//}
// End function Encrypt
/*===========================================================*/
void main(void)
{
// Declare your local variables here
unsigned char i,ck,hd[44];
unsigned char j;
unsigned char text[16],key[16],cipher[16];
// Crystal Oscillator division factor: 1
#pragma optsize-
CLKPR=(1<<CLKPCE);
CLKPR=(0<<CLKPCE) | (0<<CLKPS3) | (0<<CLKPS2) | (0<<CLKPS1) | (0<<CLKPS0);
#ifdef _OPTIMIZE_SIZE_
#pragma optsize+
#endif

// Input/Output Ports initialization
// Port B initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

// Port C initialization
// Function: Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRC=(0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
// State: Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

// Port D initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);

// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: On
// USART Transmitter: On
// USART0 Mode: Asynchronous
// USART Baud Rate: 9600
UCSR0A=(0<<RXC0) | (0<<TXC0) | (0<<UDRE0) | (0<<FE0) | (0<<DOR0) | (0<<UPE0) | (0<<U2X0) | (0<<MPCM0);
UCSR0B=(1<<RXCIE0) | (0<<TXCIE0) | (0<<UDRIE0) | (1<<RXEN0) | (1<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
UCSR0C=(0<<UMSEL01) | (0<<UMSEL00) | (0<<UPM01) | (0<<UPM00) | (0<<USBS0) | (1<<UCSZ01) | (1<<UCSZ00) | (0<<UCPOL0);
UBRR0H=0x00;
UBRR0L=0x33;

// Global enable interrupts
#asm("sei")
for(i=0;i<16;i++)
{
text[i]=0x00;
key[i]=0x00;
cipher[i]=0x00;
}
i=0;ck=0;
while (1)
    {   
        while(rx_counter0 == 0);
        delay_ms(1000);
        if(rx_counter0>9)
        {  
        for(i=0;i<44;i++)
            hd[i]='0'; 
        i=0;
        while(rx_counter0>=0)
        {   
            if(rx_counter0==0) break;
            hd[i++]=getchar();  
        } 
        ck=1; 
        }
        
        
        if((rx_counter0 == 0) && (ck == 1))
        {    
            if(hd[0]=='8'&&hd[1]=='0'&&hd[4]=='0'&&hd[5]=='0'&&hd[6]=='0'&&hd[7]=='0'&&hd[8]=='1'&&hd[9]=='0')
            {
                if(hd[2]=='0')
                {
                    switch(hd[3])
                    {
                        case '2':
                        printf("\r\nPlaint Text: \r\n");
                        j=0; 
                        for(i=10;i<42;i++)
                        {
                            if((i+1)%2==0)
                            {   
                                text[j]=0x00;
                                if(hd[i-1]<='9') text[j]=(hd[i-1]-0x30)*0x10;
                                else text[j]=(hd[i-1]-0x57)*0x10;
                                if(hd[i]<='9') text[j++]+=(hd[i]-0x30);
                                else text[j++]+=(hd[i]-0x57);
                            }
                        }
                        delay_ms(100);
                        for(i=0;i<16;i++)
                        {
                        printf("%X ",text[i]); 
                        }
                        break;
                        case '3':
                        printf("\r\nKey: \r\n");
                        j=0;
                        for(i=10;i<42;i++)
                        {
                            if((i+1)%2==0)
                            {   
                                key[j]=0x00;
                                if(hd[i-1]<='9') key[j]=(hd[i-1]-0x30)*0x10;
                                else key[j]=(hd[i-1]-0x57)*0x10;
                                if(hd[i]<='9') key[j++]+=(hd[i]-0x30);
                                else key[j++]+=(hd[i]-0x57);
                            }
                        }
                        delay_ms(100);
                        for(i=0;i<16;i++)
                        {
                        printf("%X ",key[i]);
                        }
                        break;
                        case '4':
                        printf("\r\nWatting Encrypt !!!");
                        printf("\r\nPlaint Text: ");
                        for(i=0;i<16;i++)
                            printf("%X ",text[i]);
                            printf("\r\nKey: "); 
                        for(i=0;i<16;i++)
                            printf("%X ",key[i]); 
                        Encrypt(text,key,cipher);
                        printf("\r\nEnd Encrypt AES-128 !!!");
                        delay_ms(500);
                        printf("\r\nCipher Text: ");
                        for(i=0;i<16;i++)
                            printf("%X ",cipher[i]);
                        Decrypt(text,key,cipher);
                        printf("\r\nDecrypt !!!");
                        printf("\r\nPlaint Text: ");
                        for(i=0;i<16;i++)
                            printf("%X ",cipher[i]);
                        break;
                        default: printf("\r\nNULL\r\n");
                    }
                }
            }
            ck = 0;
            i=0;
        }
      }
}
