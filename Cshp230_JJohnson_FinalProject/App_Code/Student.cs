//Jessica Johnson 24 May 2018
//Cshp DL230 Final Project

using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;


public class Student : IComparable<Student>
{
    public int Id { get; set; }
    public string Name { get; set; }
    public string Email { get; set; }
    public string Login { get; set; }
    public string Password { get; set; }

    public int CompareTo(Student other)
    {
        return String.Compare(this.Login, other.Login);
    }
    public override string ToString()
    {
        throw new NotImplementedException();
    }

    public Student(int id, string name, string email, string login, string password)
    {
        Id = id;
        Name = name;
        Email = email;
        Login = login;
        Password = password;
    }
}

public class Students : List<Student> { }

