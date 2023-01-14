"turing" by "Hrvoje"

Release along with an interpreter.
Release along with a website.
Release along with the introductory booklet.

The door lock is a number variable. The door lock is 1.

The tape is a list of text that varies.
The instruction counter is a number variable. The instruction counter is 1.
The head position is a number variable. The head position is 1.
The current state is a text variable. The current state is "A".

Table of Instructions
Expected state(text)	Expected symbol(text)	Print symbol(text)	Move direction(text)	Next state(text)
with 100 blank rows

When play begins:
	say "You wake up in a room. It is brightly lit and looks like a laboratory. You see a single door."
	
The laboratory is a room. The description is "Brightly lit with all sorts of gadgets and gizmos. There is a single door and no windows. In the corner of the room a machine stands out."

The machine is a man in the laboratory. The description is "A big hunk of machinery with huge rolls of empty tape on either side."

Instead of asking the machine about "this place",
	say "This old lab? It's my little trap for unsuspecting dreamers. I'm willing to open the door if you make a program that eventually halts.";

Instead of asking the machine about "the laboratory",
	say "This old lab? It's my little trap for unsuspecting dreamers. I'm willing to open the door if you make a program that eventually halts.";
	

Instructing expected state is an action applying to one visible thing and one topic.
Understand "tell [someone] to set expected state to [text]" as instructing expected state. 

Carry out Instructing expected state:
	let N be "[topic understood]";
	choose row instruction counter in the Table of Instructions;
	now Expected state entry is "[N]";
	say "Instruction ([instruction counter]) expected state set to [N]".


Setting expected symbol is an action applying to one visible thing and one topic.
Understand "tell [someone] to set expected symbol to [text]" as setting expected symbol. 

Carry out setting expected symbol:
	let N be "[topic understood]";
	choose row instruction counter in the Table of Instructions;
	now Expected symbol entry is "[N]";
	say "Instruction ([instruction counter]) expected symbol set to [N]".

Instructing print symbol is an action applying to one visible thing and one topic.
Understand "tell [someone] to set print symbol to [text]" as instructing print symbol. 

Carry out Instructing print symbol:
	let N be "[topic understood]";
	choose row instruction counter in the Table of Instructions;
	now Print symbol entry is "[N]";
	say "Instruction ([instruction counter]) print symbol set to [N]".
	
Instructing move direction is an action applying to one visible thing and one topic.
Understand "tell [someone] to set move direction to [text]" as instructing move direction. 

Carry out Instructing move direction:
	let N be "[topic understood]";
	choose row instruction counter in the Table of Instructions;
	now Move direction entry is "[N]";
	say "Instruction ([instruction counter]) move direction set to [N]".

Instructing next state is an action applying to one visible thing and one topic.
Understand "tell [someone] to set next state to [text]" as instructing next state. 

Carry out Instructing next state:
	let N be "[topic understood]";
	choose row instruction counter in the Table of Instructions;
	now Next state entry is "[N]";
	say "Instruction ([instruction counter]) next state set to [N]".

New instruction addition is an action applying to one visible thing.
Understand "tell [someone] to add new instruction" as new instruction addition. 

Carry out new instruction addition:
	Now instruction counter is instruction counter + 1;
	say "Instruction count is: [instruction counter]".
	
Setting initial state is an action applying to one visible thing and one topic.
Understand "tell [someone] to set initial state to [text]" as setting initial state. 

Carry out setting initial state:
	let N be "[topic understood]";
	Now the current state is "[N]";
	say "Set the initial machine state to: [N]".
	
Add to tape is an action applying to one visible thing and one topic.
Understand "tell [someone] to add symbol [text] to tape" as add to tape. 

Carry out add to tape:
	let N be "[topic understood]";
	add "[N]" to tape;
	say "Added [N] to tape [line break]";
	say "Tape: [tape]";
	
Starting the machine is an action applying to one visible thing.
Understand "tell [someone] to start" as starting the machine. 

Carry out starting the machine:
	if number of entries in tape is 0:
		add "0" to tape;
	while 1 is 1:
		if "[current state]" is "H":
			break;
		repeat through the Table of Instructions:
			if "[Expected state entry]" is "[current state]" and "[Expected symbol entry]" is "[entry head position of tape]":
				now the current state is "[Next state entry]";
				if "[Print symbol entry]" is "E":
					now entry head position of tape is "0";
				otherwise if "[Print symbol entry]" is "N":
					say "Skip[line break]";
				otherwise:
					now entry head position of tape is "[Print symbol entry]";
				if "[Move direction entry]" is "R":
					now head position is head position + 1;
				otherwise if "[Move direction entry]" is "L":
					now head position is head position - 1;
				if head position < 1:
					now head position is 1;
					add "0" at entry 1 in tape;
				if head position > number of entries in tape:
					add "0" to tape;
				break;
	say "After the program finished symbols on the tape from left to right are: [tape][line break]";
	Now door lock is 0;
	say "Thank you for playing along. I have unlocked the door now. You can leave whenever you wish to."

The exit is a room. It is west of the laboratory. The description is 
"
[if the door lock is 1]
	Door is locked, you don't know what is on the other side.
[otherwise]
	Everything is bright white.
"

Instead of going to the exit:
	if the door lock is 1:
		say "Door is locked, you don't know what is on the other side.";
	otherwise:
		Move the player to the exit;
		End the story finally saying "Congratulations! You have escaped the machine."
