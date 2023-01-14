#!/usr/bin/bash

declare -A TAPE

TAPEPOSITION=0

function readStateInput() {
    echo "Inicijalno stanje moze biti bilo koji simbol"
    echo -n "Unesite inicijalno stanje: " 
    read STATE
    if [[ $STATE == "" ]]; then
        STATE="0"
    fi
}

function readTapeInput() {
    echo "Inicijalno stanje vrpce; simboli su odvojeni razmakom, prazni simbol je 0"
    echo -n "Unesite inicijalno stanje vrpce: "
    read -a intape
    if [[ $intape == "" ]]; then
        intape="0"
    fi
    
    local counter=0
    for symbol in "${intape[@]}"; do
        TAPE["$counter"]=$symbol
        counter=$((counter + 1))
    done
}

function readInstructionsInput() {
    echo "Unos instrukcija"
    echo "Jedna instrukcija mora redom imati:"
    echo "Trenutno stanje | Skenirani simbol s trake | Simbol za ispis | Smjer kretanja | Novo stanje"
    echo "Za završetak unosa instrukcija unesite prazni red"
    local counter=0
    while true; do
        echo -n "Instrukcija: "
        read instruction
        if [[ $instruction == "" ]]; then
            break
        fi
        INSTRUCTIONS[$counter]=$instruction
        counter=$((counter + 1))
    done
}

function setCurrentInstruction() {
    for instruction in "${INSTRUCTIONS[@]}"; do
        read -a splitInstruction <<< $instruction
        if [[ ${splitInstruction[0]} == $STATE ]] && [[ ${splitInstruction[1]} == ${TAPE[$TAPEPOSITION]} ]]; then
            CURRENTPRIMTSYMBOL=${splitInstruction[2]}
            CURRENTMOVE=${splitInstruction[3]}
            CURRENTNEWSTATE=${splitInstruction[4]}
            break
        fi
    done
}

function writeEmptyToNewTapePosition() {
    if [[ ${TAPE[$TAPEPOSITION]} == "" ]]; then
        TAPE[$TAPEPOSITION]="0"
    fi
}

function runInstruction() {
    # Erase
    if [[ $CURRENTPRIMTSYMBOL == "E" ]]; then
        TAPE[$TAPEPOSITION]="0"
    # NOOP
    elif [[ $CURRENTPRIMTSYMBOL == "N" ]]; then
        :
    else
        TAPE[$TAPEPOSITION]=$CURRENTPRIMTSYMBOL
    fi

    if [[ $CURRENTMOVE == "R" ]]; then
        TAPEPOSITION=$((TAPEPOSITION + 1))
    elif [[ $CURRENTMOVE == "L" ]]; then
        TAPEPOSITION=$((TAPEPOSITION - 1))
    else
        :
    fi

    writeEmptyToNewTapePosition
    STATE=$CURRENTNEWSTATE
}

function printTape() {
    pTape=""
    for idx in "${!TAPE[@]}"; do
        pTape+="$idx | ${TAPE[$idx]}\n"
    done
    echo --------------
    echo REZULTATI:
    echo "POZICIJA NA VRPCI | VRIJEDNOST"
    echo -e $pTape | sort -n | awk NF
}

function runMachine() {
    while [[ $STATE != "H" ]]; do
        setCurrentInstruction
        runInstruction
    done
}

readStateInput
readTapeInput
readInstructionsInput
runMachine
printTape
