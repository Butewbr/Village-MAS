// CArtAgO artifact code for project main

package village;

import cartago.*;

public class Village extends Artifact {
	void init(int initialValue) {
		defineObsProperty("count", initialValue);
	}

	@OPERATION
	void inc() {
		ObsProperty prop = getObsProperty("count");
		prop.updateValue(prop.intValue()+1);
		signal("tick");
	}

	@OPERATION
	void inc_get(int inc, OpFeedbackParam<Integer> newValueArg) {
		ObsProperty prop = getObsProperty("count");
		int newValue = prop.intValue()+inc;
		prop.updateValue(newValue);
		newValueArg.set(newValue);
	}

}

