from turingLexer import turingLexer
from turingListener import turingListener
from turingParser import turingParser
from antlr4 import *

import sys

class TuringMachine:
    state = None
    instructions = {}
    position = 0

    def __init__(self, blankSymbol = "0") -> None:
        self.blank_symbol = blankSymbol
        self.tape = {self.position: self.blank_symbol}

    def set_blank_symbol(self, new_blank):
        self.blank_symbol = new_blank

    def set_state(self, new_state):
        self.state = new_state

    def set_tape(self, new_tape):
        self.tape = new_tape

    def add_instruction(self, expected_state, expected_scanned_symbol, instruction):
        if self.instructions.get(expected_state) == None:
            self.instructions[expected_state] = {
                expected_scanned_symbol: instruction
            }
        else:
            self.instructions[expected_state][expected_scanned_symbol] = instruction

    def run_instruction(self):
        instructions_group = self.instructions.get(self.state)
        if instructions_group == None:
            raise Exception("Machine is in an unhandled state")
        scanned_symbol = self.tape[self.position] if self.tape.get(self.position) != None else self.blank_symbol
        instruction = instructions_group.get(scanned_symbol)
        if instruction == None:
            raise Exception("Machine is in an unhandled state")
        
        self.set_state(instruction["new_state"])

        # Erase
        if instruction['print_symbol'] == "E":
            self.tape[self.position] = self.blank_symbol
        # NOOP
        elif instruction['print_symbol'] == "N":
            pass
        else:
            self.tape[self.position] = instruction['print_symbol']

        if instruction['direction'] == "R":
            self.position += 1
        elif instruction['direction'] == "L":
            self.position -= 1
        else:
            pass

        if self.tape.get(self.position) == None:
            self.tape[self.position] = self.blank_symbol


    def run_machine(self):
        if self.state == None:
            raise Exception("Machine state is not set")
        while True:
            if (self.state == "H"):
                break
            self.run_instruction()
        print(self.tape)


class listener(turingListener):
    turing_machine = TuringMachine()

    def exitSetState(self, ctx:turingParser.SetStateContext):
        if ctx.SYMBOLS() != None:
            self.turing_machine.set_state(str(ctx.SYMBOLS()))

    def exitSetTape(self, ctx:turingParser.SetTapeContext):
        split = ctx.toStringTree().removeprefix("(").removesuffix(")").split(" ")
        if len(split) > 2:
            tape = {}
            for idx, symbol in enumerate(split[2:]):
                tape[idx] = symbol
            self.turing_machine.set_tape(tape)

    def exitAddInstruction(self, ctx:turingParser.AddInstructionContext):
        if ctx.SYMBOLS() != None and len(ctx.SYMBOLS()) == 4 and ctx.DIRECTION() != None:
            symbols = ctx.SYMBOLS();
            expected_state = str(symbols[0])
            expected_scanned_symbol = str(symbols[1])
            instruction = {
                'print_symbol': str(symbols[2]),
                'direction': str(ctx.DIRECTION()),
                'new_state': str(symbols[3])
            }
            self.turing_machine.add_instruction(expected_state, expected_scanned_symbol, instruction)

    def exitClearInstructions(self, ctx:turingParser.ClearInstructionsContext):
        self.turing_machine.instructions = {}

    def exitRun(self, ctx:turingParser.RunContext):
        self.turing_machine.run_machine()

def process(stream):
    lexer = turingLexer(stream)
    stream = CommonTokenStream(lexer)
    parser = turingParser(stream)
    tree = parser.program()
    printer = listener()
    walker = ParseTreeWalker()
    walker.walk(printer, tree)
 
def main():
    while True:
        try:
            command = input("$ ")
        except:
            sys.exit()
        if command == "exit":
            break
        else:
            stream = InputStream(command + '\n')
            process(stream)

if __name__ == '__main__':
    main()        
