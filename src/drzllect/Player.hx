package drzllect;

import js.Browser.console;
import js.Browser.document;
import js.Browser.window;
import js.html.Element;
import js.html.ImageElement;
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
import js.html.Uint8Array;
import js.html.audio.AudioContext;
import js.html.audio.AnalyserNode;
import om.Time;
import om.audio.VolumeMeter;

class Player {

	static var audio : AudioContext;
	static var analyser : AnalyserNode;
	static var bufferLength : Int;
	static var frequencyData : Uint8Array;
	static var timeDomainData : Uint8Array;
	static var meter : VolumeMeter;
	static var maxVolume = 0.0;
	static var lastVolume = 0.0;

	static var canvas : CanvasElement;
	static var ctx : CanvasRenderingContext2D;

	//static var logElement : Element;

	//static var currentImage : ImageElement;
	//static var currentImageIndex : Int;
	//static var sleepTime = 0.0;
	//static var sleepStart = 0.0;
	static var sleepStart = 0.0;

	static function update( time : Float ) {

		window.requestAnimationFrame( update );

		analyser.getByteFrequencyData( frequencyData );
		//analyser.getByteTimeDomainData( timeDomainData );

		//ctx.clearRect( 0, 0, canvas.width, canvas.height );
		ctx.fillStyle = '#fff';

		/*
		var sum = 0.0;
		for( i in 0...frequencyData.length ) {
			sum += frequencyData[i];
		}
		var f = sum / frequencyData.length;
		trace(f);
		*/

		//trace(meter.rms);

		/*
		var sum = 0.0;
		for( i in 0...100 ) {
			sum += frequencyData[i];
		}
		var averageLow = sum/100;
		sum = 0.0;
		for( i in 100...1024 ) {
			sum += frequencyData[i];
		}
		var averageHigh = sum/924;

		trace(averageLow);
		*/

		//if( Math.random() * meter.rms > 0.1 ) {
		var index = images.length - Std.int( images.length * meter.rms ) - 1;
		trace(index);
		var img = images[index];
		ctx.clearRect(0,0,canvas.width, canvas.height);
		ctx.save();
		ctx.scale( window.innerWidth/img.width, window.innerHeight/img.height );
		ctx.drawImage( img, 0, 0 );
		ctx.restore();

		/*
		var sliceWidth = Std.int(canvas.width * 1.0 / bufferLength);
		for( i in 0...frequencyData.length ) {
			//ctx.fillRect( i*sliceWidth, 0, 1, frequencyData[i] / 256 * canvas.height );
		}
		*/

		//lastVolume = volPercent;
	}

	static var maxImages = 100;
	static var images = new Array<ImageElement>();
	static var loaded = 0;
	static var timeStart : Float;

	static function loadRange( start : Int, end : Int, callback : Void->Void ) {
		images = new Array<ImageElement>();
		var loadNext : Void->Void;
		loadNext = function(){
			var img = document.createImageElement();
			img.src = '/archillect/'+(start + images.length)+'.jpg';
			img.onload = function(){
				images.push(img);
				if( images.length < (end - start) ) {
					loadNext();
				} else {
					callback();
				}
			}
		}
		loadNext();
	}

	static function handleUserMedia( stream ) {

		//document.body.textContent += '\nINITIALIZING AUDIO';
		//log( 'initializing audio' );

		audio = new AudioContext();

		var mic = audio.createMediaStreamSource( stream );

		analyser = audio.createAnalyser();
		//analyser.connect( audio.destination );
		mic.connect( analyser );

		meter = new om.audio.VolumeMeter( audio );
		mic.connect( meter.processor );

		bufferLength = analyser.frequencyBinCount;
		frequencyData = new Uint8Array( bufferLength );
		timeDomainData = new Uint8Array( bufferLength );

		//var offlineContext = new OfflineAudioContext( 1, buf.length, buf.sampleRate );
		//var filter = audio.createBiquadFilter();
		//filter.type = LOWPASS;
		//filter.connect( audio.destination );

		//window.requestAnimationFrame( update );

		//document.body.textContent += '\nLOADING IMAGES';

		loadRange(0,3600,function(){

			trace(images.length);

			//log( 'READY' );
			//logElement.style.display = 'none';

			window.requestAnimationFrame( update );
		});
	}

	static function handleWindowResize(e) {
		canvas.width = window.innerWidth;
		canvas.height = window.innerHeight;
	}

	static function main() {

		untyped navigator.getUserMedia = navigator.getUserMedia || navigator.webkitGetUserMedia || navigator.mozGetUserMedia;

		window.onload = function(e) {

			document.body.innerHTML = '';

			canvas = document.createCanvasElement();
			canvas.width = window.innerWidth;
			canvas.height = window.innerHeight;
			document.body.appendChild( canvas );

			ctx = canvas.getContext2d();

			window.addEventListener( 'resize', handleWindowResize, false );

			untyped navigator.getUserMedia( { audio:true },
				function(){
					
					audio = new AudioContext();

					var mic = audio.createMediaStreamSource( stream );

					analyser = audio.createAnalyser();
					//analyser.connect( audio.destination );
					mic.connect( analyser );

					meter = new om.audio.VolumeMeter( audio );
					mic.connect( meter.processor );

					bufferLength = analyser.frequencyBinCount;
					frequencyData = new Uint8Array( bufferLength );
					timeDomainData = new Uint8Array( bufferLength );
				},
				function(e) {
					console.error(e);
					document.body.textContent = e;
				}
			);
		}
	}
}
