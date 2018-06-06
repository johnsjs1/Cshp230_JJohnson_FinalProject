<%-- Jessica Johnson 24 May 2018 --%>
<%-- Cshp DL230 Final Project --%>

<%@ Page Title="" Language="C#" MasterPageFile="~/FinalProject.Master" AutoEventWireup="true" %>

<%@ Import Namespace="System.Configuration" %>
<%@ Import Namespace="System.Web.Configuration" %>
<%@ Import Namespace="System.Data.SqlClient" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script runat="server">
        protected void ConnectionStrings()
        {
            Configuration rootWebConfig = WebConfigurationManager.OpenWebConfiguration("~/");
            if (rootWebConfig.ConnectionStrings.ConnectionStrings.Count > 0)
            {
                foreach (ConnectionStringSettings connString in rootWebConfig.ConnectionStrings.ConnectionStrings)
                {
                    if (connString != null)
                        Response.Write($"{connString.Name}: {connString.ConnectionString}<br />");
                }
            }
            else Response.Write($"No Connection Strings found in your web.config file.<br />");
        }
  protected void gridLoginRequests_RowCommand(Object sender, GridViewCommandEventArgs e)
  {
    // If multiple buttons are used in a GridView control, use the
    // CommandName property to determine which button was clicked.
    if(e.CommandName=="Delete")
    {
      // Convert the row index stored in the CommandArgument
      // property to an Integer.
      int index = Convert.ToInt32(e.CommandArgument);

                GridViewRow row = gridLoginRequests.Rows[index];
                int requestId = row.DataItemIndex;
                var ConnectionString = ConfigurationManager.ConnectionStrings["AdvWebDevProjectConnectionString"].ConnectionString;
            int result = 0;
            
            using (SqlConnection con = new SqlConnection(ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("pDelLoginRequests", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@LoginId", requestId);
                    con.Open();
                    try
                    {
                        result = cmd.ExecuteNonQuery();
                    }
                    catch (Exception ex)
                    {

                    }
                }
            }


    }
  }    
</script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="content" runat="server">
    <h2>Login Requests</h2>
    <div id="divLoginTable" runat="server" />
    <asp:SqlDataSource ID="SqlDataSource3" runat="server"
        ConnectionString="<%$ ConnectionStrings:AdvWebDevProjectConnectionString %>"
        SelectCommand="SELECT * FROM [LoginRequests]"></asp:SqlDataSource>
    <asp:GridView ID="gridLoginRequests" runat="server" AutoGenerateColumns="False" 
        DataKeyNames="LoginId" DataSourceID="SqlDataSource3" onrowcommand="gridLoginRequests_RowCommand">
        <Columns>
            <asp:BoundField DataField="LoginId" HeaderText="LoginId" InsertVisible="False" ReadOnly="True" SortExpression="LoginId" />
            <asp:BoundField DataField="Name" HeaderText="Name" SortExpression="Name" />
            <asp:BoundField DataField="EmailAddress" HeaderText="EmailAddress" SortExpression="EmailAddress" />
            <asp:BoundField DataField="LoginName" HeaderText="LoginName" SortExpression="LoginName" />
            <asp:BoundField DataField="NewOrReactivate" HeaderText="NewOrReactivate" SortExpression="NewOrReactivate" />
            <asp:BoundField DataField="ReasonForAccess" HeaderText="ReasonForAccess" SortExpression="ReasonForAccess" />
            <asp:BoundField DataField="DateRequiredBy" HeaderText="DateRequiredBy" SortExpression="DateRequiredBy" DataFormatString="{0:dd-MM-yyyy}" />
            <asp:ButtonField ButtonType="Button" CommandName="Delete" Text="Delete" />
        </Columns>
    </asp:GridView>
    <br />
    <br />
    <h2>All Students</h2>
    <asp:SqlDataSource ID="SqlDataSource1" runat="server"
        ConnectionString="<%$ ConnectionStrings:AdvWebDevProjectConnectionString %>"
        SelectCommand="SELECT * FROM [Students]"></asp:SqlDataSource>
    <asp:GridView runat="server" AutoGenerateColumns="False" DataKeyNames="StudentId" DataSourceID="SqlDataSource1">
        <Columns>
            <asp:BoundField DataField="StudentId" HeaderText="StudentId" ReadOnly="True" SortExpression="StudentId" />
            <asp:BoundField DataField="StudentName" HeaderText="StudentName" SortExpression="StudentName" />
            <asp:BoundField DataField="StudentEmail" HeaderText="StudentEmail" SortExpression="StudentEmail" />
            <asp:BoundField DataField="StudentLogin" HeaderText="StudentLogin" SortExpression="StudentLogin" />
            <asp:BoundField DataField="StudentPassword" HeaderText="StudentPassword" SortExpression="StudentPassword" />
        </Columns>
    </asp:GridView>
    <br />
    <h2>All Classes</h2>
    <asp:SqlDataSource ID="SqlDataSource2" runat="server"
        ConnectionString="<%$ ConnectionStrings:AdvWebDevProjectConnectionString %>"
        SelectCommand="SELECT * FROM [Classes]"></asp:SqlDataSource>
    <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" DataKeyNames="ClassId" DataSourceID="SqlDataSource2">
        <Columns>
            <asp:BoundField DataField="ClassId" HeaderText="ClassId" ReadOnly="True" SortExpression="ClassId" />
            <asp:BoundField DataField="ClassName" HeaderText="ClassName" SortExpression="ClassName" />
            <asp:BoundField DataField="ClassDate" HeaderText="ClassDate" SortExpression="ClassDate" DataFormatString="{0:dd-MM-yyyy}" />
            <asp:BoundField DataField="ClassDescription" HeaderText="ClassDescription" SortExpression="ClassDescription" />
        </Columns>
    </asp:GridView>
</div>
</asp:Content>
