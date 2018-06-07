<%-- Jessica Johnson 16 May 2018 --%>
<%-- Cshp DL230 Final Project --%>

<%@ Page Title="" Language="C#" MasterPageFile="~/FinalProject.Master" AutoEventWireup="true" %>
<%@ Import namespace ="System.Data" %>
<%@ Import namespace ="System.Configuration" %>
<%@ Import namespace ="System.Data.SqlClient" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script runat="server">protected override void OnLoad(EventArgs e)
            {
                base.OnLoad(e);
                HttpCookie aCookie = Request.Cookies["Student"];
            aCookie.Expires = DateTime.Now.AddDays(-1);
            Response.Cookies.Add(aCookie);

            ((HiddenField)Master.FindControl("hdnStudentId")).Value = "";
            ((HiddenField)Master.FindControl("hdnStudentLogin")).Value = "";
            Response.Redirect("Login.aspx");
        }
</script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="content" runat="server">
</asp:Content>
