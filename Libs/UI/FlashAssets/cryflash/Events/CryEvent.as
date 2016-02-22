/**
 * ...
 * @author RuneRask
 * refactoring/cleanup by ManuelB (April 10 2014)
 */
class cryflash.Events.CryEvent {
    public static var CHANGE:String = "change";
    public static var CLOSE:String = "close";
    public static var COMPLETE:String = "complete";
    public static var ACCEPTED:String = "accepted";
    public static var DECLINED:String = "declined";
    public static var ON_RELEASE:String = "on_release";
    public static var ON_ACTION:String = "on_action";
    public static var ON_ROLLOVER:String = "on_rollover";
    public static var ON_ROLLOUT:String = "on_rollout";
    public var type;
    public var target;

    public function CryEvent(type, target) {
        this.type = type;
        this.target = target;
    }

    public function toString():String {
        return "[Event target= " + target + " type= " + type + "]";
    }
}