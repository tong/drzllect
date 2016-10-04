package drzllect.player;

import js.Browser.console;
import js.Browser.document;
import js.Browser.window;
import js.html.Element;
import js.html.Uint8Array;
import js.html.audio.AudioContext;
import js.html.audio.AnalyserNode;
import om.Time;
import om.audio.VolumeMeter;

class App {

	static var audio : AudioContext;
	static var analyser : AnalyserNode;
	static var bufferLength : Int;
	static var frequencyData : Uint8Array;
	static var timeDomainData : Uint8Array;
	static var meter : VolumeMeter;
	static var player : Player;

	static function update( time : Float ) {

		window.requestAnimationFrame( update );

		analyser.getByteFrequencyData( frequencyData );
		//analyser.getByteTimeDomainData( timeDomainData );

		//var peaks = om.audio.PeakMeter.getPeaks( audio.source, subRanges );
		//trace(analyser.minDecibels,analyser.maxDecibels);

		player.update( meter.vol, frequencyData );
	}

	static function handleWindowResize(e) {
		player.canvas.width = window.innerWidth;
		player.canvas.height = window.innerHeight;
	}

	static function initAudioInput( callback : Void->Void ) {

		untyped navigator.getUserMedia( { audio:true },

			function( stream ){

				audio = new AudioContext();

				var input = audio.createMediaStreamSource( stream );

				//var filter = audio.createBiquadFilter();
				//filter.type = LOWPASS;
				//input.connect( filter );

				analyser = audio.createAnalyser();
				analyser.fftSize = 128;

				input.connect( analyser );
				//filter.connect( analyser );
				//filter.connect( analyser );

				bufferLength = analyser.frequencyBinCount;
				frequencyData = new Uint8Array( bufferLength );
				timeDomainData = new Uint8Array( bufferLength );

				//analyser.connect( audio.destination );

				meter = new om.audio.VolumeMeter( audio );
				input.connect( meter.processor );

				callback();
			},

			function(e) {
				console.error( e );
				document.body.classList.add( 'error' );
				document.body.textContent = e.toString();
			}
		);
	}

	static function main() {

		untyped navigator.getUserMedia = navigator.getUserMedia || navigator.webkitGetUserMedia || navigator.mozGetUserMedia;

		window.onload = function(e) {

			document.body.innerHTML = '';

			initAudioInput( function(){

				var loader = new ImageLoader( 'http://localhost/archillect/' );
				loader.start( 0, 3599, function(images){

					/*
					for( img in images ) {
						document.body.appendChild( img );
					}
					*/

					player = new Player();
					document.body.appendChild( player.canvas );

					player.init( images);
					window.requestAnimationFrame( update );
				});
			});


			/*
			player = new Player();
			document.body.appendChild( player.canvas );

			untyped navigator.getUserMedia = navigator.getUserMedia || navigator.webkitGetUserMedia || navigator.mozGetUserMedia;
			untyped navigator.getUserMedia( { audio:true },
				function( stream ){

					audio = new AudioContext();

					var input = audio.createMediaStreamSource( stream );

					//var filter = audio.createBiquadFilter();
					//filter.type = LOWPASS;
					//input.connect( filter );

					analyser = audio.createAnalyser();
					analyser.fftSize = 128;

					input.connect( analyser );
					//filter.connect( analyser );
					//filter.connect( analyser );

					bufferLength = analyser.frequencyBinCount;
					frequencyData = new Uint8Array( bufferLength );
					timeDomainData = new Uint8Array( bufferLength );

					//analyser.connect( audio.destination );

					meter = new om.audio.VolumeMeter( audio );
					input.connect( meter.processor );

					var loader = new ImageLoader( '/archillect' );
					loader.onComplete(function(images){
						trace("PLAYER");
						player.init( images);
						window.requestAnimationFrame( update );
					//}).start( 3600 );
					}).start( 36 );
				},
				function(e) {
					console.error( e );
					document.body.classList.add( 'error' );
					document.body.textContent = e.toString();
				}
			);

			window.addEventListener( 'resize', handleWindowResize, false );
			*/
		}
	}
}
