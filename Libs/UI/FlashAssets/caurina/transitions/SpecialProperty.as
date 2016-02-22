/**
 * SpecialProperty
 * A kind of a getter/setter for special properties
 *
 * @author		Zeh Fernando
 * @version		1.0.0
 */

class caurina.transitions.SpecialProperty {

	public var getValue:Function; // (p_obj:Object, p_parameters:Array): Number
	public var setValue:Function; // (p_obj:Object, p_value:Number, p_parameters:Array): Void
	public var parameters:Array;
	public var preProcess:Function; // (p_obj:Object, p_parameters:Array, p_originalValueComplete:Object, p_extra:Object): Number

	/**
	 * Builds a new special property object.
	 *
	 * @param		p_getFunction		Function	Reference to the function used to get the special property value
	 * @param		p_setFunction		Function	Reference to the function used to set the special property value
	 * @param		p_parameters		Array		Additional parameters that should be passed to the function when executing (so the same function can apply to different special properties)
	 */
	public function SpecialProperty (p_getFunction:Function, p_setFunction:Function, p_parameters:Array, p_preProcessFunction:Function) {
		getValue = p_getFunction;
		setValue = p_setFunction;
		parameters = p_parameters;
		preProcess = p_preProcessFunction;
	}

	/**
	 * Converts the instance to a string that can be used when trace()ing the object
	 */
	public function toString():String {
		var value:String = "";
		value += "[SpecialProperty ";
		value += "getValue:"+getValue.toString();
		value += ", ";
		value += "setValue:"+setValue.toString();
		value += ", ";
		value += "parameters:"+parameters.toString();
		value += ", ";
		value += "preProcess:"+preProcess.toString();
		value += "]";
		return value;
	}


}
