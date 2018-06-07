<%-- Jessica Johnson 16 May 2018 --%>
<%-- Cshp DL230 Final Project --%>

<%@ Page Title="" Language="C#" MasterPageFile="~/FinalProject.Master" AutoEventWireup="true" %>
<%@ Import namespace ="System.Data" %>
<%@ Import namespace ="System.Configuration" %>
<%@ Import namespace ="System.Data.SqlClient" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script runat="server">protected void Submit_Click(object sender, EventArgs e)
        {
            var ConnectionString= ConfigurationManager.ConnectionStrings["AdvWebDevProjectConnectionString"].ConnectionString;
            string result;
            using (SqlConnection con = new SqlConnection(ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("pSelLoginIdByLoginAndPassword", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@StudentLogin", txtLogin.Text);
                    cmd.Parameters.AddWithValue("@StudentPassword", txtPassword.Text);
                    cmd.Parameters.Add("@StudentId", SqlDbType.SmallInt);
                    cmd.Parameters["@StudentId"].Direction = ParameterDirection.Output;
                    con.Open();
                    try {
                        cmd.ExecuteNonQuery();
                        result= cmd.Parameters["@StudentId"].Value.ToString();
                    } catch
                    {
                        result = null;
                    }
                }
            }
            if (!string.IsNullOrEmpty(result))
            {
                Response.Cookies["Student"]["Login"] = txtLogin.Text;
                Response.Cookies["Student"]["Id"] = result;
                Response.Cookies["Student"].Expires = DateTime.Now.AddMinutes(30);
                Response.Redirect("Home.aspx");
            }
            else
            {
                LoginFailed.Text = "Invalid Credentials";
            }
        }
</script>
    <style>
        table {
            border-collapse: collapse;
            border-spacing: 0;
            width: 600px;
            display: table;
            margin: auto;
            border:solid;
        }
        th {
            text-align:center;
            background-color:slategray;
        }

        td, th {
            padding: 8px 8px;
            display: table-cell;
            vertical-align: top
        }
        /* make the first cell of every row bold */
tr td:FIRST-CHILD{
    font-weight:bold;
    text-align: right;
}
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="content" runat="server">
        <div>
        <br />
        <table>
            <tr><th colspan="2">Log In</th></tr>
            <tr>
                <td>Login:&nbsp;</td>
                <td>
                    <asp:TextBox ID="txtLogin" runat="server" Text=""></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server"
            ControlToValidate="txtLogin"
            ErrorMessage="*"
            ForeColor="Red">
        </asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr>
                <td> Password:&nbsp;</td>
                <td>
                    <asp:TextBox ID="txtPassword" runat="server" Text="" TextMode="Password"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server"
            ControlToValidate="txtPassword"
            ErrorMessage="*"
            ForeColor="Red">
        </asp:RequiredFieldValidator></td>
            </tr></table>  
            <div style="text-align:center">
                <asp:Button id="Submit" runat="server" Text="Log In" OnClick="Submit_Click"/><br />
                <p><a href="NewLogin.aspx">Request a new account</a></p>
                <asp:Label ID="LoginFailed" runat="server" ></asp:Label>
                </div>
              
    </div>
</asp:Content>
