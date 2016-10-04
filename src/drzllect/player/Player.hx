package drzllect.player;

import js.Browser.console;
import js.Browser.document;
import js.Browser.window;
import js.html.Element;
import js.html.ImageElement;
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
import js.html.Uint8Array;
import om.Time;

class Player {

	public var canvas(default,null) : CanvasElement;
	//public var resolution : Float;
	//public var clearStage : Bool;

	var ctx : CanvasRenderingContext2D;
	var images : Array<ImageElement>;
	var currentIndex : Int;
	var lastVolume : Float;
	var framesPlayed : Int;

	public function new() {

		framesPlayed = 0;

		canvas = document.createCanvasElement();
		canvas.width = window.innerWidth;
		canvas.height = window.innerHeight;

		ctx = canvas.getContext2d();
		ctx.fillStyle = '#fff';
	}

	public function init( images : Array<ImageElement> ) {
		this.images = images;
		currentIndex = -1;
		lastVolume = 0;
	}

	public function update( volume : Float, frequency : Uint8Array ) {

		framesPlayed++;

		var img = images[framesPlayed-1];
		ctx.save();
		ctx.scale( window.innerWidth/img.width, window.innerHeight/img.height );
		ctx.drawImage( img, 0, 0 );
		ctx.restore();

		/*
		//TODO

		//trace(volume );
		//ctx.clearRect( 0, 0, canvas.width, canvas.height );

		var clearStage = false;
		//var changeFrame = true;
		//var changeFrameFactor = 0.0;

		if( volume < 0.003 ) {
			ctx.clearRect( 0, 0, canvas.width, canvas.height );
			return;
		}
		if( Math.random()* volume < 0.1 ) {
			return;
		}
		if( volume > 0.4 ) {
			ctx.fillStyle = '#fff';
			ctx.fillRect( 0, 0, canvas.width, canvas.height );
			return;
		}

		/*
		if( Math.abs(volume-lastVolume) < 0.01 ) {
			if( clearStage )
				ctx.clearRect( 0, 0, canvas.width, canvas.height );
			return;
		}
		* /

		lastVolume = volume;

		var nindex = images.length - Std.int( images.length * volume ) - 1;
		if( nindex != currentIndex ) {

			currentIndex = nindex;

			var img = images[currentIndex];
			ctx.clearRect(0,0,canvas.width, canvas.height);
			ctx.save();
			ctx.scale( window.innerWidth/img.width, window.innerHeight/img.height );
			ctx.drawImage( img, 0, 0 );
			ctx.restore();
		}

		/*
		ctx.fillStyle = '#fff';
		var sw = Std.int( canvas.width / frequency.length );
		for( i in 0...frequency.length ) {
			ctx.fillRect( i*sw, 0, 1, frequency[i] );
		}#*/
	}
}
