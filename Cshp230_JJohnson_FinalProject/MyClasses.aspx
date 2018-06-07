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
    <asp:SqlDataSource ID="ClassesByStudent" runat="server" 
        ConnectionString="<%$ ConnectionStrings:AdvWebDevProjectConnectionString %>" 
         SelectCommand="SELECT [ClassId], [ClassName], [ClassDate], [ClassDescription] 
        FROM [vClassesByStudents] WHERE ([StudentId] = @StudentId)" ProviderName="System.Data.SqlClient">
        <SelectParameters>
            <asp:ControlParameter ControlID="hdnStudentId" 
                Name="StudentId" PropertyName="Value" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:GridView ID="gridClasses" runat="server" AutoGenerateColumns="False" 
        DataSourceID="ClassesByStudent" DataKeyNames="ClassId">
        <Columns>
            <asp:BoundField DataField="ClassId" HeaderText="ClassId" SortExpression="ClassId" ReadOnly="True" />
            <asp:BoundField DataField="ClassName" HeaderText="ClassName" SortExpression="ClassName" />
            <asp:BoundField DataField="ClassDate" HeaderText="ClassDate" SortExpression="ClassDate" />
            <asp:BoundField DataField="ClassDescription" HeaderText="ClassDescription" SortExpression="ClassDescription" />
        </Columns>
    </asp:GridView>
</asp:Content>