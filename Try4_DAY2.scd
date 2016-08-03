//:



{ | inamp = 1 |
	var in, chain, ifft;
	in = In.ar (2) * inamp;
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

//:



{ | inamp = 1 |
	var in, chain, ifft;
	in = In.ar (2) * inamp;
	chain = FFT(LocalBuf(2048), in);
	chain = PV_BinShift(chain, {LFNoise0.kr (0.1).range (1.2, 2.4)} ! 10 );
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

//:



{ | inamp = 1 |
	var in, chain, ifft;
	in = In.ar (2) * inamp;
	chain = FFT(LocalBuf(2048), in);
	chain = PV_BinShift(chain, {LFNoise1.kr (0.1).range (0.2, 12.4)} ! 10 );
	ifft = IFFT (chain) * 10;
	[
		Mix (
			ifft [0..4] collect: { | i, j |
				DelayC.ar (i, j + 1 * 2, 20) * LFNoise0.kr (0.1 rrand: 0.5)
			}
		),
		Mix (
			ifft [5..9] collect: { | i, j |
				DelayC.ar (i, j + 4.5 * 2, 20) * LFNoise1.kr (0.1 rrand: 0.5)
			}
		)
	];
} +> \test;

//:



{ | inamp = 1 |
	var in, chain, ifft;
	in = In.ar (2) * inamp;
	chain = FFT(LocalBuf(2048), in);
	chain = PV_BinShift(chain, {LFNoise1.kr (0.1).range (1.2, 2.4)} ! 10 );
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

//:

\test.set (\inamp, 0);

//:

\test