Server.killAll
//I use ASIO4ALL!!
(Server.default.options.device_("ASIO4ALL v2");
s.boot;
s.latency(0.5);

//s.sync;
~reverMixCC=10;
~delayTCC=12;
~delayMixCC=14;
~delayDecayCC=17;
MIDIClient.init;
MIDIIn.connectAll;
MIDIFunc.cc({|val,ccNum|[val,ccNum].postln;});

"myOscillator.scd".loadRelative;
s.waitForBoot(
"myReverb.scd".loadRelative;
	"myDelay.scd".loadRelative;


y= Synth.tail(a,\longReverb);
//EXPERIMENTS
~reverb=Bus.control(s,1);
if(~reverb.isNil) {
	~reverb.set(0);
};

//cc4
MIDIdef.cc(\betune, { |val|

	~reverb.set(val.linlin(0,127,0,1));
},~reverMixCC);

y.set(\decaytime,~reverb.asMap);


~delay=Synth.tail(a,\myDelay);

~delayT=Bus.control(s,1);
if(~delayT.isNil) {
	~delayT.set(0);
};


MIDIdef.cc(\delayT, { |val|

	~delayT.set(val.linexp(0,127,0.005,10));
},~delayTCC);

~delayMix=Bus.control(s,1);
if(~delayMix.isNil) {
	~delayMix.set(0);
};


MIDIdef.cc(\delayMix, { |val|

	~delayMix.set(val.linlin(0,127,0.005,1.8));
},~delayMixCC);

~delayDecay=Bus.control(s,1);


if(~delayDecay.isNil) {
	~delayDecay.set(0);
};


MIDIdef.cc(\delayDecay, { |val|

	~delayDecay.set(val.linexp(0,127,0.1,200));
},~delayDecayCC);




~delay.set(\delayT,~delayT.asMap);

~delay.set(\amp,~delayMix.asMap);

~delay.set(\decay,~delayDecay.asMap);
);

"midiMapping.scd".loadRelative;
)
z=Synth.tail(a,"myDelay",[\delayT,0.2]);
z.free;

//GUI
(
var w,delayTimeKnob,delayDecayKnob,delay,dTimeText,dDecayText,dMixKnob,dMixText;
w = Window.new("gui", Rect(100, 100, 360, 360)).front;
//DELAY######################
delay=Synth.tail(a,\myDelay);

dTimeText=StaticText(w,Rect(20,147, 46,16));
dTimeText.background=Color.yellow;
dTimeText.string="D time";
dTimeText.align=\center;

dDecayText=StaticText(w,Rect(70,147, 46,16));
dDecayText.background=Color.yellow;
dDecayText.string="D decay";
dDecayText.align=\center;

dMixText=StaticText(w,Rect(120,147, 46,16));
dMixText.background=Color.yellow;
dMixText.string="D Mix";
dMixText.align=\center;

dMixKnob=Knob(w,Rect(126,107, 36,36));
dMixKnob.action={delay.set(\amp,dMixKnob.value)}
;
delayTimeKnob=Knob(w, Rect(26,107, 36,36))
;
delayTimeKnob.action={delay.set(\delayT,delayTimeKnob.value.linexp(0.0,0.1,0.005,1))}
;

delayDecayKnob=Knob(w, Rect(76,107, 36,36))
;
delayDecayKnob.action={delay.set(\decay,delayDecayKnob.value.linexp(0.0,1.0,0.1,200))};
//#############################################

PopUpMenu(w, Rect(50,229, 128,32))
;)


//some patterns for test
(p = Pbind(
	\instrument, \sound,

    \scale, #[0, 2, 3, 5, 7, 8, 10],
    \root, -12,
    \degree, Pseq(#[rest, 4, 3, 4, 2, 4, 1, 4, 0, 4, -0.9, 4, 0, 4, 1, 4, 2, 4,
        -3, 4, -1.9, 4, -0.9, 4, 0, 4, -0.9, 4, 0, 4, 1, 4, 2], 1),
    \dur, 0.25
).play;)
p.stop;
(
t = Task({
    loop {
        [60, 62, 64, 65, 67, 69, 71, 72].do({ |midi|
            Synth(\sound, [freq: midi.midicps, amp: 0.2, sustain: 0.0]);
            1.125.wait;
        });
    }
}).play;
)
t.stop;