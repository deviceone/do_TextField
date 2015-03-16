using doCore.Object;
using doExt.extdefine;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace doExt.extimplement
{
    /// <summary>
    /// 自定义扩展组件Model实现，继承@TYPEID_MAbstract抽象类；
    /// </summary>
    public class do_TextField_Model : do_TextField_MAbstract
    {
        public do_TextField_Model()
            : base()
        {
        }
        public override void OnInit()
        {
            base.OnInit();
            this.RegistProperty(new doProperty("text", PropertyDataType.String, "", false));
            this.RegistProperty(new doProperty("foreColor", PropertyDataType.String, "000000FF", false));
            this.RegistProperty(new doProperty("fontSize", PropertyDataType.String, "9", false));
            this.RegistProperty(new doProperty("fontStyle", PropertyDataType.String, "normal", false));
            this.RegistProperty(new doProperty("hint", PropertyDataType.String, "", true));
            this.RegistProperty(new doProperty("inputType", PropertyDataType.String, "ENG", true));
            this.RegistProperty(new doProperty("password", PropertyDataType.Bool, "false", true));
            this.RegistProperty(new doProperty("clearAll", PropertyDataType.Bool, "false", true));

        }
        public override async Task<bool> InvokeAsyncMethod(string _methodName, doCore.Helper.JsonParse.doJsonNode _dictParas, doCore.Interface.doIScriptEngine _scriptEngine, string _callbackFuncName)
        {
            if (await base.InvokeAsyncMethod(_methodName, _dictParas, _scriptEngine, _callbackFuncName)) return true;
            return false;
        }
        public override bool InvokeSyncMethod(string _methodName, doCore.Helper.JsonParse.doJsonNode _dictParas, doCore.Interface.doIScriptEngine _scriptEngine, doCore.Object.doInvokeResult _invokeResult)
        {
            if (base.InvokeSyncMethod(_methodName, _dictParas, _scriptEngine, _invokeResult)) return true;
            return false;
        }
    }
}
