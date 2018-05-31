//Jessica Johnson 24 May 2018
//Cshp DL230 Final Project

using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

public class LoginRequest
{
    public int Id { get; set; }
    public string Name { get; set; }
    public string Email { get; set; }
    public string Login { get; set; }
    public string Type { get; set; } //New or Reactivate
    public string Reason { get; set; }
    public DateTime NeededBy { get; set; }

    public override string ToString()
    {
        throw new NotImplementedException();
    }

    public LoginRequest(string name, string email, string login, string type, string reason, DateTime neededBy)
    {
        Name = name;
        Email = email;
        Login = login;
        Type = type;
        Reason = reason;
        NeededBy = neededBy;
    }
}
