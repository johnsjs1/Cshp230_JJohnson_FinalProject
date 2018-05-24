<%-- Jessica Johnson 16 May 2018 --%>
<%-- Cshp DL230 Final Project --%>

<%@ Page Title="" Language="C#" MasterPageFile="~/FinalProject.Master" AutoEventWireup="true"  %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="content" runat="server">
    <h1>Request a New Login</h1>
    <table style="width:50%;" border="1">
        <tr><td colspan="2">(Radio) New (Radio) Reactivate</td></tr>
        <tr><td>Name:&nbsp;</td><td><input id="Text1" type="text" /></td></tr>
        <tr><td>Email:&nbsp;</td><td><input id="Text1" type="text" /></td></tr>
        <tr><td>Login:&nbsp;</td><td><input id="Text1" type="text" /></td></tr>
        <tr><td>Reason:&nbsp;</td><td><input id="Text1" type="text" /></td></tr>
        <tr><td>NeededBy:&nbsp;</td><td><input id="Text1" type="text" /></td></tr>
    </table>
    <input id="Submit1" type="submit" value="submit" />
</asp:Content>