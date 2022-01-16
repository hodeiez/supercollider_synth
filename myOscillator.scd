
(
SynthDef(\sound,{ |freq=440, amp=0.07, gate=1, pinkamp=0.4, attack=0.005,decay=1,release=4.8,sustain=5.0,squareWet=0.5,detune=0,resonanz=500|

	var saw, filter,env,pan;



	saw= SawDPW.ar(freq,0,1)+SawDPW.ar(freq+detune,0.4,1) +SinOsc.ar(freq+detune,0.4,0.1)+ PinkNoise.ar(pinkamp,0.01*detune) + PulseDPW.ar(freq/2,squareWet);

	filter= Resonz.ar(saw,resonanz,0.1)*amp;


	env= EnvGen.ar(Env.adsr(attack,decay,sustain,release),gate,doneAction:2);

	pan=Pan2.ar(saw,0,1);

Out.ar(0,(filter*env).dup(2))

}).add

)
