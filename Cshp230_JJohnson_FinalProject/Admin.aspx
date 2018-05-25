<%-- Jessica Johnson 24 May 2018 --%>
<%-- Cshp DL230 Final Project --%>

<%@ Page Title="" Language="C#" MasterPageFile="~/FinalProject.Master" AutoEventWireup="true" %>
<%@ import Namespace="System.Configuration" %>
<%@ import Namespace="System.Web.Configuration" %>
<%@ import Namespace="System.Data.SqlClient" %>

<asp:Content ID="Content3" ContentPlaceHolderID="head" runat="server">
    <script runat="server">
        protected void ConnectionData() {
            //Configuration config = System.Web.Configuration.WebConfigurationManager.OpenWebConfiguration("~/Web.Debug.config");
            //ConnectionStringSettings connString;
            //if (config.ConnectionStrings.ConnectionStrings.Count > 0) {
            //    connString = config.ConnectionStrings.ConnectionStrings["FinalProjectDatabase"];
            //    if (connString != null) { Response.Write($"FinalProjectDatabase ={connString.ConnectionString}"); }
            //    else Response.Write("No database string found.");

            ConnectionStringSettingsCollection settings = ConfigurationManager.ConnectionStrings;
            StringBuilder sb = new StringBuilder();
            if (settings != null)
            {
                sb.Append($"{settings.Count} settings found: <br />");
                foreach (ConnectionStringSettings cs in settings)
                {
                    sb.Append($"{cs.Name}:{cs.ConnectionString} <br />");
                }
            }
            else sb.Append("No connection string settings found.");
            divConnections.InnerHtml = sb.ToString();
        }
        protected void LoginData()
        {
            StringBuilder sb = new StringBuilder();
            using (SqlConnection connection = new SqlConnection("Data Source=." +
                "Initial Catalog=AdvWebDevProject;Integrated Security=True;Connect Timeout=30;Encrypt=False;" +
                "TrustServerCertificate=False;ApplicationIntent=ReadWrite;MultiSubnetFailover=False"))
            {
                using (SqlCommand command = new SqlCommand("Select * from dbo.LoginRequests",connection))
                {
                    connection.Open();
                    var result = command.BeginExecuteReader();
                    
                }
            }
        }

        protected void PopulateDataClick(object sender, EventArgs e)
        {
            ConnectionData();
        }
</script>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="content" runat="server">
    <h1>Admin</h1>
    <h2>Connection Strings</h2>
    <div id="divConnections" runat="server" /><br />
    <h2>Login Requests</h2>
    <div id="divLoginTable" runat="server" /><br />
    <h2>All Students</h2>
    <div id="divStudentTable" runat="server" /><br />
    <h2>All Classes</h2>
    <div id="divClassesTable" runat="server" /><br />
<asp:Button runat="server" Text="Populate Data" OnClick="PopulateDataClick"/>
</asp:Content>
 
