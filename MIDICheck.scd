
// C 3 Aug 2016 16:12

MIDIClient.init;

MIDIIn.connectAll;

MIDIFunc.trace(true);


MIDIFunc.noteOn ({ | ... args | args.postln; }).add;


MIDIFunc.cc({arg ...args; args.postln}, 1);

//: Pedal key identification

//: chan: 0, num: 64, val: 127 for on and 0 for off