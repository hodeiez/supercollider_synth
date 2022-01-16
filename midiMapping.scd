//midi mapping
(
var program;
var activenotes = nil!128; //make Array of 128 slots, initially with nil objects in to represent nothing
//#########

//#########

var releasefunction = {|index|



		//release existing note if present already

	if(activenotes[index].notNil) {

		activenotes[index].release; //will send gate=0

		activenotes[index] = nil; //make sure now empty slot ready

	}

	};
/*
~note_table = 0!127;
~n = ~note_table.selectIndices({|item, i| item != 0});
if (~n == []) { ~n = nil; };
*/
~resonCC=9;


~noize=Bus.control(s, 1);
~attack=Bus.control(s,1);
~sustain=Bus.control(s, 1);
~decay=Bus.control(s, 1);
~squareWet=Bus.control(s,2);
~detune=Bus.control(s,3);
~release=Bus.control(s,1);
~resonance=Bus.control(s,1);




if(~noize.isNil) {
	~noize.set(1);
};

MIDIdef.cc(\noize, { |val|

	~noize.set((val).midiratio/50);
},93);

///###################################################
if(~attack.isNil) {
	~attack.set(0.005);
};

MIDIdef.cc(\attack, { |val|

	~attack.set((val).midiratio/50);

},73);

//######################################################

if(~sustain.isNil) {
	~sustain.set(5);
};

//cc5
MIDIdef.cc(\sustain, { |val|

	~sustain.set(val.linlin(0,127,0.0,10));
},74);


//######################################################

if(~decay.isNil) {
	~decay.set(0);
};

//cc8
MIDIdef.cc(\decay, { |val|

	~decay.set(val.linlin(0,127,0.0,10));
},72);


//######################################################


if(~release.isNil) {
	~release.set(1);
};

MIDIdef.cc(\release, { |val|

	~release.set(val.linlin(0,127,0.0,10));
},71);


//######################################################

if(~squareWet.isNil) {
	~squareWet.set(0.5);
};

MIDIdef.cc(\squareWet, { |val|

	~squareWet.set(val.linlin(0,127,0.0,0.3));
},84);



//######################################################


if(~detune.isNil) {
	~detune.set(0);
};

//cc4
MIDIdef.cc(\detune, { |val|

	~detune.set(val.linlin(0,127,0,10));
},5);

//#################################

if(~resonance.isNil) {
	~resonance.set(200);
};

//cc4
MIDIdef.cc(\resonance, { |val|

~resonance.set(val.linexp(0,127,20,10000));
},~resonCC);

//create one Synth for every new note, with logic to check existing notes (though not MIDI channel sensitive)

MIDIIn.noteOn = { arg src,chan, midinote, velocity;

/*

~n = ~note_table.selectIndices({|item, i| item != 0}).postln;
~note_table[midinote] = 1;
*/
	"received".postln;

	releasefunction.value(midinote);

	//put active note in array; function above tidied any existing note on this key

	activenotes[midinote] = Synth(\sound,[\freq,midinote.midicps,\amp,velocity/127.0, \pinkamp,~noize.asMap, \attack,~attack.asMap,\sustain,~sustain.asMap,\decay,~decay.asMap,\squareWet,~squareWet.asMap,\detune,~detune.asMap,\release,~release.asMap,\resonanz,~resonance.asMap]);



	};
//MIDIFunc.cc( { arg val; Synth(\sound).set( \pinkamp, val*40 ) }, 7, 0, 1310720 );


//must also look for note offs as indicated end of held note

MIDIIn.noteOff = { arg src,chan, midinote, velocity;
/*
  ~right = Pbind(
		\instrument, \sound,
        \midinote, Plazy {
            var n0, n1, n2;
            ~n = ~n ?? [Rest(1)];
            n0 = ~n[0] ?? Rest(1);
            n1 = ~n[1] ?? ~n[0];
            n2 = ~n[2] ?? ~n[0];
            Pxrand([ n0, n2, n1, n2 ] ++  (([ n0, n2, n1, n2 ] + 12)!2).flatten)
        },
        \dur, Pseq([1, 1, 1, 1, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5 ].normalizeSum*2),\sustain,2,\release,0.3,\resonanz,1000,\attack,0.005,
    );
    ~left = Pbind(
        \instrument, \sound,
        \midinote, Plazy {
            var n0, n1, n2;
            ~n = ~n ?? [Rest(1)];
            n0 = ~n[0] ?? Rest(1);
            n1 = ~n[1] ?? ~n[0];
            n2 = ~n[2] ?? ~n[0];
            Pseq([ n0, n2, n0, n2, n0, n2, n0, n2] - 12)
        },
        \dur, Pseq([1, 1, 1, 1, 1, 1, 1, 1].normalizeSum*2)
    );
    if (~player.notNil) { ~player.stop; };
    ~player = Pn(Ppar([~right,~left])).play;
*/

	releasefunction.value(midinote);

	};


)