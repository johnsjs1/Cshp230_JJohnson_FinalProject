<%-- Jessica Johnson 16 May 2018 --%>
<%-- Cshp DL230 Final Project --%>

<%@ Page Title="" Language="C#" MasterPageFile="~/FinalProject.Master" AutoEventWireup="true"  %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="content" runat="server">
    <p class="Note">If not logged in, redirect to classes.aspx - or combine this page with classes.aspx and show content based upon login status</p>
    <h1>Class Listing</h1>
    <h2>Classes available for registration</h2>
    <table style="width:100%;" border="1">
        <tr><td>Select</td><td>Name</td><td>Date</td><td>Description</td></tr>
        <tr><td><input id="Checkbox1" type="checkbox" /></td><td>ClassName </td><td>ClassDate</td><td>ClassDescription</td></tr>
        <tr><td><input id="Checkbox1" type="checkbox" /></td><td>ClassName </td><td>ClassDate</td><td>ClassDescription</td></tr>
        <tr><td><input id="Checkbox1" type="checkbox" /></td><td>ClassName </td><td>ClassDate</td><td>ClassDescription</td></tr>
    </table>
    <input id="Submit1" type="submit" value="Register for Selected Classes" />
    <h2>Your current classes</h2>
    <table style="width:100%;" border="1">
        <tr><td>Name</td><td>Date</td><td>Description</td></tr>
        <tr><td>ClassName </td><td>ClassDate</td><td>ClassDescription</td></tr>
        <tr><td>ClassName </td><td>ClassDate</td><td>ClassDescription</td></tr>
        <tr><td>ClassName </td><td>ClassDate</td><td>ClassDescription</td></tr>
    </table>
</asp:Content>