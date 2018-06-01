using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace CShp230_JJohnson_FInalProjectMVC.Models
{
    [MetadataType(typeof(StudentValidation))]
    public partial class vStudent { }

    public class StudentValidation
    {
        [Display(Name ="Student Number")]
        public int StudentId { get; set; }

        [Display(Name ="Student Name")]
        public string StudentName { get; set; }

        [Display(Name ="Student Email")]
        [DataType(DataType.EmailAddress)]
        public string StudentEmail { get; set; }

        [Display(Name ="Student Login")]
        [Required]
        public string StudentLogin { get; set; }

        [Display(Name ="Student Password")]
        [Required]
        [DataType(DataType.Password)]
        public string StudentPassword { get; set; }
    }
}