using System.Reflection;
using Microsoft.JavaScript.NodeApi;
using Microsoft.JavaScript.NodeApi.Runtime;

internal class Program
{
    public static async Task Main(string[] args)
    {
        string baseDir = Path.Combine(Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location)!, "js");
        string libnodePath = Path.Combine(baseDir, "libnode.so.115");

        var nodejsPlatform = new NodejsPlatform(libnodePath);
        using var nodejs = nodejsPlatform.CreateEnvironment(baseDir);

        await Foo(nodejs);
    }

    private static async Task Foo(NodejsEnvironment nodejs)
    {
        var bar = "abcd";
        await nodejs.RunAsync(async () =>
        {
            JSValue abcd = nodejs.Import("./abcd.js");
            var ret = abcd.CallMethod("foo", bar);
            DisplayJsValue(ret);
            ret = abcd.CallMethod("afoo", bar);
            var promice = (JSPromise)ret;
            ret = await promice.AsTask();
            DisplayJsValue(ret);

            return Task.CompletedTask;
        });
    }

    static void DisplayJsValue(JSValue ret)
    {
        switch (ret.TypeOf())
        {
            case JSValueType.String:
                Console.WriteLine((string)ret);
                break;
            case JSValueType.Number:
                Console.WriteLine((double)ret);
                break;
            case JSValueType.Boolean:
                Console.WriteLine((bool)ret);
                break;
            case JSValueType.Object:
                var  arr = ret.AsArray();
                if (arr is not null)
                {
                    Console.WriteLine("[");
                    foreach (var item in arr)
                    {
                        DisplayJsValue(item);
                        Console.WriteLine(",");
                    }
                    Console.WriteLine("]");

                    return;
                }


                // var arr = (JSArray)ret;
                // DisplayJsValue(arr[0]);
                Console.WriteLine(ret.ToString());
                break;
            case JSValueType.Undefined:
                Console.WriteLine("undefined");
                break;
            case JSValueType.Null:
                Console.WriteLine("null");
                break;
            case JSValueType.Symbol:
                Console.WriteLine(ret.ToString());
                break;
            case JSValueType.Function:
                Console.WriteLine(ret.ToString());
                break;
            case JSValueType.External:
                Console.WriteLine(ret.ToString());
                break;
            case JSValueType.BigInt:
                Console.WriteLine((string)ret);
                break;
            default:
                throw new ArgumentOutOfRangeException();
        }
    }


}
static class JSValueExtensions
{
    public static JSArray? AsArray(this JSValue value)
    {
        try
        {
            var arr = (JSArray)value;
            var x = arr.Length;
            return arr;
        }
        catch (JSException exception)
        {
            return null;
        }

    }
}