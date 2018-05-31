<%-- Jessica Johnson 16 May 2018 --%>
<%-- Cshp DL230 Final Project --%>

<%@ Page Title="" Language="C#" MasterPageFile="~/FinalProject.Master" AutoEventWireup="true"  %>
<%@ Import namespace ="System.Data" %>
<%@ Import namespace ="System.Configuration" %>
<%@ Import namespace ="System.Data.SqlClient" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script runat="server">protected override void OnLoad(EventArgs e)
        {
            base.OnLoad(e);
            HttpCookie aCookie = Request.Cookies["Student"];
            if (aCookie == null)
            {
                Response.Redirect("Login.aspx");
            }
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            var ConnectionString = ConfigurationManager.ConnectionStrings["AdvWebDevProjectConnectionString"].ConnectionString;
            int result = 0;
            int studentId = Convert.ToInt32(((HiddenField)Master.FindControl("hdnStudentId")).Value);
            int classId = Convert.ToInt32(gridAvailableClasses.SelectedDataKey.Value);

            using (SqlConnection con = new SqlConnection(ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("pInsClassStudents", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@StudentId", studentId);
                    cmd.Parameters.AddWithValue("@ClassId", classId);
                    con.Open();
                    try
                    {
                        result = cmd.ExecuteNonQuery();
                    }
                    catch (Exception ex)
                    {
                        lblRegisterResult.Text = "Error: " + ex.Message;
                    }
                    if (result == 1) lblRegisterResult.Text = "Registration successful!";
                    gridMyClasses.DataBind();
                }
            }

        }
        protected void btnUnregister_Click(object sender, EventArgs e)
        {
            var ConnectionString = ConfigurationManager.ConnectionStrings["AdvWebDevProjectConnectionString"].ConnectionString;
            int result = 0;
            int studentId = Convert.ToInt32(((HiddenField)Master.FindControl("hdnStudentId")).Value);
            int classId = Convert.ToInt32(gridMyClasses.SelectedDataKey.Value);
            using (SqlConnection con = new SqlConnection(ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("pDelClassStudents", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@StudentId", studentId);
                    cmd.Parameters.AddWithValue("@ClassId", classId);
                    con.Open();
                    try
                    {
                        result = cmd.ExecuteNonQuery();
                    }
                    catch (Exception ex)
                    {
                        lblDropResult.Text = "Error: " + ex.Message;
                    }
                    if (result == 1) lblDropResult.Text = "Drop successful!";
                    gridMyClasses.DataBind();
                }
            }
        }
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="content" runat="server">
    <h1>Class Listing</h1>
    <h2>Classes available for registration</h2>
    <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
        ConnectionString="<%$ ConnectionStrings:AdvWebDevProjectConnectionString %>" 
        SelectCommand="SELECT * FROM [vClasses]"></asp:SqlDataSource>
    <asp:GridView ID="gridAvailableClasses" runat="server" AutoGenerateColumns="False" 
        DataKeyNames="ClassId" DataSourceID="SqlDataSource1">
        <Columns>
            <asp:CommandField ShowSelectButton="True" ButtonType="Button"></asp:CommandField>
            <asp:BoundField DataField="ClassId" HeaderText="ClassId" ReadOnly="True" SortExpression="ClassId" />
            <asp:BoundField DataField="ClassName" HeaderText="ClassName" SortExpression="ClassName" />
            <asp:BoundField DataField="ClassDate" HeaderText="ClassDate" SortExpression="ClassDate" />
            <asp:BoundField DataField="ClassDescription" HeaderText="ClassDescription" SortExpression="ClassDescription" />
        </Columns>
        <selectedrowstyle backcolor="LightCyan"
         forecolor="DarkBlue"
         font-bold="true"/>  
    </asp:GridView>

<br />
<asp:Button ID="btnRegister" Text="Register for Selected Class" runat="server" OnClick="btnRegister_Click"/>
    <br />
    <asp:Label ID="lblRegisterResult" runat="server"></asp:Label>
    <h2>Your current classes</h2>
    <asp:SqlDataSource ID="SqlDataSource2" runat="server" 
        ConnectionString="<%$ ConnectionStrings:AdvWebDevProjectConnectionString %>" 
        SelectCommand="pSelClassesByStudentID" SelectCommandType="StoredProcedure">
        <SelectParameters>
            <asp:ControlParameter ControlID="hdnStudentId" Name="StudentId" PropertyName="Value" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:GridView ID="gridMyClasses" runat="server" AutoGenerateColumns="False" 
        DataSourceID="SqlDataSource2" DataKeyNames="ClassId">
        <Columns>
            <asp:CommandField ShowSelectButton="True" ButtonType="Button"></asp:CommandField>
            <asp:BoundField DataField="ClassId" HeaderText="ClassId" SortExpression="ClassId" />
            <asp:BoundField DataField="ClassName" HeaderText="ClassName" SortExpression="ClassName" />
            <asp:BoundField DataField="ClassDate" HeaderText="ClassDate" SortExpression="ClassDate" />
            <asp:BoundField DataField="ClassDescription" HeaderText="ClassDescription" SortExpression="ClassDescription" />
        </Columns>
        <selectedrowstyle backcolor="LightCyan"
         forecolor="DarkBlue"
         font-bold="true"/> 
    </asp:GridView>
    <br />
<asp:Button ID="btnUnregister" Text="Drop Selected Class" runat="server" OnClick="btnUnregister_Click"/>
    <br />
    <asp:Label ID="lblDropResult" runat="server"></asp:Label>
</asp:Content>