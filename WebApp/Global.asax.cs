using System;
using System.Web.UI;

namespace StudentFeedbackSystem
{
    public class Global : System.Web.HttpApplication
    {
        protected void Application_Start(object sender, EventArgs e)
        {
            ScriptManager.ScriptResourceMapping.AddDefinition(
                "jquery",
                new ScriptResourceDefinition
                {
                    Path = "~/Scripts/jquery-3.7.1.min.js",
                    DebugPath = "~/Scripts/jquery-3.7.1.js",
                    CdnPath = "https://ajax.aspnetcdn.com/ajax/jQuery/jquery-3.7.1.min.js",
                    CdnDebugPath = "https://ajax.aspnetcdn.com/ajax/jQuery/jquery-3.7.1.js"
                });

            // Nothing DI-container-specific yet — repositories/services are
            // newed up directly (see each Service's parameterless ctor).
            // Swap in a container (Autofac/Unity) here if the app grows.
        }

        protected void Application_Error(object sender, EventArgs e)
        {
            var ex = Server.GetLastError();
            // TODO: plug in real logging (e.g. Serilog to file/DB) before production.
            System.Diagnostics.Trace.TraceError(ex?.ToString());
        }

        protected void Session_Start(object sender, EventArgs e) { }

        protected void Application_End(object sender, EventArgs e) { }
    }
}
