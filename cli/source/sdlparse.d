import lang.sdl;

import std.array;
import std.datetime;
import std.file;
import std.stdio;

int main(string[] args)
{
    if(
        args.length != 3 ||
        (args[1] != "lex" && args[1] != "parse" && args[1] != "to-sdl")
    )
    {
        stderr.writeln("SDLang-D v", sdlangVersion);
        stderr.writeln("Usage: sdlang [lex|parse|to-sdl] filename.sdl");
        return 1;
    }
    
    auto filename = args[2];

    try
    {
        if(args[1] == "lex")
            doLex(filename);
        else if(args[1] == "parse")
            doParse(filename);
        else
            doToSDL(filename);
    }
    catch(SDLangParseException e)
    {
        stderr.writeln(e.msg);
        return 1;
    }
    
    return 0;
}

void doLex(string filename)
{
    auto source = cast(string)read(filename);
    auto lexer = new Lexer(source, filename);
    
    foreach(tok; lexer)
    {
        // Value
        string value;
        if(tok.symbol == symbol!"Value")
            value = tok.value.hasValue? toString(tok.value.type) : "{null}";
        
        value = value==""? "\t" : "("~value~":"~tok.value.toString()~") ";

        // Data
        auto data = tok.data.replace("\n", "").replace("\r", "");
        if(data != "")
            data = "\t|"~tok.data~"|";
        
        // Display
        writeln(
            tok.location.toString, ":\t",
            tok.symbol.name, value,
            data
        );
        
        if(tok.symbol.name == "Error")
            break;
    }
}

void doParse(string filename)
{
    auto root = parseFile(filename);
    stdout.rawWrite(root.toDebugString());
    writeln();
}

void doToSDL(string filename)
{
    auto root = parseFile(filename);
    stdout.rawWrite(root.toSDLDocument());
}
