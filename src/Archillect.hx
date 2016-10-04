
#if sys

import sys.FileSystem;
import sys.io.File;
import sys.io.Process;
import haxe.Http;
import haxe.io.Bytes;
import neko.vm.Thread;
import Sys.print;
import Sys.println;

class Archillect {

	/**
		Retrieve archillect image url for given index.
	*/
	public static function getImageUrl( index : Int ) : String {
		var url = 'http://archillect.com/' + index;
		var html = Http.requestUrl( url );
		var line = StringTools.trim( html.split( '\n' )[18] );
		return line.substring( 17, line.length - 3 );
	}

	/**
		Download file and save it to given path.
	*/
	public static function downloadImage( url : String, path : String ) {
		File.saveBytes( path, Bytes.ofString( Http.requestUrl( url ) ) );
	}

	/**
	*/
	public static function downloadImageRange( start : Int, end : Int, dst : String, numThreads = 5, sleep = 0.0 ) {

		var download = function(i:Int){
			var url = getImageUrl(i); //urls[i-1];
			var name = url.substr( url.lastIndexOf('/')+1 );
			var fullPath = dst+'/'+i+'-'+name;
			if( !FileSystem.exists( fullPath ) ) {
				try downloadImage( url, fullPath ) catch(e:Dynamic) {
					if( sleep > 0.0 ) Sys.sleep( sleep );
					try downloadImage( url, fullPath ) catch(e:Dynamic) {
						return e;
					}
					println( i );
				}
			} else {

			}
			return null;
		}

		var numDownloads = end - start;
		if( numDownloads < numThreads ) numThreads = numDownloads;
		var numDownloadPerThread = Std.int( numDownloads / numThreads );
		var s = start;
		for( i in 0...numThreads ) {
			var t = Thread.create(function(){
				var main = Thread.readMessage(true);
				var start = Thread.readMessage(true);
				var num = Thread.readMessage(true);
				var end = start + num;
				for( i in start...end ) download(i);
				main.sendMessage('ok');
			});
			t.sendMessage( Thread.current() );
			t.sendMessage( s );
			t.sendMessage( numDownloadPerThread );
			s += numDownloadPerThread;
		}

		for( i in 0...numThreads ) {
			var result = Thread.readMessage(true);
			if( result != 'ok' ) {
				Sys.println( result );
				Sys.exit( 1 );
			} else {
				trace("TODO load more in new threads");
				Sys.exit( 1 );
			}
		}
	}

	/*
	static function downloadImageRange( start : Int, end : Int, path : String, numThreads = 5, pause = 0.0 ) {

		if( end < start )
			throw 'start index must be greater than end index';

		var urls = File.getContent( '$PATH/meta/uri' ).split('\n');

		var download = function(i:Int){
			var url = urls[i-1];
			var name = url.substr( url.lastIndexOf('/')+1 );
			var fullPath = path+'/'+i+'-'+name;
			if( !FileSystem.exists( fullPath ) ) {
				try downloadImage( url, fullPath ) catch(e:Dynamic) {
					Sys.sleep(10);
					try downloadImage( url, fullPath ) catch(e:Dynamic) {
						return e;
					}
				}
			}
			return null;
		}

		var numDownloads = end - start;
		if( numThreads > 1 ) {
			if( numDownloads < numThreads ) numThreads = numDownloads;
			var numUrlsPerThread = Std.int( numDownloads / numThreads );
			var s = start;
			for( i in 0...numThreads ) {
				var t = Thread.create(function(){
					var main = Thread.readMessage(true);
					var start = Thread.readMessage(true);
					var num = Thread.readMessage(true);
					var end = start + num;
					for( i in start...end ) download(i);
					main.sendMessage('ok');
				});
				t.sendMessage( Thread.current() );
				t.sendMessage( s );
				t.sendMessage( numUrlsPerThread );
				s += numUrlsPerThread;
			}

			for( i in 0...numThreads ) {
				var result = Thread.readMessage(true);
				if( result != 'ok' ) {
					Sys.println(result);
					Sys.exit(1);
				} else {
					trace("TODO load more in new threads");
				}
			}
		} else {
			for( i in start...end )
				download(i);
		}
	}
	*/

}

#end
