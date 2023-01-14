grammar turing;

program: (setState 
    | setTape 
    | addInstruction 
    | clearInstructions 
    | run) NEWLINE;

setState: STATE SYMBOLS;
setTape: TAPE SYMBOLS+;
addInstruction: ADDINSTRUCTION SYMBOLS SYMBOLS SYMBOLS DIRECTION SYMBOLS;
clearInstructions: CLEARINSTRUCTIONS;
run: RUN;

STATE: 'set_state';
TAPE: 'set_tape';
ADDINSTRUCTION: 'add_instruction';
CLEARINSTRUCTIONS: 'clear_instructions';
RUN: 'run';
DIRECTION: 'L' | 'R' | 'N';
SYMBOLS: [a-zA-Z0-9čćžđšŽĆČŠĐ./?:;,+!-];

EMPTY: (' ' | '\t') -> skip;
NEWLINE: [\n]+;
