
#if sys

import sys.FileSystem;
import sys.io.File;
import sys.io.Process;
import haxe.Http;
import haxe.io.Bytes;
import neko.vm.Thread;
import Sys.print;
import Sys.println;

using StringTools;

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

	/**
		Sort images by brightness.
	*/
	public static function sortByBrightness( srcDir : String, dstDir : String ) {

		var imagePaths = FileSystem.readDirectory( srcDir );
		//imagePaths.sort( sortImageFiles );

		var imageColors = new Array<Int>();
		var nStart = 0;
		var n = 3600;

		//for( i in 0...imagePaths.length ) {
		for( i in 0...n ) {
			var file = imagePaths[i];
			var path = '$srcDir/$file';
			var identify = new Process( 'convert', [path,'-resize','1x1!','-format','"%[fx:int(255*r+.5)],%[fx:int(255*g+.5)],%[fx:int(255*b+.5)]"','info:'] );
			var result = identify.stdout.readAll();
			var error = identify.stderr.readAll().toString();
			if( error != "" ) {
				trace(error.toString());
				return;
			} else {
				var val = result.toString().trim();
				var val = val.substr( 1 );
				val = val.substr( 0, val.indexOf('"') );
				var rgb = val.split(',');
				var brightness = ((Std.parseInt(rgb[0]) & 0xFF) << 16) | ((Std.parseInt(rgb[1]) & 0xFF) << 8) | ((Std.parseInt(rgb[2]) & 0xFF) << 0);
				imageColors.push( brightness );

				println(i);

				//out.append( brightness );
			}
			identify.close();

			//if( numImages++ == _max ) break;
			if( i % 100 == 0 ) Sys.sleep(1);
			if( i % 1000 == 0 ) Sys.sleep(5);
		}

		Sys.println( ">" );

		var sortedImagePaths = new Array<String>();
		var sortedImageColors = new Array<Int>();

		//for( i in 0...imagePaths.length ) {
		for( i in 0...n ) {
			if( i == 0 ) {
				sortedImagePaths.push( imagePaths[0] );
				sortedImageColors.push( imageColors[0] );
			} else {
				var f1 = imagePaths[i];
				var v1 = imageColors[i];
				var inserted = false;
				for( j in 0...sortedImageColors.length ) {
					var v2 = sortedImageColors[j];
					if( v1 > v2 ) {
						sortedImagePaths.insert( j, f1 );
						sortedImageColors.insert( j, v1 );
						inserted = true;
						break;
					}
				}
				if( !inserted ) {
					sortedImagePaths.push( f1 );
					sortedImageColors.push( v1 );
				}
			}
		}

		for( i in 0...sortedImagePaths.length ) {
			//trace( srcDir+'/'+sortedImagePaths[i], '$dstDir/$i.jpg' );
			File.copy( srcDir+'/'+sortedImagePaths[i], '$dstDir/$i.jpg' );
		}
	}

	static inline function sortIntArray( a : Int, b : Int ) : Int {
		return (a > b) ? 1 : (a < b) ? -1 : 0;
	}

	static inline function getImageId( name : String ) : Int {
		return Std.parseInt( name.substr( 0, name.indexOf( '-' ) ) );
	}

	static function sortImageFiles( a : String, b : String ) : Int {
		var i = getImageId(a);
		var j = getImageId(b);
		return (i > j) ? 1 : (i < j) ? -1 : 0;
	}

}

#end
