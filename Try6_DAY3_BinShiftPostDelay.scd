

//: MIDI

MIDIClient.init;

MIDIIn.connectAll;

MIDIFunc.trace(true);
//:
MIDIdef.cc (\test, { | val |
	if (val == 0) {
		"INPUT ON".postln;
		\test.set (\inamp, 1);
	}{   // when pedal is pressed, then shut off input:
		"INPUT MUTED ================".postln;
		\test.set (\inamp, 0);
	}
}, 64, 0);

//: BinShift after delay
// each delay has a different binshift.
{ | inamp = 1 |
	var in, chain, delays, shifts;
	in = inamp * In.ar (2);
	delays = DelayC.ar (in, {LFNoise1.kr (0.1).range (0.1, 9.9)} ! 10, 10);
	shifts = delays collect: { | d |
		chain = FFT(LocalBuf(2048), d);
		chain = PV_BinShift(chain, LFNoise1.kr (0.1).range (0.2, 14) );
		IFFT (chain);
	};

	[
		Mix (
			shifts [0..4] * 5
		),
		Mix (
			shifts [5..9] * 5
		)
	];
} +> \test;
