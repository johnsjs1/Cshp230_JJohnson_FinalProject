//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace CShp230_JJohnson_FInalProjectMVC.Models
{
    using System;
    using System.Collections.Generic;
    
    public partial class vClass
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public vClass()
        {
            this.vStudents = new HashSet<vStudent>();
        }
    
        public int ClassId { get; set; }
        public string ClassName { get; set; }
        public System.DateTime ClassDate { get; set; }
        public string ClassDescription { get; set; }
        public int vClassStudentClassId { get; set; }
        public int vClassStudentStudentId { get; set; }
    
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<vStudent> vStudents { get; set; }
    }
}
