// CArtAgO artifact code for project main

package village;

import cartago.*;

public class Village extends Artifact {
	void init(int initialValue) {
		
	}

	@OPERATION
	void inc_get(int inc, OpFeedbackParam<Integer> newValueArg) {
		ObsProperty prop = getObsProperty("count");
		int newValue = prop.intValue()+inc;
		prop.updateValue(newValue);
		newValueArg.set(newValue);
	}

}

