


Server.killAll;

{ SinOsc.ar (400, 0, 0.5) } +> \test;

Server.default.options.device = "ProFire 610";

Server.default.options.memSize = 8192 * 16;

Server.default.boot;
//:


{ In.ar (2) * 5.dup } +> \test;

//:
{ DelayC.ar (In.ar (2) * 5.dup, 0.5, 0.5) } +> \test;

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
	chain = PV_BinScramble(chain, LFNoise1.kr (9.15).range (0.001, 10) , 0.1, 1);
	fx = IFFT(chain) * LFNoise1.kr (0.5).range (0, 20);
	DelayC.ar (fx, [3, 3], [5, 5]);
} +> \test;
//:


{
	var inA, chainA, inB, chainB, chain;
	inA = In.ar (2);
	inB = DelayC.ar (inA, 0.15, 0.1
5);
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