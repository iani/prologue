
// C 3 Aug 2016 16:12

MIDIClient.init;

MIDIIn.connectAll;

MIDIFunc.trace(true);


MIDIFunc.noteOn ({ | ... args | args.postln; }).add;


MIDIFunc.cc({arg ...args; args.postln}, 1);

//: Pedal key identification

//: chan: 0, num: 64, val: 127 for on and 0 for off

{ | freq = 400 | SinOsc.ar (freq, 0, 0.1) } +> \midiTest;

//:  arg key, func, ccNum, chan
MIDIdef.cc (\midiTest, { | val |
	if (val == 0) {
		\midiTest.set (\freq, 600);
	}{
		\midiTest.set (\freq, 800);
	}
}, 64, 0);
//:
MIDIFunc.trace(false);
