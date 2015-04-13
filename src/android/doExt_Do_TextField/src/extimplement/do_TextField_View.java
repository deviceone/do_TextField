package extimplement;

import java.util.Map;

import android.R.drawable;
import android.content.Context;
import android.graphics.drawable.Drawable;
import android.text.Editable;
import android.text.InputType;
import android.text.TextWatcher;
import android.util.TypedValue;
import android.view.MotionEvent;
import android.view.View;
import android.view.View.OnFocusChangeListener;
import android.widget.EditText;
import core.helper.DoTextHelper;
import core.helper.DoUIModuleHelper;
import core.helper.jsonparse.DoJsonNode;
import core.interfaces.DoIScriptEngine;
import core.interfaces.DoIUIModuleView;
import core.object.DoInvokeResult;
import core.object.DoUIModule;
import extdefine.do_TextField_IMethod;
import extdefine.do_TextField_MAbstract;

/**
 * 自定义扩展UIView组件实现类，此类必须继承相应VIEW类，并实现DoIUIModuleView,Do_TextField_IMethod接口；
 * #如何调用组件自定义事件？可以通过如下方法触发事件：
 * this.model.getEventCenter().fireEvent(_messageName, jsonResult);
 * 参数解释：@_messageName字符串事件名称，@jsonResult传递事件参数对象； 获取DoInvokeResult对象方式new
 * DoInvokeResult(this.model.getUniqueKey());
 */
public class do_TextField_View extends EditText implements DoIUIModuleView, do_TextField_IMethod, OnFocusChangeListener, TextWatcher {
	private static final String INPUT_TYPE_ASC = "ASC"; // 支持ASCII的默认键盘
	private static final String INPUT_TYPE_PHONENUMBER = "PHONENUMBER"; // 标准电话键盘，支持＋＊＃字符
	private static final String INPUT_TYPE_URL = "URL"; // URL键盘，支持.com按钮
														// 只支持URL字符
	private static final String INPUT_TYPE_ENG = "ENG"; // 英文键盘
	private static final String INPUT_TYPE_CHS = "CHS"; // 中文键盘
	private static final String INPUT_TYPE_NUM = "NUM"; // 数字键盘

	/**
	 * 每个UIview都会引用一个具体的model实例；
	 */
	private do_TextField_MAbstract model;
	private Drawable mClearDrawable;
	private boolean hasFoucs;

	public do_TextField_View(Context context) {
		super(context);
		this.setSingleLine(true);
		this.setPadding(10, 0, 1, 0);
	}

	/**
	 * 初始化加载view准备,_doUIModule是对应当前UIView的model实例
	 */
	@Override
	public void loadView(DoUIModule _doUIModule) throws Exception {
		this.model = (do_TextField_MAbstract) _doUIModule;
		this.setTextSize(TypedValue.COMPLEX_UNIT_PX, DoUIModuleHelper.getDeviceFontSize(_doUIModule, "9"));
		// 默认设置隐藏图标
		setClearIconVisible(false);
		// 设置焦点改变的监听
		setOnFocusChangeListener(this);
	}

	/**
	 * 动态修改属性值时会被调用，方法返回值为true表示赋值有效，并执行onPropertiesChanged，否则不进行赋值；
	 * 
	 * @_changedValues<key,value>属性集（key名称、value值）；
	 */
	@Override
	public boolean onPropertiesChanging(Map<String, String> _changedValues) {
		return true;
	}

	/**
	 * 属性赋值成功后被调用，可以根据组件定义相关属性值修改UIView可视化操作；
	 * 
	 * @_changedValues<key,value>属性集（key名称、value值）；
	 */
	@Override
	public void onPropertiesChanged(Map<String, String> _changedValues) {
		DoUIModuleHelper.handleBasicViewProperChanged(this.model, _changedValues);
		DoUIModuleHelper.setFontProperty(this.model, _changedValues);
		if (_changedValues.containsKey("hint")) {
			this.setHint(_changedValues.get("hint"));
		}
		if (_changedValues.containsKey("inputType")) {
			String value = _changedValues.get("inputType");
			if (value.equals(INPUT_TYPE_ASC)) {
				this.setInputType(InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_VARIATION_NORMAL);
			} else if (value.equals(INPUT_TYPE_PHONENUMBER)) {
				this.setInputType(InputType.TYPE_CLASS_PHONE);
			} else if (value.equals(INPUT_TYPE_URL)) {
				this.setInputType(InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_VARIATION_URI);
			} else if (value.equals(INPUT_TYPE_ENG)) {
				this.setInputType(InputType.TYPE_TEXT_FLAG_CAP_WORDS);
			} else if (value.equals(INPUT_TYPE_CHS)) {
				this.setInputType(InputType.TYPE_CLASS_TEXT);
			} else if (value.equals(INPUT_TYPE_NUM)) {
				this.setInputType(InputType.TYPE_CLASS_NUMBER | InputType.TYPE_NUMBER_FLAG_DECIMAL | InputType.TYPE_NUMBER_FLAG_SIGNED);
			}
		}
		if (_changedValues.containsKey("password")) {
			boolean bPassword = DoTextHelper.strToBool(_changedValues.get("password"), false);
			if (bPassword) {
				this.setInputType(InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_VARIATION_PASSWORD);
			} else {
				this.setInputType(InputType.TYPE_CLASS_TEXT | InputType.TYPE_NULL);
			}
		}
		if (_changedValues.containsKey("clearAll")) {
			boolean bClearAll = DoTextHelper.strToBool(_changedValues.get("clearAll"), false);
			if (bClearAll) {
				mClearDrawable = getCompoundDrawables()[2];
				if (mClearDrawable == null) {
					mClearDrawable = getResources().getDrawable(drawable.ic_input_delete);
				}
				mClearDrawable.setBounds(0, 0, mClearDrawable.getIntrinsicWidth(), mClearDrawable.getIntrinsicHeight());
			} else {
				mClearDrawable = null;
			}
		}
	}

	/**
	 * 同步方法，JS脚本调用该组件对象方法时会被调用，可以根据_methodName调用相应的接口实现方法；
	 * 
	 * @_methodName 方法名称
	 * @_dictParas 参数（K,V）
	 * @_scriptEngine 当前Page JS上下文环境对象
	 * @_invokeResult 用于返回方法结果对象
	 */
	@Override
	public boolean invokeSyncMethod(String _methodName, DoJsonNode _dictParas, DoIScriptEngine _scriptEngine, DoInvokeResult _invokeResult) throws Exception {
		// ...do something
		return false;
	}

	/**
	 * 异步方法（通常都处理些耗时操作，避免UI线程阻塞），JS脚本调用该组件对象方法时会被调用， 可以根据_methodName调用相应的接口实现方法；
	 * 
	 * @_methodName 方法名称
	 * @_dictParas 参数（K,V）
	 * @_scriptEngine 当前page JS上下文环境
	 * @_callbackFuncName 回调函数名 #如何执行异步方法回调？可以通过如下方法：
	 *                    _scriptEngine.callback(_callbackFuncName,
	 *                    _invokeResult);
	 *                    参数解释：@_callbackFuncName回调函数名，@_invokeResult传递回调函数参数对象；
	 *                    获取DoInvokeResult对象方式new DoInvokeResult(this.model.getUniqueKey());
	 */
	@Override
	public boolean invokeAsyncMethod(String _methodName, DoJsonNode _dictParas, DoIScriptEngine _scriptEngine, String _callbackFuncName) {
		// ...do something
		return false;
	}

	/**
	 * 释放资源处理，前端JS脚本调用closePage或执行removeui时会被调用；
	 */
	@Override
	public void onDispose() {
		// ...do something
	}

	private void doTextFieldView_TextChanged() {
		if (this.model.getCurrentPage().getScriptEngine() != null) { // 去除脚本还未加载时NULL的情况
			DoInvokeResult _invokeResult = new DoInvokeResult(this.model.getUniqueKey());
			this.model.getEventCenter().fireEvent("changed", _invokeResult);
		}
	}

	/**
	 * 因为我们不能直接给EditText设置点击事件，所以我们用记住我们按下的位置来模拟点击事件 当我们按下的位置 在 EditText的宽度 -
	 * 图标到控件右边的间距 - 图标的宽度 和 EditText的宽度 - 图标到控件右边的间距之间我们就算点击了图标，竖直方向就没有考虑
	 */
	@Override
	public boolean onTouchEvent(MotionEvent event) {
		if (event.getAction() == MotionEvent.ACTION_UP) {
			if (getCompoundDrawables()[2] != null) {
				boolean touchable = event.getX() > (getWidth() - getTotalPaddingRight()) && (event.getX() < ((getWidth() - getPaddingRight())));
				if (touchable) {
					this.setText("");
				}
			}
		}
		return super.onTouchEvent(event);
	}

	/**
	 * 当ClearEditText焦点发生变化的时候，判断里面字符串长度设置清除图标的显示与隐藏
	 */
	@Override
	public void onFocusChange(View v, boolean hasFocus) {
		this.hasFoucs = hasFocus;
		if (hasFocus) {
			setClearIconVisible(getText().length() > 0);
		} else {
			setClearIconVisible(false);
		}
	}

	/**
	 * 设置清除图标的显示与隐藏，调用setCompoundDrawables为EditText绘制上去
	 * 
	 * @param visible
	 */
	protected void setClearIconVisible(boolean visible) {
		Drawable right = visible ? mClearDrawable : null;
		setCompoundDrawables(getCompoundDrawables()[0], getCompoundDrawables()[1], right, getCompoundDrawables()[3]);
	}

	/**
	 * 当输入框里面内容发生变化的时候回调的方法
	 */
	@Override
	public void onTextChanged(CharSequence s, int start, int count, int after) {
		if (model == null)
			return;
		if (hasFoucs) {
			setClearIconVisible(getText().length() > 0);
		}
		model.setPropertyValue("text", getText().toString());
		doTextFieldView_TextChanged();
	}

	@Override
	public void beforeTextChanged(CharSequence s, int start, int count, int after) {
	}

	@Override
	public void afterTextChanged(Editable s) {
	}

	/**
	 * 重绘组件，构造组件时由系统框架自动调用；
	 * 或者由前端JS脚本调用组件onRedraw方法时被调用（注：通常是需要动态改变组件（X、Y、Width、Height）属性时手动调用）
	 */
	@Override
	public void onRedraw() {
		this.setLayoutParams(DoUIModuleHelper.getLayoutParams(this.model));
	}

	/**
	 * 获取当前model实例
	 */
	@Override
	public DoUIModule getModel() {
		return model;
	}
}
