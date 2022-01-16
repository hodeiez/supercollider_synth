
//revermix controlled by MouserY
s.waitForBoot(
SynthDef(\longReverb, {| delaytime=0.01, decaytime=1|

var input;

var numc,numa,temp;
var mix;

input=In.ar(0,2); //get two channels of input starting (and ending) on bus 0


numc = 4; // number of comb delays

numa = 16; // number of allpass delays


// reverb predelay time :

temp = DelayN.ar(input, 0.048,0.048);


temp=Mix.fill(numc,{CombL.ar(temp,0.1,rrand(0.01, 0.1),5)});


	//mix=MouseY.kr(0.005,1,1);
	mix=decaytime;
	//mix=1;
// chain of 4 allpass delays on each of two channels (8 total) :

numa.do({ temp = AllpassN.ar(temp, 0.051, [rrand(0.01, 0.05),rrand(0.01, 0.05)], 1) });



Out.ar(0, FreeVerb.ar(
		(mix*temp),
            1,
            1,
            0.9,1
	))
}).add;

)