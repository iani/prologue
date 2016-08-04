

Server.default.boot;

Server.killAll;

{ SinOsc.ar ([400, 500], 0, 0.1).dup } +> \test;


{ SinOsc.ar (400, 0, 0.1).dup } +> \test;

Server.default.options.device = "ProFire 610";

Server.default.options.inspect;

// .device;

Server.default.options.class.devices;


Server.default.options.numOutputBusChannels;


{ In.ar (2) * 5.dup } +> \test;

Server.default.scope;


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
	fx = Resonz.ar (src, ([3, 7, 10, 17 ] + (60 - -20)).midicps, 0.01, 10);
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