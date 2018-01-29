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
                        printf("\r\nPlaint Text: ");
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
                        printf("\r\nKey: ");
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
                        printf("\r\n\tWatting Encrypt !!!");
//                        printf("\r\nPlaint Text: ");
//                        for(i=0;i<16;i++)
//                            printf("%X ",text[i]);
//                            printf("\r\nKey: "); 
//                        for(i=0;i<16;i++)
//                            printf("%X ",key[i]); 
                        Encrypt(text,key,cipher);
                        delay_ms(500);
                        printf("\r\nCipher Text: ");
                        for(i=0;i<16;i++)
                            printf("%X ",cipher[i]); 
                        printf("\r\n\tEnd Encrypt AES-128 !!!\r\n");
//                        Decrypt(cipher,key,cipher);
//                        printf("\r\n\tWatting Decrypt !!!"); 
//                        delay_ms(500);
//                        printf("\r\nPlaint Text: ");
//                        for(i=0;i<16;i++)
//                            printf("%X ",cipher[i]);
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
