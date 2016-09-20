package drzllect;

import js.Browser.document;
import js.html.ImageElement;

using haxe.io.Path;

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

	/*
	function loadImage() {
		var img = document.createImageElement();
		img.onload = function(){
			if( onLoadCallback != null ) {
				onLoadCallback( img );
			}
			if()
		}
		img.src = path;
	}
	*/

	/*
	public function onLoad( callback : ImageElement->Void ) {
		this.onLoadCallback = callback;
		return this;
	}
	*/

	public inline function onComplete( callback : Array<ImageElement>->Void ) {
		this.onCompleteCallback = callback;
		return this;
	}

	public inline function onError( callback : String->Void ) {
		this.onErrorCallback = callback;
		return this;
	}

}
