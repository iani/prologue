



Server.killAll;

Server.default.boot;

Server.default.options.memSize = 16 * 8192;

//:

MIDIClient.init;

MIDIIn.connectAll;

MIDIFunc.trace(true);
//:
MIDIdef.cc (\test, { | val |
	if (val == 0) {
		\test.set (\inamp, 1);
	}{   // when pedal is pressed, then shut off input:
		\test.set (\inamp, 0);
	}
}, 64, 0);
//:
MIDIFunc.trace(false);
//:
{ | inamp | inamp * In.ar (2) * 5.dup } +> \test;
//:
{ DelayC.ar (inamp * In.ar (2) * 5.dup, 0.5, 0.5) } +> \test;
//:
{ DelayC.ar (inamp * In.ar (2) * 5, {LFNoise0.kr (5).range (0.01, 9.9)} ! 2, 10) } +> \test;

//:
{ Silent.ar } +> \test;
//:
{ | inamp = 1 |
	DelayC.ar (inamp * In.ar (2) * 5,
	{
		LFNoise0.kr (5).range (0.01, 9.9)
	} ! 2, 10)
} +> \test;
//:
{ | inamp = 1 |
	DelayC.ar (inamp * In.ar (2) * 5,
	{
		Mix ( { LFNoise0.kr (5).range (0.01, 0.9)} ! 20)
	} ! 2, 1)
} +> \test;
//:
{ | inamp = 1 |
	var src, fx;
	src = inamp * In.ar (2);
	fx = Resonz.ar (src, ([3, 7, 10, 17] + (60 - 12)).midicps, 0.01, 10);
	Mix (fx);
} +> \test;
//:
{ | inamp = 1 |
	var src, fx;
	src = inamp * In.ar (2);
	fx = Resonz.ar (src, ([3, 7, 10, 17] + (60 - 12)).midicps, 0.01, 10);
	DelayC.ar (Mix (fx), 2, 2);
} +> \test;
//:
{ | inamp = 1 |
	var src, fx, delay1, delay2;
	src = inamp * In.ar (2);
	fx = Resonz.ar (src, ([3, 7, 10, 17] + (60 - -20)).midicps, 0.01, 10);
	delay1 = DelayC.ar (Mix (fx), [1, 2], [1, 2]);
	delay2 = DelayC.ar (Mix (fx), [3, 4], [3, 4]);

	Mix (delay1, delay2);

} +> \test;
//:
{ | inamp = 1 |
	var src, fx, mix;
	src = inamp * In.ar (2);
	fx = ((3..17) + 60).midicps collect: { | f, dt |
		DelayC.ar (
			Resonz.ar(src, f, 0.001, 90),
			(dt + 1) / 5,
			(dt + 1) / 5
		)
	};
	mix = Mix (fx);
	mix.dup;

} +> \test;
//:
{ | inamp = 1 |
	var src, fx, chain;
	src = inamp * In.ar (2);
	chain = FFT(LocalBuf(2048), src);
	chain = PV_BinScramble(chain, MouseX.kr , 0.1, MouseY.kr > 0.5 );
	IFFT(chain).dup * 10
} +> \test;

//:
{ | inamp = 1 |
	var src, fx, chain;
	src = inamp * In.ar (2);
	chain = FFT(LocalBuf(2048), src);
	chain = PV_BinScramble(chain, LFNoise1.kr (0.5).range (0.01, 10) , 0.1, 1);
	fx = IFFT(chain) * 10;
	DelayC.ar (fx, [0.5, 1], [1.5, 1.5]);
} +> \test;

//:
{ | inamp = 1 |
	var src, fx, chain;
	src = inamp * In.ar (2);
	chain = FFT(LocalBuf(2048), src);
	chain = PV_BinScramble(chain, LFNoise1.kr ([0.5, 0.1, 0.05]).range (0.01, 10) , 0.1, 1);
	fx = IFFT(chain) * 10;
	DelayC.ar (Mix(fx), [0.5, 1], [1.5, 1.5]);
} +> \test;

//:
{ | inamp = 1 |
	var src, fx, chain;
	src = inamp * In.ar (2);
	chain = FFT(LocalBuf(2048), src);
	chain = PV_BinScramble(chain, LFNoise0.kr (10).range (0.001, 10) , 0.1, 1);
	fx = IFFT(chain) * LFNoise1.kr (0.5).range (0, 20);
	DelayC.ar (fx, [3, 3], [5, 5]);
} +> \test;
//:
{ | inamp = 1 |
	var src, fx, chain;
	src = inamp * In.ar (2);
	chain = FFT(LocalBuf(2048), src);
	chain = PV_MagAbove(chain, LFNoise1.kr ([10, 1]).range (0.001, 1));
	fx = IFFT(chain); //  * LFNoise1.kr (0.5).range (0, 20);
	DelayC.ar (Mix(fx), [0.3, 3], [5, 5]);
} +> \test;
//:


{ | inamp = 1 |
	var inA, chainA, inB, chainB, chain;
	inA = inamp * In.ar (2);
	inB = DelayC.ar (inA, 0.15, 0.15);
	chainA = FFT(LocalBuf(2048), inA);
	chainB = FFT(LocalBuf(2048), inB);
	chain = PV_BinWipe(chainA, chainB, MouseX.kr(-1, 1));
	10 * IFFT(chain).dup;
	// Out.ar(out, 0.1 * IFFT(chain).dup);
} +> \test;//:

//:
{ | inamp = 1 |
	var inA, chainA, inB, chainB, chain;
	inA = inamp * In.ar (2);
	inB = DelayC.ar (inA, LFNoise1.kr (0.1).range (0.1, 4.9), 5);
	chainA = FFT(LocalBuf(2048), inA);
	chainB = FFT(LocalBuf(2048), inB);
	chain = PV_BinWipe(chainA, chainB, LFNoise2.kr (12).range (-1, 1));
	30 * IFFT(chain).dup;
	// Out.ar(out, 0.1 * IFFT(chain).dup);
} +> \test;

//: Conformal map ?????
{ | inamp = 1 |
	var in, chain;
	in = inamp * In.ar(2);
	chain = FFT(LocalBuf(2048), in);
	chain=PV_ConformalMap(chain, MouseX.kr(-1.0,1.0), MouseY.kr(-1.0,1.0));
	IFFT (chain).dup;

} +> \test;
//: MagShift

{ | inamp = 1 |
	var in, chain;
	in = inamp * In.ar (2);
	chain = FFT(LocalBuf(2048), in);
	chain = PV_MagShift(chain, MouseX.kr(0.25, 4, \exponential) );
	IFFT (chain) * 10;
} +> \test;

//: MagShift

{ | inamp = 1 |
	var in, chain;
	in = inamp * In.ar (2);
	chain = FFT(LocalBuf(2048), in);
	chain = PV_MagShift(chain, LFNoise1.kr (0.1).range (-10, 10) );
	IFFT (chain) * 10;
} +> \test;
//: MagShift

{ | inamp = 1 |
	var in, chain;
	in = inamp * In.ar (2);
	chain = FFT(LocalBuf(2048), in);
	chain = PV_MagShift(chain, LFNoise1.kr (0.5).range (-1, 10) );
	IFFT (chain) * 10;
} +> \test;
//: MagShift
{ | inamp = 1 |
	var in, chain;
	in = inamp * In.ar (2);
	chain = FFT(LocalBuf(2048), in);
	chain = PV_MagShift(chain, LFNoise1.kr (0.5).range (0.1, 10)
		* LFNoise0.kr (5).range (0.7, 1.2) );
	IFFT (chain) * 10;
} +> \test;
//: MagShift
{ | inamp = 1 |
	var in, chain;
	in = inamp * In.ar (2);
	chain = FFT(LocalBuf(2048), in);
	chain = PV_MagShift(chain, LFNoise1.kr (0.5).range (0.01, 0.1)
		* LFNoise0.kr (5).range (0.7, 1.2) );
	IFFT (chain) * 100;
} +> \test;
//:
{ | inamp = 1 |
	var in, chain;
	in = inamp * In.ar (2);
	chain = FFT(LocalBuf (2048), in);
	chain = PV_MagSquared(chain);

	IFFT (chain) * 10;
} +> \test;
//:
{ | inamp = 1 |
	var in, chain, out;
	in = inamp * In.ar (2);
	chain = FFT(LocalBuf (2048), in);
	chain = PV_MagSquared(chain);

	IFFT (chain) * 10;
	
} +> \test;
//:
{ | inamp = 1 |
	var in, chain;
	in = inamp * In.ar (2);
	chain = FFT(LocalBuf (2048), in);
	chain = PV_MagNoise(chain);
	IFFT (chain) * 10;
} +> \test;

//: BinShift!
{ | inamp = 1 |
	var in, chain;
	in = inamp * In.ar (2);
	chain = FFT(LocalBuf(2048), in);
	chain = PV_BinShift(chain, MouseX.kr(0.1, 4, \exponential) );
	IFFT (chain) * 10;
} +> \test;
//: BinShift!
{ | inamp = 1 |
	var in, chain;
	in = inamp * In.ar (2);
	chain = FFT(LocalBuf(2048), in);
	chain = PV_BinShift(chain, {LFNoise1.kr (0.01).range (0.1, 4)} ! 10 );
	[
		Mix (IFFT (chain) [0..4] * 10),
		Mix (IFFT (chain) [5..9] * 10)
	];
} +> \test;
//: BinShift!
{ | inamp = 1 |
	var in, chain;
	in = inamp * In.ar (2);
	chain = FFT(LocalBuf(2048), in);
	chain = PV_BinShift(chain, {LFNoise2.kr (0.1).range (0.1, 14)} ! 10 );
	[
		Mix (IFFT (chain) [0..4] * 10),
		Mix (IFFT (chain) [5..9] * 10)
	];
} +> \test;
//: BinShift!
{ | inamp = 1 |
	var in, chain, ifft;
	in = inamp * In.ar (2);
	chain = FFT(LocalBuf(2048), in);
	chain = PV_BinShift(chain, {LFNoise2.kr (0.1).range (0.1, 14)} ! 10 );
	ifft = IFFT (chain) * 10;
	[
		DelayC.ar (ifft [0], 1, 5)
	];
} +> \test;
//: BinShift!
{ | inamp = 1 |
	var in, chain, ifft;
	in = inamp * In.ar (2);
	chain = FFT(LocalBuf(2048), in);
	chain = PV_BinShift(chain, {LFNoise2.kr (0.1).range (0.1, 14)} ! 10 );
	ifft = IFFT (chain) * 10;
	[
		Mix (
			ifft [0..4] collect: { | i |
				DelayC.ar (i, LFNoise1.kr (1).range (0.1, 4.9), 5)
			}
		),
		Mix (
			ifft [0..4] collect: { | i |
				DelayC.ar (i, LFNoise1.kr (1).range (0.1, 4.9), 5)
			}
		)
	];
} +> \test;
//: BinShift!
{ | inamp = 1 |
	var in, chain, ifft;
	in = inamp * In.ar (2);
	chain = FFT(LocalBuf(2048), in);
	chain = PV_BinShift(chain, {LFNoise2.kr (5).range (12, 14)} ! 10 );
	ifft = IFFT (chain) * 10;
	[
		Mix (
			ifft [0..4] collect: { | i |
				DelayC.ar (i, LFNoise1.kr (1).range (0.1, 4.9), 5)
			}
		),
		Mix (
			ifft [0..4] collect: { | i |
				DelayC.ar (i, LFNoise1.kr (1).range (0.1, 4.9), 5)
			}
		)
	];
} +> \test;
//: BinShift!
{ | inamp = 1 |
	var in, chain, ifft;
	in = inamp * In.ar (2);
	chain = FFT(LocalBuf(2048), in);
	chain = PV_BinShift(chain, {LFNoise0.kr (15).range (2, 14)} ! 10 );
	ifft = IFFT (chain) * 10;
	[
		Mix (
			ifft [0..4] collect: { | i |
				DelayC.ar (i, LFNoise1.kr (1).range (0.1, 4.9), 5)
			}
		),
		Mix (
			ifft [0..4] collect: { | i |
				DelayC.ar (i, LFNoise1.kr (1).range (0.1, 4.9), 5)
			}
		)
	];
} +> \test;
//: BinShift!
{ | inamp = 1 |
	var in, chain, ifft;
	in = inamp * In.ar (2);
	chain = FFT(LocalBuf(2048), in);
	chain = PV_BinShift(chain, {LFNoise0.kr (15).range (2, 14)} ! 10 );
	ifft = IFFT (chain) * 10;
	[
		Mix (
			ifft [0..4] collect: { | i |
				DelayC.ar (i, LFNoise1.kr (0.1).range (0.1, 9.9), 10)
			}
		),
		Mix (
			ifft [0..4] collect: { | i |
				DelayC.ar (i, LFNoise1.kr (0.1).range (0.1, 9.9), 10)
			}
		)
	];
} +> \test;
//: BinShift!
{ | inamp = 1 |
	var in, chain, ifft;
	in = inamp * In.ar (2);
	chain = FFT(LocalBuf(2048), in);
	chain = PV_BinShift(chain, {LFNoise0.kr (15).range (0.2, 0.4)} ! 10 );
	ifft = IFFT (chain) * 10;
	[
		Mix (
			ifft [0..4] collect: { | i |
				DelayC.ar (i, LFNoise1.kr (0.1).range (0.1, 9.9), 10)
			}
		),
		Mix (
			ifft [0..4] collect: { | i |
				DelayC.ar (i, LFNoise1.kr (0.1).range (0.1, 9.9), 10)
			}
		)
	];
} +> \test;
//: BinShift!
{ | inamp = 1 |
	var in, chain, ifft;
	in = inamp * In.ar (2);
	chain = FFT(LocalBuf(2048), in);
	chain = PV_BinShift(chain, {LFNoise2.kr (5).range (0.1, 0.24)} ! 10 );
	ifft = IFFT (chain) * 10;
	[
		Mix (
			ifft [0..4] collect: { | i |
				DelayC.ar (i, LFNoise1.kr (1).range (0.1, 4.9), 5)
			}
		),
		Mix (
			ifft [0..4] collect: { | i |
				DelayC.ar (i, LFNoise1.kr (1).range (0.1, 4.9), 5)
			}
		)
	];
} +> \test;
//: MagSmear
{ | inamp = 1 |
	var in, chain, ifft;
	in = inamp * In.ar (2);
	chain = FFT(LocalBuf(2048), in);
	chain = PV_MagSmear(chain, {LFNoise2.kr (0.5).range (0.1, 5.24)} ! 10 );
	ifft = IFFT (chain) * 10;
	[
		Mix (
			ifft [0..4] collect: { | i |
				DelayC.ar (i, LFNoise1.kr (1).range (0.1, 4.9), 5)
			}
		),
		Mix (
			ifft [0..4] collect: { | i |
				DelayC.ar (i, LFNoise1.kr (1).range (0.1, 4.9), 5)
			}
		)
	];
} +> \test;
//: MagSmear
{ | inamp = 1 |
	var in, chain, ifft;
	in = inamp * In.ar (2);
	chain = FFT(LocalBuf(2048), in);
	chain = PV_MagSmear(chain, {LFNoise2.kr (0.1 rrand: 5).range (3, 15.24)} ! 20 );
	ifft = IFFT (chain) * 10;
	[
		Mix (
			ifft [0..4] collect: { | i |
				DelayC.ar (i, LFNoise1.kr (1).range (0.1, 4.9), 5)
			}
		),
		Mix (
			ifft [0..4] collect: { | i |
				DelayC.ar (i, LFNoise1.kr (1).range (0.1, 4.9), 5)
			}
		)
	];
} +> \test;
//:


//: