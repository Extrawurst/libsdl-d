void main()
{
    import std.file : dirEntries, SpanMode;
    import std.path : extension;
    import std.process : execute;
    import std.stdio;

    foreach (sample; dirEntries("./test/sample_files/", SpanMode.breadth))
    {
        if (sample.isFile() && extension(sample.name) == ".sdl")
        {
            writef("Trying to parse %s .. ", sample.name);
            auto process = execute(["./cli/sdlparse", "parse", sample.name]);

            if (process.status != 0)
            {
                writeln("[FAIL]");
                throw new Exception("\n\t" ~ process.output);
            }

            writeln("[OK]");
        }
    }
}