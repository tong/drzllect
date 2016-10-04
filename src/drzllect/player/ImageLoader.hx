package drzllect.player;

import js.Browser.document;
import js.Browser.window;
import js.html.ImageElement;

using haxe.io.Path;

class ImageLoader {

	public var path(default,null) : String;

	//var onLoadCallback : ImageElement->Void;
	//var onCompleteCallback : Array<ImageElement>->Void;
	//var onErrorCallback : String->Void;

	public function new( path : String ) {
		this.path = path.removeTrailingSlashes();
	}

	public function start( start : Int, end : Int, callback : Array<ImageElement>->Void ) {

		var numImagesToLoad = end - start;
		var loaded = new Array<ImageElement>();

		/*
		var worker = new js.html.Worker( 'script/loader.js' );
		worker.onmessage = function(e){
			var img = document.createImageElement();
			img.src = js.html.URL.createObjectURL( e.data.result );
			img.onload = function(e){
				loaded.push( img );
				if( loaded.length == numImagesToLoad )
					callback( loaded );
			}
		}
		worker.postMessage( { path: path, start: start, end: end } );
		*/

		for( i in start...end ) {
			var img = document.createImageElement();
			img.src = path+'/'+(i)+'.jpg';
			img.onload = function(){
				loaded.push( img );
				if( loaded.length < numImagesToLoad ) {
					//onLoadCallback( img );
					//loadNext();
				} else {
					callback( loaded );
				}
			}
		}
		/*
		var images = new Array<ImageElement>();
		//var nLoaded = 0;
		var loadNext : Void->Void;
		loadNext = function(){
			var img = document.createImageElement();
			img.src = path+'/'+(images.length)+'.jpg';
			img.onload = function(){
				images.push(img);
				if( images.length < numImagesToLoad ) {
					//onLoadCallback( img );
					loadNext();
				} else {
					callback( images );
				}
			}
		}
		loadNext();
		*/


		return this;
	}

	/*
	public function start( n : Int ) {
		var images = new Array<ImageElement>();
		//var nLoaded = 0;
		var loadNext : Void->Void;
		loadNext = function(){
			var img = document.createImageElement();
			img.src = path+'/'+(images.length)+'.jpg';
			img.onload = function(){
				images.push(img);
				if( images.length < n ) {
					//onLoadCallback( img );
					loadNext();
				} else {
					onCompleteCallback( images );
				}
			}
		}
		loadNext();
		return this;
	}
	*/

	/*
	public inline function onComplete( callback : Array<ImageElement>->Void ) {
		this.onCompleteCallback = callback;
		return this;
	}

	public inline function onError( callback : String->Void ) {
		this.onErrorCallback = callback;
		return this;
	}
	*/

}
/*
class ImageLoader {

	public var path(default,null) : String;

	//var onLoadCallback : ImageElement->Void;
	var onCompleteCallback : Array<ImageElement>->Void;
	var onErrorCallback : String->Void;

	public function new( path : String ) {
		this.path = path.removeTrailingSlashes();
	}

	public function start( n : Int ) {
		var images = new Array<ImageElement>();
		//var nLoaded = 0;
		var loadNext : Void->Void;
		loadNext = function(){
			var img = document.createImageElement();
			img.src = path+'/'+(images.length)+'.jpg';
			img.onload = function(){
				images.push(img);
				if( images.length < n ) {
					//onLoadCallback( img );
					loadNext();
				} else {
					onCompleteCallback( images );
				}
			}
		}
		loadNext();
		return this;
	}

	public inline function onComplete( callback : Array<ImageElement>->Void ) {
		this.onCompleteCallback = callback;
		return this;
	}

	public inline function onError( callback : String->Void ) {
		this.onErrorCallback = callback;
		return this;
	}

}
*/
