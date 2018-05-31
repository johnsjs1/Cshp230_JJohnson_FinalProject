<%-- Jessica Johnson 16 May 2018 --%>
<%-- Cshp DL230 Final Project --%>

<%@ Page Title="" Language="C#" MasterPageFile="~/FinalProject.Master" AutoEventWireup="true"  %>
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

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="content" runat="server">
    <h1>My Classes</h1>
    <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
        ConnectionString="<%$ ConnectionStrings:AdvWebDevProjectConnectionString %>" 
        SelectCommand="pSelClassesByStudentID" SelectCommandType="StoredProcedure">
        <SelectParameters>
            <asp:ControlParameter Name="StudentId" ControlID="hdnStudentId" PropertyName="Value" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" DataSourceID="SqlDataSource1">
        <Columns>
            <asp:BoundField DataField="ClassId" HeaderText="ClassId" SortExpression="ClassId" />
            <asp:BoundField DataField="ClassName" HeaderText="ClassName" SortExpression="ClassName" />
            <asp:BoundField DataField="ClassDate" HeaderText="ClassDate" SortExpression="ClassDate" />
            <asp:BoundField DataField="ClassDescription" HeaderText="ClassDescription" SortExpression="ClassDescription" />
        </Columns>
    </asp:GridView>
</asp:Content>