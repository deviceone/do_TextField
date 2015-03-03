package extdefine;

import core.object.DoUIModule;
import core.object.DoProperty;
import core.object.DoProperty.PropertyDataType;


public abstract class Do_TextField_MAbstract extends DoUIModule{

	protected Do_TextField_MAbstract() throws Exception {
		super();
	}
	
	/**
	 * 初始化
	 */
	@Override
	public void onInit() throws Exception{
        super.onInit();
        //注册属性
		this.registProperty(new DoProperty("text", PropertyDataType.String, "", false));
		this.registProperty(new DoProperty("fontColor", PropertyDataType.String, "000000", false));
		this.registProperty(new DoProperty("fontSize", PropertyDataType.Number, "9", false));
		this.registProperty(new DoProperty("fontStyle", PropertyDataType.String, "normal", false));
		this.registProperty(new DoProperty("hint", PropertyDataType.String, "", true));
		this.registProperty(new DoProperty("inputType", PropertyDataType.String, "", true));
		this.registProperty(new DoProperty("password", PropertyDataType.Bool, "false", true));
		this.registProperty(new DoProperty("clearAll", PropertyDataType.Bool, "false", true));
	}
}