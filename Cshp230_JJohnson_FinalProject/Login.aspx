<%-- Jessica Johnson 16 May 2018 --%>
<%-- Cshp DL230 Final Project --%>
<%@ Page Title="" Language="C#" MasterPageFile="~/FinalProject.Master" AutoEventWireup="true"  %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="content" runat="server">
    <h1>Login</h1>
    <table style="width:50%;" border="1">
    <tr><td>Login:&nbsp;</td><td><asp:TextBox ID="TextBox1" runat="server" Text="StudentLogin"></asp:TextBox></td></tr>
    <tr><td>Password:&nbsp;</td><td><asp:TextBox ID="TextBox2" runat="server" Text="StudentPassword"></asp:TextBox></td></tr>
    </table>
</asp:Content>