//Jessica Johnson 24 May 2018
//Cshp DL230 Final Project

using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;


public class Class : IComparable<Class>
{
    public int Id { get; set; }
    public string Name { get; set; }
    public DateTime Date { get; set; } 
    public string Description { get; set; }

    public int CompareTo(Class other)
    {
        return String.Compare(this.Name, other.Name);
    }
    public override string ToString()
    {
        throw new NotImplementedException();
    }

    public Class(int id, string name, DateTime date, string description)
    {
        Id = id;
        Name = name;
        Date = date;
        Description = description;
    }
}

public class Classes : List<Class>
{
    public int CompareTo(Class other)
    {
        throw new NotImplementedException();
    }
}


