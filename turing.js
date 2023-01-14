const updateTape = (tape, position, instruction, blankSymbol) => {
    // Erase
    if (instruction.printSymbol === "E") {
        return {
            ...tape,
            [position]: blankSymbol,
        }
        // NOOP
    } else if (instruction.printSymbol === "N") {
        return { ...tape };
    } else {
        return {
            ...tape,
            [position]: instruction.printSymbol
        }
    }
}

const moveTapePosition = (currentPosition, instruction) => {
    return instruction.direction === "R"
        ? currentPosition + 1
        : instruction.direction === "L"
            ? currentPosition - 1
            : currentPosition;
};

let iteration = 0;

const runMachine = (
    state,
    tape,
    position,
    instructions,
    blankSymbol = "0"
) => {
    if (state === "H") {
        return tape;
    }
    const currentInstruction = instructions[state][tape[position] === undefined ? blankSymbol : tape[position]];
    const newTape = updateTape(tape, position, currentInstruction, blankSymbol);
    const newTapePosition = moveTapePosition(position, currentInstruction);
    return runMachine(currentInstruction.newState, newTape, newTapePosition, instructions, blankSymbol);
};

// https://en.wikipedia.org/wiki/Turing_machine#Additional_details_required_to_visualize_or_implement_Turing_machines
// 3-state 2-symbol busy beaver
const threeStateTwoSymbolBusyBeaverResult = runMachine("A", { "0": "0" }, 0, {
    A: {
        "0": { printSymbol: "1", direction: "R", newState: "B" },
        "1": { printSymbol: "1", direction: "L", newState: "C" },
    },
    B: {
        "0": { printSymbol: "1", direction: "L", newState: "A" },
        "1": { printSymbol: "1", direction: "R", newState: "B" },
    },
    C: {
        "0": { printSymbol: "1", direction: "L", newState: "B" },
        "1": { printSymbol: "1", direction: "N", newState: "H" },
    },
});
console.log(threeStateTwoSymbolBusyBeaverResult);
