/**
 * ...
 * @author RuneRask
 *
 *  Class for adding additional functinality for scoping issues in AS2.
 *  Enables you to delegate a function with several paremeters to stay
 *  within the scope of the document it is used in.
 */


class cryflash.Delegates {
    public static function create(target:Object, method:Function):Function {
        var _arguments:Array = arguments.slice(2);
        var _function:Function = function ():Void {
            var _newArguments:Array = arguments.concat(_arguments);
            method.apply(target, _newArguments);
        };
        return _function;
    }
}