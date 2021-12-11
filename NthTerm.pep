;a program which asks the user for the coefficients of a quadratic equation (a * n^2 + b * n + c), then calculates and prints out first 4 terms and the Nth term.

BR inputs ;branch straight to inputs

;declaring messages and variables for input a, b, c, n
reqmsgA: .ASCII "Enter a decimal value for a: \x00"
numA:    .BLOCK 2
reqmsgB: .ASCII "Enter a decimal value for b: \x00"
numB:    .BLOCK 2
reqmsgC: .ASCII "Enter a decimal value for c: \x00"
numC:    .BLOCK 2
reqmsgN: .ASCII "Enter a decimal value for n: \x00"
numN:    .BLOCK 2

resMsgP1: .ASCII "Term \x00" ;part 1 for the message for 'Term numN: ', this part includes only 'Term ' then numN will be printed so we will have 'Term numN'
resMsgP2: .ASCII ": \x00" ;part 2 for the message for 'Term numN: ', this part includes ': ' 

newLine: .ASCII "\n\x00" ;string for printing out an empty line

pwrOut:  .BLOCK 2 ;variable for the result of n^2
pwrLpCnt:.BLOCK 2 ;Power Loop Counter - this variable will be used for calculating the
                  ;number of times we have to repeat the pwrLoop to get n^2 result, at the beginning
                  ;it is going to be the same as N. Every time loop repeats, 1 will be subtracted from the counter.

an2Out:  .BLOCK 2 ;variable for the result of a * n^2
an2Cnt:  .BLOCK 2 ;Counter for a * n^2 loop - it will be a copy of the result of n^2 because we want to multiply by the result of n^2 (pwrOut).

bnOut:   .BLOCK 2 ;variable for the result of b * n
bnCnt:   .BLOCK 2 ;copy of the value of numN - used just as counter for b * n loop

termNOut: .BLOCK 2 ;variable for storing the result of the term (a*n^2 + b*n + c)
numNLast: .BLOCK 2 ;this variable is used to store the numN input entered by the user

termsCnt: .BLOCK 2 ;counter for terms

         ;inputs and printing out messages
inputs:  STRO reqmsgA,d ;ask user for input A
         DECI numA,d       

         STRO reqmsgB,d ;ask user for input B
         DECI numB,d 

         STRO reqmsgC,d ;ask user for input C
         DECI numC,d 

         STRO reqmsgN,d ;ask user for input N (matters only for printing out the Nth term, terms 1 2 3 4 get N assigned to 1 2 3 4 anyway)
         DECI numNLast,d 

         ;setting the terms loop counter to 4, with each cycle 1 will be subtracted from termsCnt. 4 terms will be printed 
         ;and when it reaches 0 the nth term will be printed at the end, after calculating and printing out nth term the counter value will be -1
         ;so the program will not an have infinite loop
         LDWA 0x0004,i
         STWA termsCnt,d

         ;setting numN to 1 (for the calculation of 1st term, later numN will be increased by one witch each cycle of the loop for the next 3 terms)
         LDWA 0x0001,i
         STWA numN,d

         ;preparing counter for n^2 loop
start:   LDWA numN,d ;load value of numN to Acc
         STWA pwrLpCnt,d ;store value of Acc in pwrLpCnt (it is just a copy of numN - will be needed for loop counter). 
         
         ;calculating n^2
powerLp: BREQ an2Prep ;when the pwrLpCnt reaches 0 branch to an2 preparation
         LDWA pwrOut,d 
         ADDA numN,d 
         STWA pwrOut,d ;result of the power
         LDWA pwrLpCnt,d 
         SUBA 0x0001,i ;subtract 1 from the counter
         STWA pwrLpCnt,d 
         BR   powerLp 
         
         ;preparing counter for a * n^2 loop
an2Prep: LDWA pwrOut,d 
         STWA an2Cnt,d ;using the value of n^2 as a counter for the an^2 multiplication (a * pwrOut) 

         ;calculating a * n^2 (a * pwrOut)
an2Lp:   BREQ bnPrep ;when an2Cnt reaches 0 branch to bn preparation 
         LDWA an2Out,d 
         ADDA numA,d 
         STWA an2Out,d ;result of an^2
         LDWA an2Cnt,d 
         SUBA 0x0001,i ;subtract 1 from Acc (subtracting 1 from the counter)
         STWA an2Cnt,d 
         BR   an2Lp 

         ;preparing counter for b * n loop
bnPrep:  LDWA numN,d 
         STWA bnCnt,d ;using the value of numN as counter for the bn multiplication 

         ;calculating b * n
bnLp:    BREQ terms ;when the bnCnt reaches 0 branch to terms
         LDWA bnOut,d 
         ADDA numB,d 
         STWA bnOut,d ;result of b*n
         LDWA bnCnt,d 
         SUBA 0x0001,i ;subtract 1 from the counter
         STWA bnCnt,d 
         BR   bnLp 

         ;calculating term
terms:   LDWA an2Out,d 
         ADDA bnOut,d 
         ADDA numC,d 
         STWA termNOut,d ;result of addition of an^2 + bn + C
         
         ;printing out the term
         STRO newLine,d 
         STRO resMsgP1,d 
         DECO numN,d 
         STRO resMsgP2,d 
         DECO termNOut,d 

         ;subtracting 1 from the terms counter
         LDWA termsCnt,d
         SUBA 0x0001,i
         STWA termsCnt,d

         ;reset all the output values and counters after each cycle
         LDWA 0,i
         STWA pwrOut,d
         STWA pwrLpCnt,d
         STWA an2Out,d
         STWA an2Cnt,d
         STWA bnOut,d
         STWA bnCnt,d
         
         ;adding 1 to numN after each cycle
         LDWA numN,d
         ADDA 0x0001,i
         STWA numN,d

         ;this segment of the code branches to start  to calculate and print terms 2 3 and 4
         LDWA termsCnt,d
         BRGT start ;stop repeating after the counter > 0
         
         STRO newLine,d
         
         ;calculating and printing nth term
         LDWA numNLast,d
         STWA numN,d ;set numN to the initial input of the user that the program stored at the very beginning in numNLast.

         LDWA termsCnt,d
         BREQ start ;when termsCnt reached 0 the last calculations will be done -but this time with updated numN. After that termsCnt will be -1
                    ;so the loop will not become infinite and the program will end.

.END
