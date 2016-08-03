 

//:
{ In.ar (2) * 5.dup } +> \test;
//:
{ DelayC.ar (In.ar (2) * 5.dup, 0.5, 0.5) } +> \test;
//:
{ DelayC.ar (In.ar (2) * 5, {LFNoise0.kr (5).range (0.01, 9.9)} ! 2, 10) } +> \test;

//:
{ Silent.ar } +> \test;
//:
{ DelayC.ar (In.ar (2) * 5,
	{
		LFNoise0.kr (5).range (0.01, 9.9)
	} ! 2, 10)
} +> \test;
//:
{ DelayC.ar (In.ar (2) * 5,
	{
		Mix ( { LFNoise0.kr (5).range (0.01, 0.9)} ! 20)
	} ! 2, 1)
} +> \test;
//:
{
	var src, fx;
	src = In.ar (2);
	fx = Resonz.ar (src, ([3, 7, 10, 17] + (60 - 12)).midicps, 0.01, 10);
	Mix (fx);
} +> \test;
//:
{
	var src, fx;
	src = In.ar (2);
	fx = Resonz.ar (src, ([3, 7, 10, 17] + (60 - 12)).midicps, 0.01, 10);
	DelayC.ar (Mix (fx), 2, 2);
} +> \test;
//:
{
	var src, fx, delay1, delay2;
	src = In.ar (2);
	fx = Resonz.ar (src, ([3, 7, 10, 17] + (60 - -20)).midicps, 0.01, 10);
	delay1 = DelayC.ar (Mix (fx), [1, 2], [1, 2]);
	delay2 = DelayC.ar (Mix (fx), [3, 4], [3, 4]);

	Mix (delay1, delay2);

} +> \test;
//:
{
	var src, fx, mix;
	src = In.ar (2);
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
{
	var src, fx, chain;
	src = In.ar (2);
	chain = FFT(LocalBuf(2048), src);
	chain = PV_BinScramble(chain, MouseX.kr , 0.1, MouseY.kr > 0.5 );
	IFFT(chain).dup * 10
} +> \test;

//:
{
	var src, fx, chain;
	src = In.ar (2);
	chain = FFT(LocalBuf(2048), src);
	chain = PV_BinScramble(chain, LFNoise1.kr (0.5).range (0.01, 10) , 0.1, 1);
	fx = IFFT(chain) * 10;
	DelayC.ar (fx, [0.5, 1], [1.5, 1.5]);
} +> \test;

//:
{
	var src, fx, chain;
	src = In.ar (2);
	chain = FFT(LocalBuf(2048), src);
	chain = PV_BinScramble(chain, LFNoise0.kr (10).range (0.001, 10) , 0.1, 1);
	fx = IFFT(chain) * LFNoise1.kr (0.5).range (0, 20);
	DelayC.ar (fx, [3, 3], [5, 5]);
} +> \test;
//:


{
	var inA, chainA, inB, chainB, chain;
	inA = In.ar (2);
	inB = DelayC.ar (inA, 0.15, 0.15);
	chainA = FFT(LocalBuf(2048), inA);
	chainB = FFT(LocalBuf(2048), inB);
	chain = PV_BinWipe(chainA, chainB, MouseX.kr(-1, 1));
	10 * IFFT(chain).dup;
	// Out.ar(out, 0.1 * IFFT(chain).dup);
} +> \test;//:

//:
{
	var inA, chainA, inB, chainB, chain;
	inA = In.ar (2);
	inB = DelayC.ar (inA, LFNoise1.kr (0.1).range (0.1, 4.9), 5);
	chainA = FFT(LocalBuf(2048), inA);
	chainB = FFT(LocalBuf(2048), inB);
	chain = PV_BinWipe(chainA, chainB, LFNoise2.kr (12).range (-1, 1));
	30 * IFFT(chain).dup;
	// Out.ar(out, 0.1 * IFFT(chain).dup);
} +> \test;

//: Conformal map ?????
{
	var in, chain;
	in = In.ar(2);
	chain = FFT(LocalBuf(2048), in);
	chain=PV_ConformalMap(chain, MouseX.kr(-1.0,1.0), MouseY.kr(-1.0,1.0));
	IFFT (chain).dup;

} +> \test;
//: MagShift

{
	var in, chain;
	in = In.ar (2);
	chain = FFT(LocalBuf(2048), in);
	chain = PV_MagShift(chain, MouseX.kr(0.25, 4, \exponential) );
	IFFT (chain) * 10;
} +> \test;

//: MagShift

{
	var in, chain;
	in = In.ar (2);
	chain = FFT(LocalBuf(2048), in);
	chain = PV_MagShift(chain, LFNoise1.kr (0.1).range (-10, 10) );
	IFFT (chain) * 10;
} +> \test;
//: MagShift

{
	var in, chain;
	in = In.ar (2);
	chain = FFT(LocalBuf(2048), in);
	chain = PV_MagShift(chain, LFNoise1.kr (0.5).range (-1, 10) );
	IFFT (chain) * 10;
} +> \test;
//: MagShift
{
	var in, chain;
	in = In.ar (2);
	chain = FFT(LocalBuf(2048), in);
	chain = PV_MagShift(chain, LFNoise1.kr (0.5).range (0.1, 10)
		* LFNoise0.kr (5).range (0.7, 1.2) );
	IFFT (chain) * 10;
} +> \test;
//: MagShift
{
	var in, chain;
	in = In.ar (2);
	chain = FFT(LocalBuf(2048), in);
	chain = PV_MagShift(chain, LFNoise1.kr (0.5).range (0.01, 0.1)
		* LFNoise0.kr (5).range (0.7, 1.2) );
	IFFT (chain) * 100;
} +> \test;
//:
{
	var in, chain;
	in = In.ar (2);
	chain = FFT(LocalBuf (2048), in);
	chain = PV_MagSquared(chain);

	IFFT (chain) * 10;
} +> \test;
//:
{
	var in, chain, out;
	in = In.ar (2);
	chain = FFT(LocalBuf (2048), in);
	chain = PV_MagSquared(chain);

	IFFT (chain) * 10;
	
} +> \test;
//:
{
	var in, chain;
	in = In.ar (2);
	chain = FFT(LocalBuf (2048), in);
	chain = PV_MagNoise(chain);
	IFFT (chain) * 10;
} +> \test;

//: BinShift!
{
	var in, chain;
	in = In.ar (2);
	chain = FFT(LocalBuf(2048), in);
	chain = PV_BinShift(chain, MouseX.kr(0.1, 4, \exponential) );
	IFFT (chain) * 10;
} +> \test;
//: BinShift!
{
	var in, chain;
	in = In.ar (2);
	chain = FFT(LocalBuf(2048), in);
	chain = PV_BinShift(chain, {LFNoise1.kr (0.01).range (0.1, 4)} ! 10 );
	[
		Mix (IFFT (chain) [0..4] * 10),
		Mix (IFFT (chain) [5..9] * 10)
	];
} +> \test;
//: BinShift!
{
	var in, chain;
	in = In.ar (2);
	chain = FFT(LocalBuf(2048), in);
	chain = PV_BinShift(chain, {LFNoise2.kr (0.1).range (0.1, 14)} ! 10 );
	[
		Mix (IFFT (chain) [0..4] * 10),
		Mix (IFFT (chain) [5..9] * 10)
	];
} +> \test;
//: BinShift!
{
	var in, chain, ifft;
	in = In.ar (2);
	chain = FFT(LocalBuf(2048), in);
	chain = PV_BinShift(chain, {LFNoise2.kr (0.1).range (0.1, 14)} ! 10 );
	ifft = IFFT (chain) * 10;
	[
		DelayC.ar (ifft [0], 1, 5)
	];
} +> \test;
//: BinShift!
{
	var in, chain, ifft;
	in = In.ar (2);
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
{
	var in, chain, ifft;
	in = In.ar (2);
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
{
	var in, chain, ifft;
	in = In.ar (2);
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
{
	var in, chain, ifft;
	in = In.ar (2);
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
{
	var in, chain, ifft;
	in = In.ar (2);
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
//:
