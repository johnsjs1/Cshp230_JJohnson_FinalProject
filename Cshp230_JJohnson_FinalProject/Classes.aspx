<%-- Jessica Johnson 16 May 2018 --%>
<%-- Cshp DL230 Final Project --%>

<%@ Page Title="" Language="C#" MasterPageFile="~/FinalProject.Master" AutoEventWireup="true"  %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="content" runat="server">

        <h2>Class Listing</h2>
          <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
              ConnectionString="<%$ ConnectionStrings:AdvWebDevProjectConnectionString %>" 
              SelectCommand="SELECT * FROM [vClasses] ORDER BY [ClassName]">
          </asp:SqlDataSource>
    <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" DataKeyNames="ClassId" DataSourceID="SqlDataSource1">
        <Columns>
            <asp:BoundField DataField="ClassId" HeaderText="Id" ReadOnly="True" SortExpression="ClassId" />
            <asp:BoundField DataField="ClassName" HeaderText="Name" SortExpression="ClassName" />
            <asp:BoundField DataField="ClassDate" HeaderText="Date" SortExpression="ClassDate" />
            <asp:BoundField DataField="ClassDescription" HeaderText="Description" SortExpression="ClassDescription" />
        </Columns>
</asp:GridView>

</asp:Content>