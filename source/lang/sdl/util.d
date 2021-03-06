// SDLang-D
// Written in the D programming language.

module lang.sdl.util;

import std.algorithm;
import std.datetime;
import std.stdio;
import std.string;

import lang.sdl.token;

enum sdlangVersion = "0.8.4";

alias immutable(ubyte)[] ByteString;

auto startsWith(T)(string haystack, T needle)
	if( is(T:ByteString) || is(T:string) )
{
	return std.algorithm.startsWith( cast(ByteString)haystack, cast(ByteString)needle );
}

struct Location
{
	string file; /// Filename (including path)
	int line; /// Zero-indexed
	int col;  /// Zero-indexed, Tab counts as 1
	size_t index; /// Index into the source
	
	this(int line, int col, int index)
	{
		this.line  = line;
		this.col   = col;
		this.index = index;
	}
	
	this(string file, int line, int col, int index)
	{
		this.file  = file;
		this.line  = line;
		this.col   = col;
		this.index = index;
	}
	
	string toString()
	{
		return "%s(%s:%s)".format(file, line+1, col+1);
	}
}

void removeIndex(E)(ref E[] arr, ptrdiff_t index)
{
	arr = arr[0..index] ~ arr[index+1..$];
}

void trace(string file=__FILE__, size_t line=__LINE__, TArgs...)(TArgs args)
{
	version(sdlangTrace)
	{
		writeln(file, "(", line, "): ", args);
		stdout.flush();
	}
}

string toString(TypeInfo ti)
{
	if     (ti == typeid( bool         )) return "bool";
	else if(ti == typeid( string       )) return "string";
	else if(ti == typeid( dchar        )) return "dchar";
	else if(ti == typeid( int          )) return "int";
	else if(ti == typeid( long         )) return "long";
	else if(ti == typeid( float        )) return "float";
	else if(ti == typeid( double       )) return "double";
	else if(ti == typeid( real         )) return "real";
	else if(ti == typeid( Date         )) return "Date";
	else if(ti == typeid( DateTimeFrac )) return "DateTimeFrac";
	else if(ti == typeid( DateTimeFracUnknownZone )) return "DateTimeFracUnknownZone";
	else if(ti == typeid( SysTime      )) return "SysTime";
	else if(ti == typeid( Duration     )) return "Duration";
	else if(ti == typeid( ubyte[]      )) return "ubyte[]";
	else if(ti == typeid( typeof(null) )) return "null";
	
	return "{unknown}";
}
