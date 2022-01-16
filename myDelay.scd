/*(SynthDef("myDelay", { arg delay = 0.75;


    Out.ar(
        0,
        DelayC.ar(
            In.ar(0, 2),
            delay,
           delay,
        )
    )



}).add;
)*/
s.waitForBoot(
SynthDef(\myDelay, {
	|in=0, out=0, mix=(0.5), decay=100, delayT=0.75,amp=1, delHz=0.25, delMin=0.1, delMax=0.4|
	var sig, delay;
	sig = In.ar(in, 2);
	delay=CombL.ar(sig,10,delayT,decay);

	sig=XFade2.ar(sig,delay,mix)*amp;
	Out.ar(out,sig);
}).add;
)