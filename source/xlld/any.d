module xlld.any;


struct Any {
    import xlld.xlcall: XLOPER12;

    package XLOPER12 _impl;
    alias _impl this;

    string toString() @trusted const {
        import std.conv: text, to;
        import xlld.xlcall: XlType;
        import xlld.wrap: fromXlOper;
        import xlld.memorymanager: gMemoryPool;

        scope(exit) gMemoryPool.deallocateAll;

        string ret = text("Any(", );
        switch(_impl.xltype) {
        default:
            ret ~= _impl.xltype.to!string;
            break;
        case XlType.xltypeStr:
            ret ~= text(`"`, _impl.fromXlOper!string(gMemoryPool), `"`);
            break;
        case XlType.xltypeNum:
            ret ~= _impl.fromXlOper!double(gMemoryPool).to!string;
            break;
        }
        return ret ~ ")";
    }
}


auto any(T, A)(auto ref T value, auto ref A allocator) @trusted {
    import xlld.wrap: toXlOper;
    return Any(value.toXlOper(allocator));
}
