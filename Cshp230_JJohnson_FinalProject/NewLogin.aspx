<%-- Jessica Johnson 16 May 2018 --%>
<%-- Cshp DL230 Final Project --%>

<%@ Page Title="" Language="C#" MasterPageFile="~/FinalProject.Master" AutoEventWireup="true"  %>
<%@ Import namespace ="System.Data" %>
<%@ Import namespace ="System.Configuration" %>
<%@ Import namespace ="System.Data.SqlClient" %>

<script runat="server">
    protected void Page_PreRender(object sender, EventArgs e)
    {
        RangeValidator1.MinimumValue = DateTime.Today.ToString("dd-MM-yy");
        RangeValidator1.MaximumValue = DateTime.Today.AddYears(1).ToString("dd-MM-yy");
        txtNeedBy.Text = DateTime.Today.AddDays(7).ToString("dd-MM-yy");
    }
    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        int result=0;
        var ConnectionString = ConfigurationManager.ConnectionStrings["AdvWebDevProjectConnectionString"].ConnectionString;
        using (SqlConnection con = new SqlConnection(ConnectionString))
        {
            using (SqlCommand cmd = new SqlCommand("pInsLoginRequests", con))
            {
                DateTime _needDate = DateTime.Parse(txtNeedBy.Text);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@Name", txtLogin.Text);
                cmd.Parameters.AddWithValue("@EmailAddress", txtEmail.Text);
                cmd.Parameters.AddWithValue("@LoginName", txtLogin.Text);
                cmd.Parameters.AddWithValue("@NewOrReactivate", rdoRequestType.Text);
                cmd.Parameters.AddWithValue("@ReasonForAccess", txtReason.Text);
                cmd.Parameters.AddWithValue("@DateRequiredBy", DateTime.Parse(txtNeedBy.Text));
                SqlParameter retval = new SqlParameter(@"LoginID",DbType.Int32);
                retval.Direction = ParameterDirection.Output;
                cmd.Parameters.Add(retval);
                con.Open();
                try {
                    result = cmd.ExecuteNonQuery();
                } catch (Exception ex) {
                    lblResult.Text = "Error: " + ex.Message;
                }
                if (result == 1) lblResult.Text = "Request submitted successfully.";
            }
        }
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

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
    <br />
    <table >
        <tr><th colspan="2">Request Account</th></tr>
        <tr><td colspan="2"  style="text-align:left">
            <asp:RadioButtonList ID="rdoRequestType" runat="server" RepeatDirection="Horizontal" repeatlayout="Flow">
                <asp:ListItem Selected=True>New</asp:ListItem>
                <asp:ListItem>Reactivate</asp:ListItem>
            </asp:RadioButtonList>
        </td>
        </tr>
        <tr>
            <td>Name:&nbsp;</td>
            <td>
                <asp:TextBox runat="server" ID="txtName" />
                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="*" ControlToValidate="txtName" ForeColor="Red"></asp:RequiredFieldValidator>
            </td>
        </tr>
        <tr>
            <td>Email:&nbsp;</td>
            <td>
                <asp:TextBox runat="server" ID="txtEmail" TextMode="Email" />
                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="*" ControlToValidate="txtEmail" ForeColor="Red"></asp:RequiredFieldValidator>
            </td>
        </tr>
        <tr>
            <td>Login:&nbsp;</td>
            <td>
                <asp:TextBox runat="server" ID="txtLogin"  />
                <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ErrorMessage="*" ControlToValidate="txtLogin" ForeColor="Red"></asp:RequiredFieldValidator>
            </td>
        </tr>
                <tr>
            <td>Need By:&nbsp;</td>
            <td>
                <asp:TextBox runat="server" ID="txtNeedBy" TextMode="DateTime" />
                <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ErrorMessage="*" ControlToValidate="txtNeedBy" ForeColor="Red"></asp:RequiredFieldValidator>
                <asp:CompareValidator id="dateValidator" runat="server" Type="Date" Operator="DataTypeCheck" ControlToValidate="txtNeedBy" ErrorMessage="Invalid Date" ForeColor="Red"></asp:CompareValidator>
                <asp:RangeValidator ID="RangeValidator1" runat="server" ErrorMessage="Date outside acceptable range" ControlToValidate="txtNeedBy" ForeColor="Red" Type="Date"></asp:RangeValidator>
            </td>
        </tr>
        <tr>
            <td>Reason:&nbsp;</td>
            <td>
                <asp:TextBox runat="server" ID="txtReason" MaxLength="250" TextMode="MultiLine" Width="250px" />
                <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ErrorMessage="*" ControlToValidate="txtReason" ForeColor="Red"></asp:RequiredFieldValidator>
            </td>
        </tr></table>

        <div style="text-align: center">
                <asp:Button ID="btnSubmit" Text="Submit" runat="server" OnClick="btnSubmit_Click" /><br />
                <asp:Label ID="lblResult" runat="server" />
            </div>
    
    
</asp:Content>